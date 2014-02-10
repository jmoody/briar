require_relative './briar_dot_xamarin'
require_relative './briar_env'
require_relative './briar_rm'
require 'awesome_print'
require 'ansi/logger'

@log = ANSI::Logger.new(STDOUT)

# not yet - maybe never
##use <tt>rake install</tt> to install a gem at +path_to_gemspec+
## returns the version of the gem installed
#def rake_install_gem(path_to_gemspec)
#
#  #out = `"cd #{path_to_gemspec}; rake install"`
#
#  out = nil
#  Dir.chdir(File.expand_path(path_to_gemspec)) do
#    system 'rake install'
#  end
#
#
#  #cmd = "cd #{path_to_gemspec} ; rake install"
#  #output = []
#  #IO.popen(cmd).each do |line|
#  #  p line.chomp
#  #  output << line.chomp
#  #end
#
#  puts "out = '#{out}'"
#  exit 1
#  tokens = out.split(' ')
#  gem = tokens[0]
#  version = tokens[1]
#  @log.info { "installed #{gem} #{version}" }
#  version
#end

def briar_xtc_submit(device_set, profile, opts={})
  default_opts = {:build_script => ENV['IPA_BUILD_SCRIPT'],
                  :ipa => ENV['IPA'],
                  :profiles => ENV['XTC_PROFILES'],
                  :account => expect_xtc_account()}

  opts = default_opts.merge(opts)

  build_script = opts[:build_script]

  if build_script
    expect_build_script(build_script)
    system "#{build_script}"
    briar_remove_derived_data_dups
  end

  xtc_gemfile = './xamarin/Gemfile'

  briar_path = `bundle show briar`.strip
  calabash_path = `bundle show calabash-cucumber`.strip

  File.open(xtc_gemfile, 'w') { |file|
    file.write("source 'https://rubygems.org'\n")
    file.write("gem 'calabash-cucumber', :path => '#{calabash_path}'\n")
    file.write("gem 'briar', :path => '#{briar_path}'\n")
    file.write("gem 'faker'\n")
  }
  
  account = opts[:account]
  api_key = read_api_token(account)


  sets = read_device_sets
  if sets[device_set]
    device_set = sets[device_set]
  end

  profile = 'default' if profile.nil?

  ipa = File.basename(File.expand_path(expect_ipa(opts[:ipa])))

  cmd = "bundle exec test-cloud submit #{ipa} #{api_key} -d #{device_set} -c cucumber.yml -p #{profile}"
  puts Rainbow("cd xamarin; #{cmd}").green
  begin
    Dir.chdir('./xamarin') do
      system cmd
    end
  rescue
    # probably useless
    @log.fatal{ 'could not submit job' }
  end
end


def briar_xtc(args)
  arg_len = args.length
  if arg_len == 0
    ap read_device_sets
    exit 0
  end

  device_set = args[0]
  profile = arg_len == 1 ? nil : args[1]

  if arg_len > 2
    @log.warn{ "expected at most 2 args by found '#{args}' - ignoring extra input" }
  end

  briar_xtc_submit(device_set, profile)
end

