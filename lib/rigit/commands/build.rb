require 'super_docopt'

module Rigit::Commands
  module Build
    def build
      Builder.new(args).execute
    end

    class Builder
      attr_reader :args

      def initialize(args)
        @args = args
      end

      def execute
        puts "#{config.intro}\n\n" if config.intro
        verify_folders
        arguments = prompt.get_input params
        rigger = Rigit::Rigger.new source, arguments
        rigger.scaffold
      end

      private

      def config
        @config ||= config_for source
      end

      def source
        args['RIG']
      end

      def target_dir
        '.'
      end

      def source_dir
        "#{ENV['RIG_HOME']}/#{source}"
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

      def verify_folders
        if !Dir.exist? source_dir
          raise Rigit::Exit, "No such rig: #{source}"
        end

        if !Dir.empty? target_dir
          dirstring = target_dir == '.' ? 'Current directory' : "Directory '#{target_dir}'"
          continue = tty_prompt.yes? "#{dirstring} is not empty. Continue anyway?", default: false
          raise Rigit::Exit, "Goodbye" unless continue
        end
      end
    end
  end
end
