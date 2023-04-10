module Rigit::Commands
  # The {Install} module provides the {#install} command for the
  # {CommandLine} module.
  module Install
    # The command line +install+ command.
    def install
      InstallHandler.new(args).execute
    end

    # Internal class to handle rig installation for the {CommandLine} class.
    class InstallHandler
      include Colsole

      attr_reader :args, :rig_name, :repo

      def initialize(args)
        @args = args
        @rig_name = args['RIG']
        @repo = args['REPO']
      end

      def execute
        verify_dirs
        install
      end

    private

      def install
        say "Installing g`#{repo}`"
        FileUtils.mkdir_p target_path unless Dir.exist? target_path
        success = Rigit::Git.clone repo, target_path

        if success
          say "Rig installed g`successfully` in g`#{target_path}`"
          say "To build a new project with this rig, run this in any empty directory:\n"
          say "  m`rig build #{rig_name}`\n"
        else
          # :nocov:
          say 'r`Install failed`'
          # :nocov:
        end
      end

      def rig
        @rig ||= Rigit::Rig.new rig_name
      end

      def target_path
        @target_path ||= rig.path
      end

      def verify_dirs
        return unless rig.exist?

        say "Rig g`#{rig_name}` is already installed"
        say "In order to update it from the source repository, run:\n"
        say "  m`rig update #{rig_name}`\n"
        raise Rigit::Exit
      end
    end
  end
end
