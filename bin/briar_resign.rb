#!/usr/bin/env ruby

require 'fileutils'
require 'CFPropertyList'
require 'rexml/document'
require 'tmpdir'
require 'find'

def msg(title, &block)
  puts "\n" + '-'*10 + title + '-'*10
  block.call
  puts '-'*10 + '-------' + '-'*10 + "\n"
end

def briar_resign(args)
  if args.length < 4
    msg('Usage') do
      puts 'briar resign </path/to/your.ipa> </path/to/your.mobileprovision> <wildcard-prefix> <signing-identity> <optional-application-id>'
    end
    exit 1
  end

  ipa = args[0]
  unless ipa.end_with?('.ipa')
    msg('Error') do
      puts 'first arg must be an ipa'
    end
    exit 1
  end

  unless File.exist? ipa
    msg('Error') do
      puts ".ipa must exist at path '#{ipa}'"
    end
    exit 1
  end

  mobile_prov = args[1]
  unless mobile_prov.end_with?('.mobileprovision')
    msg('Error') do
      puts 'second arg must be a path to a mobileprovision'
    end
    exit 1
  end

  unless File.exist? mobile_prov
    msg('Error') do
      puts "'#{mobile_prov}' must exist at path"
    end
    exit 1
  end

  wildcard = args[2]
  unless wildcard.length == 10
    msg 'error' do
      puts "'#{wildcard}' must have 10 characters eg 'RWTD8QPG2C'"
    end
    exit 1
  end

  unless system("grep #{wildcard} #{mobile_prov}")
    msg 'error' do
      puts "could not find wildcard '#{wildcard}' in '#{mobile_prov}'"
    end
    exit 1
  end

  signing_id = args[3]
  msg ('Info') do
    puts "will resign with identity '#{signing_id}'"
  end

  options = {:ipa => ipa,
             :provision => mobile_prov,
             :id => signing_id,
             :wildcard => wildcard}

  if args.length == 5
    app_id = args[4]
    puts "INFO: will resign with a new application id '#{app_id}'"
    options[:app_id] = app_id
  end

  resign_ipa(options)

end

