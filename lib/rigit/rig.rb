module Rigit
  class Rig
    attr_reader :name

    def self.home
      ENV['RIG_HOME'] ||= File.expand_path('.rigs', Dir.home)
    end

    def self.home=(path)
      ENV['RIG_HOME'] = path
    end

    def initialize(name)
      @name = name
    end

    def scaffold(arguments: {}, target_dir:'.', &block)
      scaffold_dir dir: "#{path}/base", arguments: arguments, 
        target_dir: target_dir, &block

      arguments.each do |key, value| 
        additive_dir = "#{path}/#{key}=#{value}"
        if Dir.exist? additive_dir
          scaffold_dir dir: additive_dir, arguments: arguments, 
            target_dir: target_dir, &block
        end
      end
    end

    def path
      "#{Rig.home}/#{name}"
    end

    def exist?
      Dir.exist? path
    end

    def has_config?
      File.exist? config_file
    end

    def config_file
      "#{path}/config.yml"
    end

    def config
      @config ||= Config.load(config_file)
    end

    def info
      {
        name: name,
        path: path,
        config: (has_config? ? File.read(config_file) : '<empty>')
      }
    end

    private

    def scaffold_dir(dir:, arguments:, target_dir:)
      files = Dir["#{dir}/**/*"].reject { |file| File.directory? file }

      files.each do |file|
        target_file = (file % arguments).sub dir, target_dir

        next if block_given? and !yield target_file

        content = File.read(file) % arguments
        File.deep_write target_file, content
      end
    end
  end
end
