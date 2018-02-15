require 'super_docopt'

module Rigit
  class CommandLine < SuperDocopt::Base
    version '0.0.0'
    docopt File.expand_path 'docopt', __dir__
    subcommands [:build]

    attr_reader :config

    def build
      source = args['RIG']
      name   = args['NAME']
      @config = config_for source
      rigger = Rigger.new source, name, arguments
      rigger.scaffold
    end

    private

    def arguments
      result = {}
      config.params.each do |key, spec|
        result[key.to_sym] = params[key] || spec.default
      end
      result[:name] = params[:name] || args['NAME']
      result
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

    def config_for(source)
      Config.load("#{source}/config.yml")
    end
  end
end
