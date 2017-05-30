# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ncmb/version'

Gem::Specification.new do |spec|
  spec.name          = 'ncmb-ruby-client'
  spec.version       = Ncmb::VERSION
  spec.authors       = ['Atsushi Nakatsugawa']
  spec.email         = ['atsushi@moongift.jp']
  spec.description   = %q(A simple Ruby client for the nifty cloud mobile backend REST API)
  spec.summary       = %q(A simple Ruby client for the nifty cloud mobile backend REST API)
  spec.homepage      = 'http://mb.cloud.nifty.com/'
  spec.license       = 'MIT License'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
