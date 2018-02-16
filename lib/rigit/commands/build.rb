require 'super_docopt'

module Rigit::Commands
  module Build
    def build
      Builder.new(args).execute
    end

    class Builder
      attr_reader :args, :source, :target_dir, :source_dir

      def initialize(args)
        @args = args
        @source = args['RIG']
        @target_dir = '.'
        @source_dir = "#{ENV['RIG_HOME']}/#{source}"
      end

      def execute
        puts "#{config.intro}\n\n" if config.has_key? :intro
        verify_dirs
        arguments = prompt.get_input params
        rigger = Rigit::Rigger.new source, arguments
        rigger.scaffold
      end

      private

      def config
        @config ||= config_for source
      end

      def params
        @params ||= params!
      end

      def params!
        output = {}
        input = args['PARAMS']
        input.each do |param|
          key, value = param.split '='
          output[key.to_sym] = value
        end
        output
      end

      def prompt
        @prompt ||= Rigit::Prompt.new config.params
      end

      def tty_prompt
        @tty_prompt ||= TTY::Prompt.new
      end

      def config_for(source)
        Rigit::Config.load("#{ENV['RIG_HOME']}/#{source}/config.yml")
      end

      def verify_dirs
        verify_source_dir
        verify_target_dir
      end

      def verify_source_dir
        if !Dir.exist? source_dir
          raise Rigit::Exit, "No such rig: #{source}"
        end
      end

      def verify_target_dir
        if !Dir.empty? target_dir
          dirstring = target_dir == '.' ? 'Current directory' : "Directory '#{target_dir}'"
          continue = tty_prompt.yes? "#{dirstring} is not empty. Continue anyway?", default: false
          raise Rigit::Exit, "Goodbye" unless continue
        end
      end
    end
  end
end
