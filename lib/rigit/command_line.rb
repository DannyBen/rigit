require 'fileutils'
require 'colsole'
require 'super_docopt'

require 'rigit/version'

require 'rigit/commands/build'
require 'rigit/commands/info'
require 'rigit/commands/install'
require 'rigit/commands/list'
require 'rigit/commands/uninstall'
require 'rigit/commands/update'
require 'rigit/commands/new_rig'

module Rigit
  # Handles command line execution using docopt.
  class CommandLine < SuperDocopt::Base
    version VERSION
    docopt File.expand_path 'docopt.txt', __dir__
    subcommands [:build, :install, :uninstall, :update, :info, :list, { new: :new_rig }]

    include Commands::Build
    include Commands::Install
    include Commands::Uninstall
    include Commands::Update
    include Commands::Info
    include Commands::List
    include Commands::NewRig
  end
end
