# encoding: utf-8

require 'rubygems'
require 'rake'

begin
  gem 'rspec', '~> 2.4'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new
rescue LoadError => e
  task :spec do
    abort "Please run `gem install rspec` to install RSpec."
  end
end

task :test    => :spec
task :default => :spec

begin
  gem 'yard', '~> 0.8'
  require 'yard'

  YARD::Rake::YardocTask.new  
rescue LoadError => e
  task :yard do
    abort "Please run `gem install yard` to install YARD."
  end
end
task :doc => :yard

require 'rubygems/package_task'
Gem::PackageTask.new(Gem::Specification.load('variation.gemspec')) do |pkg|
  pkg.need_tar = true
  pkg.need_zip = false
end
