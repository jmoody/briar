$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__))

require 'rubygems'
#require 'bundler'
#Bundler.setup

require 'pickle'
require 'cucumber'

RSpec.configure do |c|
  c.before do
    ::Cucumber::Term::ANSIColor.coloring = true
  end
end


