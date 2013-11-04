require 'rspec/core/rake_task'
require 'rubygems/package_task'
require 'bundler/gem_tasks'

desc 'Default spec run'
task :default => [:spec]

RSpec::Core::RakeTask.new :spec do |t|
  t.verbose = true
end