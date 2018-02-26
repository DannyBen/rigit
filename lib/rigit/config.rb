require 'configatron/core'
require 'yaml'

module Rigit
  # Handles the rig config file.
  # Usage example: 
  # 
  #    Config.load 'path/to.yml'
  #
  class Config
    attr_reader :path

    # Returns a new +configatron+ instance, after loading from a YAML file.
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
      settings.configure_from_hash YAML.load_file(path) if File.exist? path
      settings
    end
  end
end