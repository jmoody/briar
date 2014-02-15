require_relative './briar_dot_xamarin'
require_relative './briar_rm'
require_relative './briar_env'

require 'rainbow'
require 'ansi/logger'

@log = ANSI::Logger.new(STDOUT)

def ideviceinstaller(device, cmd, opts={})
  default_opts = {:build_script => ENV['IPA_BUILD_SCRIPT'],
                  :ipa => ENV['IPA'],
                  :bundle_id => expect_bundle_id(),
                  :idevice_installer => expect_ideviceinstaller()}
  opts = default_opts.merge(opts)

  cmds = [:install, :uninstall, :reinstall]
  unless cmds.include? cmd
    raise "illegal option '#{cmd}' must be one of '#{cmds}'"
  end

  build_script = opts[:build_script]
  expect_build_script(build_script) if build_script

  udid =  read_device_info(device, :udid)

  bin_path = opts[:idevice_installer]

  if cmd == :install
    if build_script
      system "#{build_script}"
      briar_remove_derived_data_dups
    end

    ipa = opts[:ipa]
    expect_ipa(ipa)

    cmd = "#{bin_path} -u #{udid} --install #{ipa}"
    puts "#{Rainbow(cmd).green}"
    system cmd
  elsif cmd == :uninstall
    bundle_id = opts[:bundle_id]
    cmd = "#{bin_path} -u #{udid} --uninstall #{bundle_id}"
    puts "#{Rainbow(cmd).green}"
    system cmd
  else
    ideviceinstaller(device, :uninstall)
    ideviceinstaller(device, :install)
  end
end
