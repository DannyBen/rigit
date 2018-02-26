module Rigit
  # A utility class that handles all +git+ operations.
  class Git
    # Clones a git repo.
    def self.clone(repo, target_path)
      execute %Q[git clone #{repo} "#{target_path}"]
    end

    # Pulls a git repo.
    def self.pull(target_path)
      Dir.chdir target_path do
        execute %Q[git pull]
      end
    end

    private

    def self.execute(command)
      if ENV['SIMULATE_GIT']
        puts "Simulated Execute: #{command}"
        true
      else
        system command
        $?&.exitstatus == 0
      end
    end
  end
end
