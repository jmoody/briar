# -*- encoding: utf-8 -*-
require_relative 'lib/briar/version'

Gem::Specification.new do |gem|
  gem.name = 'briar'
  gem.version = Briar::VERSION
  gem.authors = ['Joshua Moody']
  gem.email = ['joshuajmoody@gmail.com']
  gem.description = 'extends calabash-ios steps'
  gem.summary = "briar-#{gem.version}"
  gem.homepage = 'https://github.com/jmoody/briar'
  gem.license = 'MIT'

  gem.required_ruby_version = Gem::Requirement.new('>= 1.9.2')

  gem.add_runtime_dependency 'calabash-cucumber', '>= 0.9.164'
  gem.add_runtime_dependency 'rake', '~>10.1'
  gem.add_runtime_dependency 'syntax', '~>1.2'

  gem.files = `git ls-files`.split("\n") - ['.gitignore']
  gem.executables = 'briar'
  gem.test_files = gem.files.grep(%r{^(test|spec)/})
  gem.require_paths = ['lib', 'features']
end
