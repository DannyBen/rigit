require 'super_docopt'
require 'rigit/version'

module Rigit
  class CommandLine < SuperDocopt::Base
    version VERSION
    docopt File.expand_path 'docopt.txt', __dir__
    subcommands [:build, :install]

    include Commands::Build
    include Commands::Install
  end
end
