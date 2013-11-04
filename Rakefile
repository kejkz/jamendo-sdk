require 'rspec/core/rake_task'
require 'rubygems/package_task'
require File.expand_path('../lib/version', __FILE__)

# task :build => [:spec, :gem]

desc 'Default spec run'
task :default => [:spec]

RSpec::Core::RakeTask.new :spec do |t|
  t.verbose = true
  # task.spec_files = FileList['spec/**/*_spec.rb']
  # t.libs = ['lib', 'spec']
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
# 
# Gems::PackageTask.new(gem_spec) do |t|
#   t.need_zip = true
# end
# 
# task :push => :gem do |t|
#   sh "gem push pkg/#{gem_spec.name}-#{gem_spec.version}.gem"
# end

