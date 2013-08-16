# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fucking_shell_scripts/version'

Gem::Specification.new do |spec|
  spec.name          = "fucking_shell_scripts"
  spec.version       = FuckingShellScripts::VERSION
  spec.authors       = ["Brandon Hilkert"]
  spec.email         = ["brandonhilkert@gmail.com"]
  spec.description   = %q{The easiest, most common sense configuration management tool... because you just use fucking shell scripts.}
  spec.summary       = %q{The easiest, most common sense configuration management tool... because you just use fucking shell scripts.}
  spec.homepage      = "https://github.com/brandonhilkert/fucking_shell_scripts"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "fog", "~> 1.14.0"
end
