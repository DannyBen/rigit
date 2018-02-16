require 'fileutils'
require 'colsole'

module Rigit::Commands
  module Install
    def install
      Installer.new(args).execute
    end

    class Installer
      include Colsole

      attr_reader :args, :rig_name, :repo, :target_dir

      def initialize(args)
        @args = args
        @rig_name = args['RIG']
        @repo = args['REPO']
        @target_dir = "#{ENV['RIG_HOME']}/#{name}"
      end

      def execute
        verify_dirs
        
        say "Installing !txtgrn!#{repo}\n"
        FileUtils.mkdir_p target_path unless Dir.exist? target_path
        success = pull_repo
 
        if success
          say "\nRig installed !txtgrn!successfully!txtrst! in !txtgrn!#{target_dir}"
          say "To build a new project with this rig, run this in any empty directory:\n"
          say "  !txtpur!rig build #{rig_name}"
        end
      end

      private

      def pull_repo
        system "git clone #{repo} #{target_dir}"
        $?.exitstatus == 0
      end

      def tty_prompt
        @tty_prompt ||= TTY::Prompt.new
      end

      def rig
        @rig ||= Rig.new rig_name
      end

      def target_dir
        @target_dir ||= rig.path
      end

      def verify_dirs
        if Dir.exist? rig.path
          say "Rig !txtgrn!#{rig_name}!txtrst! is already installed."
          continue = tty_prompt.yes? "Update?"
          raise Rigit::Exit, 'Goodbye' unless continue
        end
      end
    end
  end
end
