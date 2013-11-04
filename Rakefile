require 'spec/rake/spectask'
require 'rake/gempackagetask'
require 'lib/version'

task :build => [:spec, :gem]

Spec::Rake::SpecTask.new do |t|
  t.warning = true
  t.verbose = true
  # task.spec_files = FileList['spec/**/*_spec.rb']
  t.libs = ['lib', 'spec']
end

gem_spec = Gem::Specification.new do |spec|
  spec.name = 'jamendo-sdk'
  spec.version = Jamendo::VERSION
  spec.authors = ['Vladimir Karan']
  spec.date = %q{2013-09-06}
  spec.description = 'Jamendo SDK Ruby'
  spec.summary = spec.description
  spec.email = 'kejkzz@gmail.com'
  spec.homepage = 'https://github.com/kejkz'
  spec.has_rdoc = true
  spec.rubyforge_document = 'jamendo_sdk'
end

Rake::GemPackageTask.new(gem_spec) do |t|
  t.need_zip = true
end

task :push => :gem do |t|
  sh "gem push pkg/#{gem_spec.name}-#{gem_spec.version}.gem"
end

task :default => :spec