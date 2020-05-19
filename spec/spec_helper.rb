require 'simplecov'
SimpleCov.start do
  add_filter "spec"
end

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require_relative '../lib/rigit'

include Rigit
require_relative 'spec_mixin'

RSpec.configure do |config|
  config.include SpecMixin
  config.approvals_path = File.expand_path 'fixtures', __dir__
  config.strip_ansi_escape = true
end

Rig.home = "#{Dir.pwd}/spec/rigs"
