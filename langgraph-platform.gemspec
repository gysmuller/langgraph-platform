# frozen_string_literal: true

require_relative 'lib/langgraph_platform/version'

Gem::Specification.new do |spec|
  spec.name          = 'langgraph-platform'
  spec.version       = LanggraphPlatform::VERSION
  spec.authors       = ['Gys Muller']
  spec.email         = ['gysmuller@users.noreply.github.com']
  spec.summary       = 'Ruby SDK for LangGraph Platform API'
  spec.description   = 'An unoffical Ruby SDK for interacting with LangGraph Platform APIs'
  spec.homepage      = 'https://github.com/gysmuller/langgraph-platform'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.7.0'

  spec.files = Dir.glob('{bin,lib,exe}/**/*') + %w[LICENSE.txt README.md CHANGELOG.md]
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'event_stream_parser', '~> 1.0'
  spec.add_dependency 'http', '~> 5.0'
  spec.add_dependency 'multi_json', '~> 1.15'
  spec.add_dependency 'zeitwerk', '~> 2.6'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
