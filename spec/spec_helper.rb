require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'stringio'

module RSpecMixin
  def stdin_send(*args)
    begin
      $stdin = StringIO.new
      $stdin.puts(args.shift) until args.empty?
      $stdin.rewind
      yield
    ensure
      $stdin = STDIN
    end
  end
end

RSpec.configure do |c|
  c.include RSpecMixin
end

include Rigit

