require 'super_docopt'
require 'rigit/version'

require 'rigit/commands/build'
require 'rigit/commands/info'
require 'rigit/commands/install'
require 'rigit/commands/list'
require 'rigit/commands/update'

module Rigit
  # Handles command line execution using docopt.
  class CommandLine < SuperDocopt::Base
    version VERSION
    docopt File.expand_path 'docopt.txt', __dir__
    subcommands [:build, :install, :update, :info, :list]

    include Commands::Build
    include Commands::Install
    include Commands::Update
    include Commands::Info
    include Commands::List
  end
end
