# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'colorpress/version'

Gem::Specification.new do |spec|
  spec.name = 'colorpress'
  spec.version = Colorpress::VERSION
  spec.authors = ['Luc Street']

  spec.summary = 'Visualize arbitrary files as PNG images'
  spec.homepage = 'https://github.com/lucis-fluxum/colorpress'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1.2'
  spec.add_development_dependency 'rake', '~> 13.0.1'
  spec.add_development_dependency 'yard', '~> 0.9.24'
  spec.add_development_dependency 'minitest', '~> 5.14.0'

  spec.add_dependency 'chunky_png', '~> 1.3.11'
end
