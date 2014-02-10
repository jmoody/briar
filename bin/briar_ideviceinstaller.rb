require_relative './briar_dot_xamarin'
require_relative './briar_rm'
require_relative './briar_env'

require 'ansi/logger'

@log = ANSI::Logger.new(STDOUT)

def ideviceinstaller(device, cmd, opts={})
  default_opts = {:build_script => ENV['IPA_BUILD_SCRIPT'],
                  :ipa => ENV['IPA'],
                  :bundle_id => expect_bundle_id(),
                  :ideviceinstaller => expect_ideviceinstaller()}
  opts = default_opts.merge(opts)

  cmds = [:install, :uninstall, :reinstall]
  unless cmds.include? cmd
    raise "illegal option '#{cmd}' must be one of '#{cmds}'"
  end

  build_script = opts[:build_script]
  expect_build_script(build_script) if build_script

  udid =  read_device_info(device, :udid)

  if cmd == :install
    if build_script
      system "#{build_script}"
      briar_remove_derived_data_dups
    end
    ipa = opts[:ipa]
    expect_ipa(ipa)

    system "#{bin_path} -u #{udid} --install #{ipa}"
  elsif cmd == :uninstall
    system "#{bin_path} -u #{udid} --uninstall #{bundle_id}"
  else
    ideviceinstaller(device, :uninstall)
    ideviceinstaller(device, :install)
  end
end
