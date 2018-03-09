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

      # Call Rig#scaffold while checking each file to see if it should be
      # overwritten or not.
      def scaffold(arguments)
        execute_actions config.before, arguments if config.has_key? :before
        
        rig.scaffold arguments: arguments, target_dir: target_dir do |file|
          overwrite_file? file
        end

        execute_actions config.after, arguments if config.has_key? :after
      end

      def execute_actions(actions, arguments)
        actions.each do |label, command|
          say "\n!txtgrn!#{label}" % arguments
          system command % arguments
        end
        say "" unless actions.empty?
      end

      # Check various scenarios to decide if the file should be overwritten
      # or not. These are the scenarios covered by this method:
      # 1. The user provided +--focce+ in the command line
      # 2. The user answered "overwrite all" or "skip all" when he asked 
      #    about the first conflicting file.
      # 3. In cases where an additive dir contains a file that was originally
      #    new, approved or rejected - we use this existing knowledge (which
      #    is stored in +response_log+.
      def overwrite_file?(file)
        return response_log[file] if response_log.has_key? file

        response_log[file] = true

        unless overwrite_all or force
          if skip_all
            response_log[file] = false
          elsif File.exist? file
            response_log[file] = prompt_user_to_overwrite file
          end
        end

        response_log[file]
      end

      def prompt_user_to_overwrite(file)
        say "\nFile !txtgrn!#{file}!txtrst! already exists."
        tty_prompt.expand "Overwrite?" do |menu|
          menu.choice key: 'y', name: 'overwrite',     value: true
          menu.choice key: 'n', name: 'skip',          value: false
          menu.choice key: 'a', name: 'overwrite all'  do @overwrite_all = true; true end
          menu.choice key: 's', name: 'skip all'       do @skip_all = true; false end
        end
      end

      def response_log
        @response_log ||= {}
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
