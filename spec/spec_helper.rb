require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

include Rigit

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

  def ls
    Dir['**/*'].sort.to_s
  end

  def reset_workdir
    system 'rm -rf spec/tmp' if Dir.exist? 'spec/tmp'
    Dir.mkdir 'spec/tmp'
  end
end

RSpec.configure do |c|
  c.include RSpecMixin
end

Rig.home = "#{Dir.pwd}/examples"
