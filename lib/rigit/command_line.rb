require 'super_docopt'
require 'rigit/version'

require 'rigit/commands/build'
require 'rigit/commands/install'
require 'rigit/commands/update'
require 'rigit/commands/info'

module Rigit
  class CommandLine < SuperDocopt::Base
    version VERSION
    docopt File.expand_path 'docopt.txt', __dir__
    subcommands [:build, :install, :update, :info]

    include Commands::Build
    include Commands::Install
    include Commands::Update
    include Commands::Info
  end
end
