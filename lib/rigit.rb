require 'rigit/extensions/file_extension.rb'

require 'rigit/commands/build'

require 'rigit/command_line'
require 'rigit/config'
require 'rigit/errors'
require 'rigit/prompt'
require 'rigit/rigger'

ENV['RIG_HOME'] ||= File.expand_path('.rigs', Dir.home)

module Rigit
  module Commands
  end
end
