require 'bundler'
require 'bundler/gem_tasks'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
end

