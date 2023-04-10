lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rigit/version'

Gem::Specification.new do |s|
  s.name        = 'rigit'
  s.version     = Rigit::VERSION
  s.summary     = 'Zero-coding project scaffolding'
  s.description = 'Build project templates with ease'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ['rig']
  s.homepage    = 'https://dannyben.github.io/rigit/'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.0'

  s.add_runtime_dependency 'colsole', '>= 0.8.1', '< 2'
  s.add_runtime_dependency 'configatron', '~> 4.5'
  s.add_runtime_dependency 'super_docopt', '~> 0.1'
  s.add_runtime_dependency 'tty-prompt', '~> 0.19'
  s.metadata['rubygems_mfa_required'] = 'true'
end