def resign_ipa(options)
  work_dir = 'resigned'
  ipa = File.join(work_dir, File.basename(options[:ipa]))
  mp = File.join(work_dir, File.basename(options[:provision]))

  puts 'INFO: making a directory to put the resigned ipa in'
  if File.exist? work_dir
    puts "INFO: found an existing work directory at '#{work_dir}' - removing it"
    unless system("rm -rf #{work_dir}")
      msg 'Error' do
        puts "could not remove existing work dir '#{work_dir}'"
      end
      exit 1
    end
  end

  unless system("mkdir #{work_dir}")
    msg 'Error' do
      puts "could not create a work directory '#{work_dir}'"
    end
    exit 1
  end

  puts "INFO: copying assets to '#{work_dir}'"
  unless system("cp #{options[:ipa]} #{ipa}")
    msg 'Error' do
      puts "could not copy '#{options[:ipa]}' to '#{ipa}'"
    end
    exit 1
  end

  unless system("cp #{options[:provision]} #{mp}")
    msg 'Error' do
      puts "could not copy #{options[:provision]} to #{mp}"
    end
    exit 1
  end

  puts "unzipping '#{ipa}'"
  unless system("unzip -qq #{ipa} -d #{work_dir}")
    msg ('Error') do
      puts "could not unzip -qq #{ipa} to '#{work_dir}'"
    end
    exit 1
  end

  payload_dir = "#{work_dir}/Payload"
  unless File.directory?(payload_dir)
    msg 'error' do
      puts "Did not find a 'Payload' directory inside .ipa"
    end
    exit 1
  end

  app_path = Dir.foreach(payload_dir).find { |x| /.*\.app/.match(x) }

  abs_app_path = "#{payload_dir}/#{app_path}"
  puts "INFO: found app at '#{abs_app_path}'"


  info_plist = Dir.foreach(abs_app_path).find { |x| /^Info\.plist$/.match(x) }

  if info_plist.nil?
    msg 'error' do
      puts 'could not find an *-Info.plist file'
    end
    exit 1
  end

  info_plist_path = "#{abs_app_path}/#{info_plist}"
  puts "INFO: found info plist at '#{info_plist_path}'"


  mp_id = File.basename(mp, '.mobileprovision')
  puts "INFO: found mobile provision id '#{mp_id}'"

  puts "INFO: replacing embedded.mobileprovision with '#{mp}'"

  unless system("cp \"#{mp}\" \"#{abs_app_path}/embedded.mobileprovision\"")
    msg 'error' do
      puts "could not cp '#{mp}' to '#{abs_app_path}/embedded.mobileprovision'"
    end
    exit 1
  end


  plist = CFPropertyList::List.new(:file => info_plist_path)
  data = CFPropertyList.native_types(plist.value)

  if data.nil? or !data.is_a? Hash
    msg 'error' do
      puts "Unable to parse binary plist: #{info_plist_path}"
    end
  end

  puts "INFO: parsed plist at '#{info_plist_path}'"

  app_id = options[:app_id] ? options[:app_id] : data['CFBundleIdentifier']
  unless app_id
    msg 'error' do
      puts "Unable to find CFBundleIdentifier in plist '#{data}'"
    end
    exit 1
  end

  puts "INFO: found bundle identifier '#{app_id}'"
  # Save changes to plist
  unless data['CFBundleIdentifier'] == app_id
    puts "INFO: saving the new bundle identifier '#{app_id}' to plist file"
    data['CFBundleIdentifier'] = app_id
    plist.value = CFPropertyList.guess(data)
    plist.save(info_plist_path, CFPropertyList::List::FORMAT_XML)
  end



  bundle_exec = data['CFBundleExecutable']
  
  unless bundle_exec
    msg 'error' do
      puts "unable to find CFBundleExecutable in plist '#{data}'"
    end
    exit 1
  end
  
  puts "INFO: found bundle executable '#{bundle_exec}'"

  appname = app_path.split('.app')[0]

  puts "INFO: found appname '#{appname}'"

  wildcard = options[:wildcard]
  puts "INFO: creating new entitlements with '#{wildcard}'"
  ios_entitlements_path = File.join(work_dir, 'new-entitlements.plist')
  File.open(ios_entitlements_path, 'a+') do |file|
    file.puts "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    file.puts "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">"
    file.puts "<plist version=\"1.0\">"
    file.puts '<dict>'
    file.puts '  <key>application-identifier</key>'
    file.puts "    <string>#{wildcard}.#{app_id}</string>"
    file.puts '  <key>keychain-access-groups</key>'
    file.puts '    <array>'
    file.puts "      <string>#{wildcard}.#{app_id}</string>"
    file.puts '    </array>'
    file.puts '  <key>get-task-allow</key>'
    file.puts '    <true/>'
    file.puts '</dict>'
    file.puts '</plist>'
  end

  # did _not_ work
  #entitlements = CFPropertyList::List.new(:file => ios_entitlements_path)
  #data = CFPropertyList.native_types(entitlements.value)
  #data['application-identifier']= "#{wildcard}.#{app_id}"
  #data['keychain-access-groups']=["#{wildcard}.#{app_id}"]
  #data['get-task-allow'] = true
  #
  #
  #plist = CFPropertyList::List.new
  #plist.value = CFPropertyList.guess(data)
  #plist.save(ios_entitlements_path, CFPropertyList::List::FORMAT_XML)
  #puts "INFO: saved new entitlements to '#{ios_entitlements_path}'"

  sign_cmd = "codesign -f -s \"#{options[:id]}\" -vv \"#{abs_app_path}\" --entitlements \"#{ios_entitlements_path}\""
  puts "INFO: signing with '#{sign_cmd}'"

  unless system(sign_cmd)
    msg 'error' do
      puts 'could not sign application'
    end
    exit 1
  end

  unless system("rm -rf '#{ipa}'")
    msg 'error' do
      puts "could not remove the old ipa at '#{ipa}'"
    end
    exit 1
  end

  puts 'INFO: zipping up Payload'

  FileUtils.cd(work_dir) do

    unless system("zip -qr #{File.basename(options[:ipa])} Payload")
      msg 'error' do
        puts "could not zip '#{File.basename(options[:ipa])}' from 'Payload'"
      end
      exit 1
    end

  end

  puts "INFO: finished signing '#{ipa}'"


  unless ENV['BRIAR_DONT_OPEN_ON_RESIGN']
    system("open #{work_dir}")
  end


end


