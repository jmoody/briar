require "bundler/gem_tasks"
require "./lib/briar/version.rb"
task :show_simulator do
  sh "/usr/bin/osascript -e 'tell application \"iPhone Simulator\" to activate'"
  sh "/usr/bin/osascript -e 'tell application \"RubyMine\" to activate'"
end

task :gem do
  sh "gem build briar.gemspec"
  sh "gem install briar-#{Briar::VERSION}.gem"
end
