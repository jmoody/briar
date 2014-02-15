require 'find'
require_relative './briar_sim'
require 'ansi/logger'

@log = ANSI::Logger.new(STDOUT)


def briar_remove_cal_targets
  kill_simulator
  sim_dir="#{ENV['HOME']}/Library/Application Support/iPhone Simulator"

  # `find "#{sim_dir}" -type d -name '*-cal.app' | sed 's#\(.*\)/.*#\1#' | xargs -I{} rm -rf {}`
  cal_targets = []
  Find.find(sim_dir) do |path|
    if path =~  /.*\-cal.app/
      @log.info { "found '#{File.basename(path)}' in '#{File.dirname(path)}'" }
      cal_targets << File.dirname(path)
      Find.prune
    end
  end

  if cal_targets.empty?
    @log.info { "found no *-cal.app targets in '#{sim_dir}'" }
  else
    cal_targets.each do |path|
      FileUtils.rm_r path
    end
  end
end

def briar_remove_derived_data_dups(opts={})
  default_opts = {:derived_data => ENV['DERIVED_DATA'],
                  :prefix => ENV['DERIVED_DATA_PREFIX']}
  opts = default_opts.merge(opts)

  unexpanded = opts[:derived_data]
  expanded = File.expand_path(unexpanded)
  unless File.exists?(expanded)
    @log.fatal { 'could not find DerivedData directory' }
    @log.fatal { "expected it here '#{unexpanded}'" }
    exit 1
  end

  prefix = opts[:prefix]
  unless prefix
    @log.fatal { 'requires a directory prefix' }
    exit 1
  end

  Dir.glob("#{expanded}/#{prefix}-*/").each do |candidate|
    dir_count = Dir["#{candidate}/*/"].length
    if dir_count == 2
       @log.info{ "found #{File.basename(candidate)} with 2 directories - deleting it" }
      FileUtils.rm_r(candidate)
    end
  end
end

def briar_rm(args)
  arg_len = args.count

  if arg_len == 0
    raise 'expected at least one argument'
  end

  command = args[0]
  prefix = arg_len == 2 ? args[1] : nil

  case command
    when 'sim-targets'
      unless prefix.nil?
        @log.warn{ "expected one argument but found '#{args}' - ignoring extra input" }
      end
      briar_remove_cal_targets
    when 'dups'
      opts = prefix.nil? ? {} : {:prefix => prefix}
      briar_remove_derived_data_dups(opts)
    else
      @log.fatal{ "illegal arg '#{command}' - expected #{['sim-targets', 'dups']}" }
      exit 1
  end
end

