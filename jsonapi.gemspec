# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonapi/version'

Gem::Specification.new do |spec|
  spec.name          = "jsonapi"
  spec.version       = Jsonapi::VERSION
  spec.authors       = ["k5342"]
  spec.email         = ["ksswre@yahoo.co.jp"]
  spec.summary       = %q{A Ruby library to access Bukkit server over JSONAPI plugin.}
  spec.description   = %q{A Ruby library to access Bukkit server over JSONAPI plugin.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
