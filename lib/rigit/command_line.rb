require 'super_docopt'

module Rigit
  class CommandLine < SuperDocopt::Base
    version VERSION
    docopt File.expand_path 'docopt.txt', __dir__
    subcommands [:build]

    include Commands::Build
  end
end
