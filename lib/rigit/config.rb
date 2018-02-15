require 'configatron/core'
require 'yaml'

module Rigit
  class Config
    attr_reader :path

    def self.load(path)
      new(path).settings
    end

    def initialize(path)
      @path = path
    end

    def settings
      @settings ||= settings!
    end

    def settings!
      settings = Configatron::RootStore.new
      settings.configure_from_hash YAML.load_file(path)
      settings
    end
  end
end