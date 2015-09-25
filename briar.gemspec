# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name = 'briar'
  gem.version = lambda {
    briar_gem_version = nil
    version_file = File.join(File.dirname(__FILE__), 'lib', 'briar', 'version.rb')
    lines = File.readlines(version_file)
    lines.each do |line|
      regex = /(\d+)\.(\d+)\.(\d+)\.?(pre\d*)?/
      match = line.match(regex)
      unless match.nil?
        briar_gem_version = match[0]
        break
      end
    end
    briar_gem_version
  }.call

  gem.authors = ['Joshua Moody']
  gem.email = ['joshuajmoody@gmail.com']
  gem.description = 'extends calabash-ios steps'
  gem.summary = "briar-#{gem.version}"
  gem.homepage = 'https://github.com/jmoody/briar'
  gem.license = 'MIT'

  gem.files = `git ls-files`.split("\n") - ['.gitignore']
  gem.executables = 'briar'
  gem.require_paths = ['lib', 'features']

  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.9.3'

  gem.add_runtime_dependency 'rbx-require-relative', '~> 0.0'
  gem.add_runtime_dependency 'calabash-cucumber', '>= 0.12', '< 1.0'
  gem.add_runtime_dependency 'dotenv'
  gem.add_runtime_dependency 'ansi', '~> 1.5'
  gem.add_runtime_dependency 'rainbow', '~> 2.0'
  gem.add_runtime_dependency 'retriable'
  gem.add_runtime_dependency 'bundler'
  gem.add_runtime_dependency 'xamarin-test-cloud', '~> 1.0'
  gem.add_runtime_dependency 'rake'

  gem.add_development_dependency 'travis', '~> 1.7'
  gem.add_development_dependency 'yard', '~> 0.8'

  # Version 0.1.7 causes problems on the XTC.
  gem.add_development_dependency 'xcpretty', '0.1.6'

  gem.add_development_dependency('rspec', '~> 3.0')
  gem.add_development_dependency('guard-rspec', '~> 4.3')
  gem.add_development_dependency('guard-bundler', '~> 2.0')
  gem.add_development_dependency('growl', '~> 1.0')
  gem.add_development_dependency('pry')
  gem.add_development_dependency('pry-nav')

end
