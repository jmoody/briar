require_relative './briar_dot_xamarin'
require_relative './briar_env'
require_relative './briar_rm'
require 'awesome_print'
require 'ansi/logger'

@log = ANSI::Logger.new(STDOUT)

def briar_xtc_submit(device_set, profile, opts={})
  default_opts = {:build_script => ENV['IPA_BUILD_SCRIPT'],
                  :ipa => ENV['IPA'],
                  :profiles => ENV['XTC_PROFILES'],
                  :account => expect_xtc_account(),
                  :other_gems => ENV['XTC_OTHER_GEMS_FILE'],
                  :xtc_staging_dir => expect_xtc_staging_dir(),
                  :briar_dev => ENV['XTC_BRIAR_GEM_DEV'] == '1',
                  :calabash_dev => ENV['XTC_CALABASH_GEM_DEV'] == '1',
                  :run_loop_dev => ENV['XTC_RUN_LOOP_GEM_DEV'] == '1',
                  :async_submit => ENV['XTC_WAIT_FOR_RESULTS'] == '0',
                  :series => ENV['XTC_SERIES'],
                  :user => ENV['XTC_USER'],
                  :dsym => ENV['XTC_DSYM'],
                  :rebuild => true}

  opts = default_opts.merge(opts)

  build_script = opts[:build_script]

  if build_script
    expect_build_script(build_script)
    if opts[:rebuild]
      cmd = "#{build_script}"
    else
      cmd = "#{build_script} -"
    end
    system cmd
  end

  account = opts[:account]
  api_key = read_api_token(account)

  # ugh.  it works, then it doesn't
  # i think the real solution is to pull the bin/tools out of the gem and into
  # (yet) another gem.
  # if opts[:briar_dev]
  #   briar_path = `bundle show briar`.strip
  #   # system('gem uninstall -Vax --force --no-abort-on-dependent briar',
  #   #        :err => '/dev/null')
  #   Dir.chdir(File.expand_path(briar_path)) do
  #     system 'gem rake install'
  #   end
  # end

  if opts[:calabash_dev]
    cmd = 'bundle show calabash-cucumber'
    puts Rainbow("EXEC: #{cmd}").cyan
    calabash_path = `#{cmd}`.strip

    cmd = 'gem uninstall -Vax --force --no-abort-on-dependent calabash-cucumber'
    puts Rainbow("EXEC: #{cmd}").cyan
    system(*cmd.split(' '),  :err => '/dev/null')
    puts Rainbow("EXEC: cd #{calabash_path}").cyan

    Dir.chdir(File.expand_path(calabash_path)) do
      puts Rainbow('EXEC: rake install').cyan
      system('rake', 'install')
    end
  end

  if opts[:run_loop_dev]
    cmd = 'bundle show run_loop'
    puts Rainbow("EXEC: #{cmd}").cyan
    run_loop_path = `#{cmd}`.strip

    cmd = 'gem uninstall -Vax --force --no-abort-on-dependent run_loop'
    system(*cmd.split(' '), :err => '/dev/null')
    puts Rainbow("EXEC: #{cmd}").cyan

    puts Rainbow("EXEC: cd #{run_loop_path}").cyan
    Dir.chdir(File.expand_path(run_loop_path)) do
      puts Rainbow('EXEC: rake install').cyan
      system('rake', 'install')
    end
  end

  other_gems = []
  if opts[:other_gems] != ''
    path = File.expand_path(opts[:other_gems])
    File.read(path).split("\n").each do |line|
      # stay 1.8.7 compat
      next if line.strip.length == 0 or line.chars.to_a.first.eql?('#')
      other_gems << line.strip
    end
  end

  staging_dir = opts[:xtc_staging_dir]
  unless File.exists?(File.expand_path(staging_dir))
    @log.fatal{ "XTC_STAGING_DIR => '#{staging_dir}' does not exist" }
    exit 1
  end

  xtc_gemfile = "#{staging_dir}/Gemfile"

  File.open(xtc_gemfile, 'w') do |file|
    file.write("source 'https://rubygems.org'\n")
    if opts[:briar_dev]
      briar_version = `bundle exec briar version`.strip
      file.write("gem 'briar', '#{briar_version}'\n")
    else
      file.write("gem 'briar'\n")
    end

    if opts[:calabash_dev]
      calabash_version = `bundle exec calabash-ios version`.strip
      file.write("gem 'calabash-cucumber', '#{calabash_version}'\n")
    elsif not opts[:briar_dev]
      file.write("gem 'calabash-cucumber'\n")
    end

    other_gems.each do |gem|
      file.write("#{gem}\n")
    end
  end

  sets = read_device_sets
  if sets[device_set]
    device_set = sets[device_set]
  end

  profile = 'default' if profile.nil?

  if opts[:async_submit]
    wait = '--async'
  else
    wait = '--no-async'
  end

  ipa = File.expand_path(expect_ipa(opts[:ipa]))

  args = [
        'submit',
        ipa,
        api_key,
        '-d', device_set,
        '-c', 'cucumber.yml',
        '-p', profile,
        wait
  ]

  user = opts[:user]
  if user
    args << '--user'
    args << user
  end

  if opts[:series]
    args << '--series'
    args << opts[:series]
  end

  if opts[:dsym]
    args << '--dsym-file'
    args << File.expand_path(opts[:dsym])
  end

  print_args = args.dup

  obscured_key = "#{api_key[0,1]}***#{api_key[api_key.length-1,1]}"
  print_args[args.index(api_key)] = obscured_key

  if user
    obscured_user = "#{user[0,1]}***#{user[user.length-1,1]}"
    print_args[args.index(user)] = obscured_user
  end

  puts Rainbow("EXEC: cd #{staging_dir}").cyan
  puts Rainbow("EXEC: test-cloud version => #{`test-cloud version`.strip}").cyan
  puts Rainbow("EXEC: test-cloud #{print_args.join(' ')}").cyan

  Dir.chdir(staging_dir) do
    exec('test-cloud', *args)
  end
end


def briar_xtc(args)
  arg_len = args.length
  if arg_len == 0
    ap read_device_sets
    exit 0
  end

  device_set = args[0]
  profile = arg_len == 1 ? 'default' : args[1]


  if arg_len == 3
    rebuild_arg = args[2]
    unless rebuild_arg == '-'
      @log.fatal { "unknown optional argument '#{rebuild_arg}' expected '-'" }
      exit 1
    end
    opts = {:rebuild => false}
  else
    opts = {:rebuild => true}
  end

  if arg_len > 3
    @log.warn{ "expected at most 3 args by found '#{args}' - ignoring extra input" }
  end

  briar_xtc_submit(device_set, profile, opts)
end
