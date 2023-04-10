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
        say "Updating g`#{rig_name}`"
        success = Rigit::Git.pull target_path
        if success
          say "Rig updated g`successfully`"
        else
          # :nocov:
          say "r`Update failed`"
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
          say "Rig g`#{rig_name}` is not installed"
          raise Rigit::Exit
        end
      end
    end
  end
end
