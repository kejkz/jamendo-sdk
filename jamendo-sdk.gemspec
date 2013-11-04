# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib',__FILE__)
require 'jamendo-sdk/version'

Gem::Specification.new do |spec|
  spec.name           = 'jamendo-sdk'
  spec.version        = Jamendo::VERSION
  spec.authors        = ['Vladimir Karan']
  spec.email          = 'kejkzz@gmail.com'
  spec.date           = %q{2013-06-09}
  spec.description    = 'Jamendo SDK Ruby bindings'
  spec.summary        = 'Jamendo SDK written in pure Ruby'
  spec.homepage       = 'https://github.com/kejkz'
  spec.license        = 'MIT'
  
  spec.files          = `git ls-files`.split($/)
  spec.test_files     = spec.files.grep(%r{^(test|spec|features)/})
  
  spec.has_rdoc       = true
  spec.require_paths  = ['lib']
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
end