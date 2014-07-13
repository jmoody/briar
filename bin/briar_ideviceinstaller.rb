require_relative './briar_dot_xamarin'
require_relative './briar_rm'
require_relative './briar_env'

require 'rainbow'
require 'ansi/logger'
require 'retriable'

@log = ANSI::Logger.new(STDOUT)

module Briar
  module IDEVICEINSTALLER

    include Calabash::Cucumber::Logging

    def ideviceinstaller(device, cmd, opts={})
      default_opts = {:build_script => ENV['IPA_BUILD_SCRIPT'],
                      :ipa => ENV['IPA'],
                      :bundle_id => expect_bundle_id(),
                      :idevice_installer => expect_ideviceinstaller()}
      merged = default_opts.merge(opts)

      cmds = [:install, :uninstall, :reinstall]
      unless cmds.include? cmd
        raise "illegal option '#{cmd}' must be one of '#{cmds}'"
      end

      build_script = merged[:build_script]
      expect_build_script(build_script) if build_script

      udid =  read_device_info(device, :udid)

      bin_path = merged[:idevice_installer]
      bundle_id = merged[:bundle_id]

      case cmd
        when :install
          if build_script
            system "#{build_script}"
            briar_remove_derived_data_dups
          end

          ipa = merged[:ipa]
          expect_ipa(ipa)

          Retriable.retriable do
            uninstall udid, bundle_id, bin_path
          end

          Retriable.retriable do
            install udid, ipa, bundle_id, bin_path
          end
        when :uninstall
          Retriable.retriable do
            uninstall udid, bundle_id, bin_path
          end
        when :reinstall
          _deprecated('1.1.0', ':reinstall arg has been deprecated; use :install instead', :warn)
          ideviceinstaller device, :install
      end
    end


    def bundle_installed?(udid, bundle_id, installer)
      cmd = "#{installer} -u #{udid} -l"
      puts "#{Rainbow(cmd).green}"
      `#{cmd}`.strip.split(/\s/).include? bundle_id
    end

    def install(udid, ipa, bundle_id, installer)
      if bundle_installed? udid, bundle_id, installer
        puts "#{Rainbow("bundle '#{bundle_id}' is already installed").green}"
        return true
      end

      cmd = "#{installer} -u #{udid} --install #{ipa}"
      system cmd
      unless bundle_installed?(udid, bundle_id, installer)
        raise "could not install '#{ipa}' on '#{udid}' with '#{bundle_id}'"
      end
      true
    end


    def uninstall(udid, bundle_id, installer)
      unless bundle_installed? udid, bundle_id, installer
        return true
      end
      cmd = "#{installer} -u #{udid} --uninstall #{bundle_id}"
      system cmd
      if bundle_installed?(udid, bundle_id, installer)
        raise "could not uninstall '#{bundle_id}' on '#{udid}'"
      end
      true
    end
  end
end

