require_relative './briar_dot_xamarin'
require 'awesome_print'
require 'ansi/logger'

@log = ANSI::Logger.new(STDOUT)


# opens the most recent calabash report in the default browser
#
# ./reports directory must exist
# if +device+ is non-nil, ./reports/+device+ must exists
#
# see cucumber.yml for details about how report paths are created
def open_report_in_browser(device=nil)
  if device.nil?
    path = File.expand_path('./reports')
  else
    path =  File.expand_path("./reports/#{device}")
  end

  unless File.exists?(path)
    @log.fatal{ 'required directory is missing - see $ briar help cucumber-reports' }
    @log.fatal{ "expected directory at '#{path}'" }
    exit 1
  end

  open_path = Dir["#{path}/*.html"].sort_by { |file_name|
    File.stat(file_name).mtime
  }.last

  if open_path.nil?
    @log.warn{ 'there are no reports to open' }
    @log.warn{ "checked in #{path}" }
    exit 0
  end

  system "open #{open_path}"
end

def briar_report(args)
  arg_len = args.length
  if arg_len == 0
    open_report_in_browser
    exit 0
  end

  device = args[0]

  if arg_len > 1
    @log.warn("expected only one argument but found '#{args}'")
    @log.warn('ignoring extra input')
  end

  open_report_in_browser device
end