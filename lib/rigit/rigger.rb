module Rigit
  class Rigger
    attr_reader :source_dir, :target_dir, :arguments

    def initialize(source_dir, target_dir, arguments={})
      @source_dir = source_dir
      @target_dir = target_dir
      @arguments = arguments
    end

    def scaffold
      scaffold_dir "#{source_dir}/base"

      arguments.each do |key, value| 
        additive_dir = "#{source_dir}/#{key}=#{value}"
        if Dir.exist? additive_dir
          scaffold_dir additive_dir
        end
      end
    end

    def scaffold_dir(dir)
      files = Dir["#{dir}/**/*"].reject { |file| File.directory? file }
      
      files.each do |file|
        target_file = (file % arguments).sub dir, target_dir
        content = File.read(file) % arguments
        File.deep_write target_file, content
      end
    end
  end
end