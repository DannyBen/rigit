module Rigit::Commands
  # The {Build} module provides the {#build} command for the {CommandLine}
  # module.
  module Build

    # The command line +build+ command.
    def build
      BuildHandler.new(args).execute
    end

    # Internal class to handle scaffolding for the {CommandLine} class.
    class BuildHandler
      attr_reader :args, :rig_name, :target_dir, :force
      attr_accessor :overwrite_all, :skip_all

      include Colsole

      def initialize(args)
        @args = args
        @rig_name = args['RIG']
        @force = args['--force']
        @target_dir = '.'
      end

      def execute
        say "Building !txtgrn!#{rig_name}"
        say config.intro if config.has_key? :intro
        verify_dirs
        arguments = prompt.get_input params

        scaffold arguments

        say config.has_key?(:outro) ? config.outro : "Done"
      end

      private

      def scaffold(arguments)
        rig.scaffold arguments: arguments, target_dir: target_dir do |file|
          if overwrite_all or force
            true
          elsif skip_all
            false
          elsif File.exist? file
            prompt_user_to_overwrite file
          else
            true
          end
        end
      end

      def prompt_user_to_overwrite(file)
        say "File !txtgrn!#{file}!txtrst! already exists."
        tty_prompt.expand "Overwrite?" do |menu|
          menu.choice key: 'y', name: 'overwrite',     value: :y
          menu.choice key: 'n', name: 'skip',          value: :n
          menu.choice key: 'a', name: 'overwrite all'  do @overwrite_all = true; true end
          menu.choice key: 's', name: 'skip all'       do @skip_all = true; false end
        end
      end

      def overwrite_options(file)
        {
          "Overwrite #{file}" => :y,
          "Skip #{file}" => :n,
          "Overwrite all" => :ya,
          "Skip all" => :na
        }
      end

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
        raise Rigit::Exit, "No such rig: #{rig_name}" unless rig.exist?
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
