require 'bundler/gem_tasks'
require './lib/briar/version.rb'
task :show_simulator do
  sh "/usr/bin/osascript -e 'tell application \"iPhone Simulator\" to activate'"
  sh "/usr/bin/osascript -e 'tell application \"RubyMine\" to activate'"
end

# let us try to use gem_tasks
#$ rake -T
#rake build    # Build briar-0.0.7.gem into the pkg directory.
#rake install  # Build and install briar-0.0.7.gem into system gems.
#rake release  # Create tag v0.0.7 and build and push briar-0.0.7.gem to Rubygems

