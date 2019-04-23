module Rigit::Commands
  # The {List} module provides the {#list} command for the {CommandLine}
  # module.
  module List

    # The command line +list+ command.
    def list
      ListHandler.new(args).execute
    end

    # Internal class to handle listing of available rigs for the 
    # {CommandLine} class.
    class ListHandler
      include Colsole

      attr_reader :args, :subfolder

      def initialize(args)
        @args = args
        @subfolder = args['SUBFOLDER']
      end

      def execute
        prefix = subfolder ? "Subfolders" : "Rigs"
        say "#{prefix} in !txtgrn!#{basedir}!txtrst!:"
        dirs.each do |file|
          say "- #{file}"
        end
      end

      private

      def dirs
        files = Dir["#{basedir}/*"]
        files.select! { |f| File.directory? f }
        files.map { |f| File.basename f }.sort
      end

      def basedir
        base = Rigit::Rig.home
        subfolder ? "#{base}/#{subfolder}" : base
      end
    end
  end
end
