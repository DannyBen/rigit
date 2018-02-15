require 'super_docopt'

module Rigit
  class CommandLine < SuperDocopt::Base
    version VERSION
    docopt File.expand_path 'docopt', __dir__
    subcommands [:build]

    def build
      source = args['RIG']
      name   = args['NAME']
      config = config_for source

      prompt = Prompt.new config.params, intro: config.intro
      arguments = prompt.get_input params

      arguments[:name] = params[:name] || args['NAME']

      rigger = Rigger.new source, name, arguments
      rigger.scaffold
    end

    private

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
      @prompt ||= Prompt.new
    end

    def config_for(source)
      Config.load("#{source}/config.yml")
    end
  end
end
