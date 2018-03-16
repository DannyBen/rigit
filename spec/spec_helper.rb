require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'simplecov'
SimpleCov.start

require_relative '../lib/rigit'

include Rigit
require_relative 'spec_mixin'

RSpec.configure do |c|
  c.include SpecMixin
end

Rig.home = "#{Dir.pwd}/spec/rigs"
