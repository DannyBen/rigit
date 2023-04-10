require 'spec_helper'

describe Git do
  context 'when SIMULATE_GIT is not set' do
    it 'executes the git command' do
      without_env 'SIMULATE_GIT' do
        expect(described_class).to receive(:system).with('git clone repo "folder"')
        described_class.clone 'repo', 'folder'
      end
    end
  end

  context 'when SIMULATE_GIT is set' do
    it 'prints the git command' do
      with_env 'SIMULATE_GIT' do
        expect do
          described_class.clone 'repo', 'folder'
        end.to output("Simulated Execute: git clone repo \"folder\"\n").to_stdout
      end
    end
  end

  describe '::clone' do
    it 'executes successfully' do
      with_env 'SIMULATE_GIT' do
        expect do
          described_class.clone 'repo', 'folder'
        end.to output("Simulated Execute: git clone repo \"folder\"\n").to_stdout
      end
    end
  end

  describe '::pull' do
    it 'executes successfully' do
      with_env 'SIMULATE_GIT' do
        expect { described_class.pull "#{Rig.home}/minimal" }
          .to output("Simulated Execute: git pull\n").to_stdout
      end
    end
  end
end
