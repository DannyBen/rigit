require 'colsole'

module Rigit::Commands
  module Build
    def build
      Builder.new(args).execute
    end

    class Builder
      attr_reader :args, :rig_name, :target_dir

      include Colsole

      def initialize(args)
        @args = args
        @rig_name = args['RIG']
        @target_dir = '.'
      end

      def execute
        say "Building !txtgrn!#{rig_name}"
        say "!txtblu!#{config.intro}\n\n" if config.has_key? :intro
        verify_dirs
        arguments = prompt.get_input params
        rig.scaffold arguments:arguments, target_dir: target_dir
        say "Done"
      end

      private

      def rig
        @rig ||= Rigit::Rig.new rig_name
      end

      def config
        @config ||= rig.config
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

      def verify_dirs
        verify_source_dir
        verify_target_dir
      end

      def verify_source_dir
        raise Rigit::Exit, "No such rig: #{source}" unless rig.exist?
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
