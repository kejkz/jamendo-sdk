require 'spec/rake/spectask'
require 'rake/gempackagetask'

task :default => [:spec, :gem]

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

gem_spec = Gem::Specification.new do |spec|
  spec.name = 'jamendo-sdk'
  spec.version = '0.1.8'
  spec.authors = ['Vladimir Karan']
  spec.date = %q{2013-05-27}
  spec.description = 'Jamendo SDK Ruby'
  spec.summary = spec.description
  spec.email = 'kejkzz@gmail.com'
  spec.homepage = ''
  spec.has_rdoc = true
  spec.rubyforge_document = 'jamendo_sdk'
end

Rake::GemPackageTask.new(gem_spec) do |t|
  t.need_zip = true
end

task :push => :gem do |t|
  sh "gem push pkg/#{gem_spec.name}-#{gem_spec.version}.gem"
end