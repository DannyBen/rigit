require 'colsole'

module Rigit::Commands
  module Update
    def update
      UpdateHandler.new(args).execute
    end

    class UpdateHandler
      include Colsole

      attr_reader :args, :rig_name

      def initialize(args)
        @args = args
        @rig_name = args['RIG']
      end

      def execute
        verify_dirs
        update
      end

      private

      def update
        say "Updating !txtgrn!#{rig_name}"
        success = Rigit::Git.pull target_path
        if success
          say "Rig updated !txtgrn!successfully!txtrst!"
        else
          # :nocov:
          say "!txtred!Update failed"
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
        if !rig.exist?
          say "Rig !txtgrn!#{rig_name}!txtrst! is not installed"
          raise Rigit::Exit
        end
      end
    end
  end
end
