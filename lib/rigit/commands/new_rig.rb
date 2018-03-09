module Rigit::Commands
  # The {NewRIg} module provides the {#new_rig} command for the {CommandLine}
  # module.
  module NewRig
    
    # The command line +new+ command.
    def new_rig
      NewRigHandler.new(args).execute
    end

    # Internal class to handle the creation of a new rig template for the 
    # {CommandLine} class.
    class NewRigHandler
      include Colsole

      attr_reader :args, :name

      def initialize(args)
        @args = args
        @name = args['NAME']
      end

      def execute
        verify_presence
        Rigit::Rig.create name
        say "Rig template created in !txtgrn!#{rig.path}"
      end

      private

      def rig
        @rig ||= Rigit::Rig.new name
      end

      def verify_presence
        if rig.exist?
          say "Rig #{name} already exists, choose a different name"
          raise Rigit::Exit
        end
      end
    end
  end
end
