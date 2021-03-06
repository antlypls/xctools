# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xctools/version'

Gem::Specification.new do |spec|
  spec.name          = 'xctools'
  spec.version       = XcTools::VERSION
  spec.authors       = ['Anatoliy Plastinin']
  spec.email         = ['hello@antlypls.com']
  spec.summary       = 'Helpers for parsing Xcode CLI tools output.'
  spec.description   = 'Helpers for parsing Xcode CLI tools output.'
  spec.homepage      = 'https://github.com/antlypls/xctools'
  spec.license       = 'MIT'

  spec.files         = %w(README.md LICENSE)
  spec.files         += Dir.glob('lib/**/*.rb')

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
end
