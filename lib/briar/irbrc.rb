require 'rubygems'
require 'irb/completion'
require 'irb/ext/save-history'
require 'awesome_print'
require 'pry'

AwesomePrint.irb!

require 'require_relative'

#noinspection RubyUnusedLocalVariable
def World(*world_modules, &proc)
  world_modules.each { |mod|
    include mod
    puts "loaded '#{mod}'"
  }
end

ARGV.concat [ '--readline',
              '--prompt-mode',
              'simple']

# 25 entries in the list
IRB.conf[:SAVE_HISTORY] = 50

# Store results in home directory with specified file name
IRB.conf[:HISTORY_FILE] = '.irb-history'

#noinspection RubyResolve
require 'calabash-cucumber'
#noinspection RubyResolve
require 'calabash-cucumber/operations'
#noinspection RubyResolve
require 'calabash-cucumber/launch/simulator_helper'
#noinspection RubyResolve
require 'calabash-cucumber/launcher'

SIM=Calabash::Cucumber::SimulatorHelper

extend Calabash::Cucumber::Operations

#noinspection RubyUnusedLocalVariable
def embed(x,y=nil,z=nil)
  puts "Screenshot at #{x}"
end

puts 'loaded calabash'

include Briar::Bars
include Briar::Alerts_and_Sheets
include Briar::Control::Button
include Briar::Control::Segmented_Control
include Briar::Control::Slider
include Briar::Picker
include Briar::Picker_Shared
include Briar::Picker::DateCore
include Briar::Picker::DateManipulation
include Briar::Picker::DateSteps
include Briar::Core
include Briar::UIA
include Briar::UIA::IPadEmulation
include Briar::Table
include Briar::ImageView
include Briar::Label
include Briar::Keyboard
include Briar::UIAKeyboard
include Briar::UIAKeyboard::Numeric
include Briar::UIAKeyboard::Language
include Briar::Email
include Briar::TextField
include Briar::TextView
include Briar::Page::Helpers


@ai=:accessibilityIdentifier
@al=:accessibilityLabel

def print_marks(marks, max_width)
  counter = -1
  marks.sort.each { |elm|
    printf("%4s %#{max_width + 2}s => %s\n", "[#{counter = counter + 1}]", elm[0], elm[1])
  }
end

def accessibility_marks(kind, opts={})
  opts = {:print => true, :return => false}.merge(opts)

  kinds = [:id, :label]
  raise "'#{kind}' is not one of '#{kinds}'" unless kinds.include?(kind)

  res = Array.new
  max_width = 0
  query('*').each { |view|
    aid = view[kind.to_s]
    unless aid.nil? or aid.eql?('')
      cls = view['class']
      len = cls.length
      max_width = len if len > max_width
      res << [cls, aid]
    end
  }
  print_marks(res, max_width) if opts[:print]
  opts[:return] ? res : nil
end

def text_marks(opts={})
  opts = {:print => true, :return => false}.merge(opts)

  indexes = Array.new
  idx = 0
  all_texts = query('*', :text)
  all_texts.each { |view|
    indexes << idx unless view.eql?('*****') or view.eql?('')
    idx = idx + 1
  }

  res = Array.new

  all_views = query('*')
  max_width = 0
  indexes.each { |index|
    view = all_views[index]
    cls = view['class']
    text = all_texts[index]
    len = cls.length
    max_width = len if len > max_width
    res << [cls, text]
  }

  print_marks(res, max_width) if opts[:print]
  opts[:return] ? res : nil
end

def verbose
  ENV['DEBUG'] = '1'
  ENV['CALABASH_FULL_CONSOLE_OUTPUT'] = '1'
end

def quiet
  ENV['DEBUG'] = '0'
  ENV['CALABASH_FULL_CONSOLE_OUTPUT'] = '0'
end

def ids
  accessibility_marks(:id)
end

def labels
  accessibility_marks(:label)
end

def text
  text_marks
end

def marks
  opts = {:print => false, :return => true }
  res = accessibility_marks(:id, opts).each { |elm|elm << :ai }
  res.concat(accessibility_marks(:label, opts).each { |elm| elm << :al })
  res.concat(text_marks(opts).each { |elm| elm << :text })
  max_width = 0
  res.each { |elm|
    len = elm[0].length
    max_width = len if len > max_width
  }

  counter = -1
  res.sort.each { |elm|
    printf("%4s %-4s => %#{max_width}s => %s\n",
           "[#{counter = counter + 1}]",
           elm[2], elm[0], elm[1])
  }
  nil
end

def nbl
  query('navigationButton', :accessibilityLabel)
end

def row_ids
  query('tableViewCell', @ai).compact.sort.each {|x| puts "* #{x}" }
end

def puts_calabash_environment

  puts ''
  puts "loaded #{File.expand_path(ENV['IRBRC'])}"
  puts ''
  puts "             DEVICE_ENDPOINT => '#{ENV['DEVICE_ENDPOINT']}'"
  puts "               DEVICE_TARGET => '#{ENV['DEVICE_TARGET']}'"
  puts "                      DEVICE => '#{ENV['DEVICE']}'"
  puts "                   BUNDLE_ID => '#{ENV['BUNDLE_ID']}'"
  puts "                PLAYBACK_DIR => '#{ENV['PLAYBACK_DIR']}'"
  puts "             SCREENSHOT_PATH => '#{ENV['SCREENSHOT_PATH']}'"
  puts "                 SDK_VERSION => '#{ENV['SDK_VERSION']}'"
  puts "CALABASH_FULL_CONSOLE_OUTPUT => '#{ENV['CALABASH_FULL_CONSOLE_OUTPUT']}'"
  puts "                       DEBUG => '#{ENV['DEBUG']}'"
  puts ''
  puts '*** useful functions defined in .irbrc ***'
  puts '>     ids #=> all accessibilityIdentifiers'
  puts '>  labels #=> all accessibilityLabels'
  puts '>    text #=> all text'
  puts '> row_ids #=> all tableViewCell accessibilityIdentifiers'
  puts '> verbose #=> set debug logging on'
  puts '>   quiet #=> set debug logging off'
  puts ''
end

def briar_message_of_the_day
  motd=["Let's get this done!", 'Ready to rumble.', 'Enjoy.', 'Remember to breathe.',
        'Take a deep breath.', "Isn't it time for a break?", 'Can I get you a coffee?',
        'What is a calabash anyway?', 'Smile! You are on camera!', 'Let op! Wild Rooster!',
        "Don't touch that button!", "I'm gonna take this to 11.", 'Console. Engaged.',
        'Your wish is my command.', 'This console session was created just for you.']
  puts "#{motd.shuffle().first}"
end
