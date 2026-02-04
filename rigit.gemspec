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
  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'colsole', '~> 1.0'
  s.add_dependency 'configatron', '~> 4.5'
  s.add_dependency 'super_docopt', '~> 0.1'
  s.add_dependency 'tty-prompt', '~> 0.19'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/dannyben/rigit/issues',
    'changelog_uri'         => 'https://github.com/dannyben/rigit/blob/master/CHANGELOG.md',
    'source_code_uri'       => 'https://github.com/dannyben/rigit',
    'rubygems_mfa_required' => 'true',
  }
end
