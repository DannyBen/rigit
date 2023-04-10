module Rigit
  # A utility class that handles all +git+ operations.
  class Git
    # Clones a git repo.
    def self.clone(repo, target_path)
      execute %[git clone #{repo} "#{target_path}"]
    end

    # Pulls a git repo.
    def self.pull(target_path)
      Dir.chdir target_path do
        execute %[git pull]
      end
    end

    def self.execute(command)
      if ENV['SIMULATE_GIT']
        puts "Simulated Execute: #{command}"
        true
      else
        system command
        $?&.exitstatus&.zero?
      end
    end
  end
end
