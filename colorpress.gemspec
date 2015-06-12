# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'colorpress/version'

Gem::Specification.new do |spec|
  spec.name = 'colorpress'
  spec.version = Colorpress::VERSION
  spec.authors = ['Luc Street']

  spec.summary = 'A new kind of compression.'
  spec.homepage = 'https://github.com/phatdoggi/colorpress'
  spec.license = 'GPL-3.0'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'minitest', '~> 5.7.0'

  spec.add_dependency 'oily_png'
end
