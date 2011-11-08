# -*- encoding: utf-8 -*-
require File.expand_path('../lib/release_marker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mike Dalessio"]
  gem.email         = ["mike@csa.net"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "release_marker"
  gem.require_paths = ["lib"]
  gem.version       = ReleaseMarker::VERSION

  gem.add_development_dependency "rspec", "~> 2.0"
  gem.add_development_dependency "rake", ">= 0.8"
end
