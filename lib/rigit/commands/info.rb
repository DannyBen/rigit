module Rigit::Commands
  # The {Info} module provides the {#info} command for the {CommandLine}
  # module.
  module Info
    
    # The command line +info+ command.
    def info
      InfoHandler.new(args).execute
    end

    # Internal class to handle the display of metadata about a rig for the 
    # {CommandLine} class.
    class InfoHandler
      include Colsole

      attr_reader :args, :rig_name

      def initialize(args)
        @args = args
        @rig_name = args['RIG']
      end

      def execute
        verify_presence
        info
      end

      private

      def info
        rig.info.each do |key, value|
          say "!txtgrn!#{key}!txtrst!:"
          say word_wrap "  #{value}"
          say ""
        end
      end

      def rig
        @rig ||= Rigit::Rig.new rig_name
      end

      def verify_presence
        if !rig.exist?
          say "Cannot find rig !txtgrn!#{rig_name}"
          raise Rigit::Exit
        end
      end
    end
  end
end
