require 'fileutils'
require 'colsole'

module Rigit::Commands
  module Install
    def install
      Installer.new(args).execute
    end

    class Installer
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
        say "Installing !txtgrn!#{repo}"
        FileUtils.mkdir_p target_path unless Dir.exist? target_path
        success = Rigit::Git.clone repo, target_path

        if success
          say "Rig installed !txtgrn!successfully!txtrst! in !txtgrn!#{target_path}"
          say "To build a new project with this rig, run this in any empty directory:\n"
          say "  !txtpur!rig build #{rig_name}\n"
        else
          # :nocov:
          say "!txtred!Installation failed"
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
        if rig.exist?
          say "Rig !txtgrn!#{rig_name}!txtrst! is already installed"
          say "In order to update it from the source repository, run:\n"
          say "  !txtpur!rig update #{rig_name}\n"
          raise Rigit::Exit
        end
      end
    end
  end
end
