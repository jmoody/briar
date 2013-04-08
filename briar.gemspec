# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
#lib = File.expand_path('../lib', __FILE__)
#$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'briar/version'

Gem::Specification.new do |gem|
  gem.name          = 'briar'
  gem.version       = Briar::VERSION
  gem.authors       = ['Joshua Moody']
  gem.email         = ['joshuajmoody@gmail.com']
  gem.description   = 'extends calabash-ios steps'
  gem.summary       = "briar-#{gem.version}"
  gem.homepage      = 'https://github.com/jmoody/briar'
  gem.license       = 'MIT'

  gem.add_runtime_dependency 'calabash-cucumber'
  gem.add_runtime_dependency 'rake', '10.0.3'
  gem.add_runtime_dependency 'bundler'
  gem.add_runtime_dependency 'lesspainful'
  gem.add_runtime_dependency 'syntax' 
  gem.add_runtime_dependency 'rspec'


  # rubymine is not picking up development dependencies in the gemspec
  #gem.add_development_dependency 'rspec'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = 'briar'
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
