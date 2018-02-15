require 'super_docopt'

module Rigit
  class CommandLine < SuperDocopt::Base
    version '0.0.0'
    docopt File.expand_path 'docopt', __dir__
    subcommands [:build]

    def build
      source = args['RIG']
      name   = args['NAME']
      rigger = Rigger.new source, name, arguments
      rigger.scaffold
    end

    private

    def arguments
      result = {}
      config.params.each do |key, spec|
        default_value = spec.is_a?(Array) ? spec.first : spec
        result[key.to_sym] = params[key] || default_value
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

    def config
      @config ||= Config.load('example/source/config.yml')
    end
  end
end
