require 'super_docopt'

module Rigit::Commands
  module Build
    def build
      Builder.new(args).execute
    end

    class Builder
      attr_reader :args

      def initialize(args)
        @args = args
      end

      def execute
        abort "Directory is not empty." unless Dir.empty?(Dir.pwd)
        arguments = prompt.get_input params
        rigger = Rigit::Rigger.new source, arguments
        rigger.scaffold
      end

      private

      def config
        @config ||= config_for source
      end

      def source
        args['RIG']
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
        @prompt ||= Rigit::Prompt.new config.params, intro: config.intro
      end

      def config_for(source)
        Rigit::Config.load("#{source}/config.yml")
      end
    end
  end
end
