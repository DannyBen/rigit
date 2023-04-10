module Rigit
  class Exit < StandardError; end

  class ConfigError < ArgumentError; end

  class TemplateError < StandardError
    attr_reader :file

    def initialize(file, message = '')
      @file = file
      super message
    end
  end
end
