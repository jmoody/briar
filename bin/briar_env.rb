require 'ansi/logger'

@log = ANSI::Logger.new(STDOUT)

def expect_bundle_id
  bundle_id = ENV['BUNDLE_ID']
  unless ENV['BUNDLE_ID']
    @log.fatal{'BUNDLE_ID must be set'}
    exit 1
  end
  bundle_id
end

def expect_build_script(build_script)
  unless File.exists?(File.expand_path(build_script))
    @log.fatal{ 'arguments say there is supposed to be a build script' }
    @log.fatal{ "expected it here '#{build_script}'" }
    exit 1
  end
  build_script
end

def expect_ideviceinstaller
  bin_path = ENV['IDEVICEINSTALLER_BIN']
  unless File.exists?(File.expand_path(bin_path))
    @log.fatal{'cannot find ideviceinstaller'}
    @log.fatal{ "expected it here '#{bin_path}'"}
    exit 1
  end
end

def expect_ipa(ipa_path)
  unless File.exists?(File.expand_path(ipa_path))
    @log.fatal{'ipa does not exist'}
    @log.fatal{"expected it here '#{ipa_path}'"}
    exit 1
  end
  ipa_path
end

def expect_xtc_account
  account = ENV['XTC_ACCOUNT']
  unless account
    @log.fatal{ 'XTC_ACCOUNT must be set' }
    exit 1
  end
  account
end



