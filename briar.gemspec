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

  gem.add_runtime_dependency 'calabash-cucumber', '0.9.135'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rvm'
  gem.add_development_dependency 'lesspainful'


  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
