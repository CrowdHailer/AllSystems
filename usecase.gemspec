# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'all_systems/version'

Gem::Specification.new do |spec|
  spec.name          = "all_systems"
  spec.version       = AllSystems::VERSION
  spec.authors       = ["Peter Saxton"]
  spec.email         = ["peterhsaxton@gmail.com"]
  spec.summary       = %q{Simple usecase/interactor/service objects to encapsulate business logic}
  spec.description   = %q{An interactor encapsulates the action of specific business usecase. For example a `LogIn` or `CreatePost`. It executes this action by coordinating the interaction of other business objects in the system.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.4.3"
  spec.add_development_dependency "minitest-reporters", "~> 1.0.6"
end
