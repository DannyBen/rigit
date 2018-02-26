require 'tty-prompt'

module Rigit
  # Handles prompt request for user input in batch.
  # This is a wrapper around +TTY::Prompt+ that gets all the params (typically
  # from the rig config file), and asks the user for input one by one, while 
  # considering prefilled values.
  class Prompt
    attr_reader :params

    def initialize(params)
      @params = params
    end

    # Asks the user for input. If a +prefill+ hash is provided, it will be
    # used for values, and skip asking the user to provide answers for the
    # ones that are prefilled.
    def get_input(prefill={})
      result = {}
      params.each do |key, spec|
        result[key] = prefill.has_key?(key) ? prefill[key] : ask(spec)
      end
      result
    end

    private

    def ask(param)
      text = param.prompt
      default = param.default

      case param[:type]
      when 'yesno'
        prompt.yes?(text, default: default) ? 'yes' : 'no'
      when 'text'
        prompt.ask text, default: default
      when 'select'
        prompt.select text, param.list, marker: '>'
      else
        raise ConfigError, "Unknown type '#{param[:type]}'"
      end
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end