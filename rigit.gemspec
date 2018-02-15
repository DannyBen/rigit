lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'rigit/version'

Gem::Specification.new do |s|
  s.name        = 'rigit'
  s.version     = Rigit::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Zero-coding project scaffolding"
  s.description = "Build project templates with ease"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ["rig"]
  s.homepage    = 'https://github.com/DannyBen/rigit'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.0.0"

  s.add_runtime_dependency 'super_docopt', '~> 0.1'
  s.add_runtime_dependency 'configatron', '~> 4.5'
  s.add_runtime_dependency 'tty-prompt', '~> 0.15'

  s.add_development_dependency 'runfile', '~> 0.10'
  s.add_development_dependency 'runfile-tasks', '~> 0.4'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rdoc', '~> 5.1'
  s.add_development_dependency 'byebug', '~> 9.0'
  s.add_development_dependency 'simplecov', '~> 0.15'
  s.add_development_dependency 'yard', '~> 0.9'
end
