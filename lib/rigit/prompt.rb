require 'tty-prompt'

module Rigit
  class Prompt
    attr_reader :params

    def initialize(params)
      @params = params
    end

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
        raise "Unknown type #{param[:type]}"
      end
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end