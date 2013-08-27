# -*- encoding: utf-8 -*-

require File.expand_path('../lib/variation/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "variation"
  gem.version       = Variation::VERSION
  gem.summary       = %q{Compute values that change with time, with various transitions (immediate, linear, sigmoid)}
  gem.description   = %q{Compute values that change with time (or some independent variable), using various transitions (immediate, linear, sigmoid) between values.}
  gem.license       = "MIT"
  gem.authors       = ["James Tunnell"]
  gem.email         = "jamestunnell@gmail.com"
  gem.homepage      = "https://rubygems.org/gems/variation"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'yard', '~> 0.8'
end
