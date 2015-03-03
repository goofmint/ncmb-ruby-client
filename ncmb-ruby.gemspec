# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ncmb/version'

Gem::Specification.new do |spec|
  spec.name          = "ncmb-ruby"
  spec.version       = Ncmb::VERSION
  spec.authors       = ["John Lau"]
  spec.email         = ["jolks@outlook.com"]
  spec.description   = %q{Forked version of ncmb-ruby-client, a simple Ruby client for the nifty cloud mobile backend REST API}
  spec.summary       = %q{Forked version of ncmb-ruby-client, a simple Ruby client for the nifty cloud mobile backend REST API}
  spec.homepage      = "http://mb.cloud.nifty.com/"
  spec.license       = "MIT License"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
