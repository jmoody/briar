require_relative 'briar_help'
require_relative 'briar_dot_xamarin'
require_relative 'briar_ideviceinstaller'

require 'ansi/logger'
@log = ANSI::Logger.new(STDOUT)

def briar_install_gem
  warn_deprecated('0.1.3', 'will be removed')
  puts 'will install briar gem'
  gem_dir = "#{ENV['HOME']}/git/briar"
  unless File.exists?(gem_dir)
    puts "expected gem '#{gem_dir}' - cannot install the briar gem"
    exit 1
  end
  system("cd #{gem_dir}; rake install")
  exit 0
end

def briar_install_calabash_gem
  warn_deprecated('0.1.3', 'will be removed')
  puts 'will install calabash-cucumber gem'
  gem_dir = "#{ENV['HOME']}/git/calabash-ios/calabash-cucumber"
  unless File.exists?(gem_dir)
    puts "expected gem '#{gem_dir}' - cannot install the calabash-cucumber gem"
    exit 1
  end
  system("cd #{gem_dir}; rake install")
  exit 0
end

def calabash_gem_path
  path = ENV['CALABASH_GEM_PATH']
  "#{path}/calabash-cucumber"
end

def expect_calabash_gem_path
  path = calabash_gem_path()
  unless File.exists?(path)
    @log.fatal { "expected calabash-cucumber at '#{path}' - cannot install the calabash server" }
    exit 1
  end
  path
end

def calabash_server_path
  ENV['CALABASH_SERVER_PATH']
end

def expect_calabash_server_path
  path = calabash_server_path
  unless File.exists?(path)
    @log.fatal { "expected calabash-ios server to be in dir '#{path}'" }
    exit 1
  end
  path
end

def briar_install_calabash_server
  puts 'will install calabash-ios server'
  cal_framework = 'calabash.framework'
  unless File.exists?(cal_framework)
    puts "expected '#{cal_framework}' to be in the local directory."
    puts "run this command in the directory that contains '#{cal_framework}'"
    exit 1
  end

  gem_dir = expect_calabash_gem_path
  server_dir = expect_calabash_server_path

  version_file = File.read("#{server_dir}/calabash/Classes/FranklyServer/Routes/LPVersionRoute.h")
  tokens = version_file.split(/define kLPCALABASHVERSION/)
  line = tokens[1].split("\n").first
  version = line.tr('^A-Za-z0-9.\-\_', '')

  puts "building calabash server using 'rake build_server'"
  system("cd #{gem_dir}; rake build_server")
  puts 'remove old cal simulator targets'
  briar_rm(['sim-targets'])
  puts 'copying new framework to ./'
  system("cp #{gem_dir}/staticlib/#{cal_framework}.zip ./")
  puts 'removing old framework'
  system("rm -rf #{cal_framework}")
  puts 'unzipping new framework'
  system("unzip #{cal_framework}.zip")
  puts 'cleaning up'
  system("rm -rf #{cal_framework}.zip")
  puts "installed new server version '#{version}'"
end


def briar_install(args)
  arg_len = args.length
  if arg_len == 0
    print_install_help
    exit 0
  end

  if arg_len > 1
    @log.fatal { "briar install takes only one argument but found '#{args}'" }
    print_install_help
    exit 1
  end

  what = args[0]

  case what
    when BRIAR_INSTALL_GEM
      briar_install_gem
    when BRIAR_INSTALL_CALABASH_GEM
      briar_install_calabash_gem
    when BRIAR_INSTALL_CALABASH_SERVER
      briar_install_calabash_server
    else
      # install or reinstall application on a device
      briar_device_install(what)
  end
end

def briar_device_install(device)
  ideviceinstaller(device, :reinstall)
end