lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'evrobone/version'

Gem::Specification.new do |spec|
  spec.name          = 'evrobone'
  spec.version       = Evrobone::VERSION
  spec.authors       = ['Dmitry KODer Karpunin']
  spec.email         = ['koderfunk@gmail.com']

  spec.summary       = 'Light-weight client-side framework based on Backbone.js for Ruby on Rails Front-end'
  spec.description   = 'Light-weight client-side framework based on Backbone.js for Ruby on Rails Front-end'
  spec.homepage      = 'http://github.com/KODerFunk/evrobone'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'backbone-rails'
  spec.add_development_dependency 'turbolinks'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'coffeelint'
end
