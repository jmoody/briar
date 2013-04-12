require 'bundler/gem_tasks'
require './lib/briar/version.rb'
task :show_simulator do
  sh "/usr/bin/osascript -e 'tell application \"iPhone Simulator\" to activate'"
  sh "/usr/bin/osascript -e 'tell application \"RubyMine\" to activate'"
end

#task :gem do
#  sh 'rm -f *.gem'
#  sh 'gem build briar.gemspec --verbose'
#  sh "gem install briar-#{Briar::VERSION}.gem"
#end
#
#task :push do
#  sh 'gem update'
#  sh 'gem build briar.gemspec'
#  sh "gem push briar-#{Briar::VERSION}.gem"
#end
