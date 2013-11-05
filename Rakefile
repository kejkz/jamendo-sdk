require 'rspec/core/rake_task'
require 'rubygems/package_task'
require 'bundler/gem_tasks'

desc 'Default spec run'
task :default => [:spec]

RSpec::Core::RakeTask.new :spec do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end