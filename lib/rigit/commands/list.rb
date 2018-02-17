require 'colsole'

module Rigit::Commands
  module List
    def list
      ListHandler.new(args).execute
    end

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
        files.map { |f| File.basename f }
      end

      def basedir
        base = Rigit::Rig.home
        subfolder ? "#{base}/#{subfolder}" : base
      end
    end
  end
end
