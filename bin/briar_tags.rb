require 'rainbow'
require 'ansi/logger'


@log = ANSI::Logger.new(STDOUT)


def briar_tags(args)
  arg_len = args.count

  if arg_len != 0
    @log.warn{ "expected no arguments but found '#{args}' - what can I do with that!?!" }
    exit 1
  end

  cmd = 'cucumber -d -f Cucumber::Formatter::ListTags'
  puts "#{Rainbow(cmd).green}"
  system(cmd)
end
