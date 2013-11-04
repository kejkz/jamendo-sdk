require 'rspec/core/rake_task'
require 'rubygems/package_task'
require 'bundler/gem_tasks'
# require File.expand_path('../lib/version', __FILE__)

desc 'Default spec run'
task :default => [:spec]

RSpec::Core::RakeTask.new :spec do |t|
  t.verbose = true
end

# gem_spec = Gem::Specification.new do |spec|
#   spec.name = 'jamendo-sdk'
#   spec.version = Jamendo::VERSION
#   spec.authors = ['Vladimir Karan']
#   spec.date = %q{2013-09-06}
#   spec.description = 'Jamendo SDK Ruby'
#   spec.summary = spec.description
#   spec.email = 'kejkzz@gmail.com'
#   spec.homepage = 'https://github.com/kejkz'
#   spec.has_rdoc = true
# end

# Gem::PackageTask.new(gem_spec) do |pkg|
#   pkg.need_zip = true
#   pkg.need_tar = true
# end