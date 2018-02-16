require 'spec_helper'

describe Git do
  context 'when SIMULATE_GIT is not set' do
    it 'executes the git command' do
      without_env 'SIMULATE_GIT' do
        expect(Git).to receive(:system).with('git clone repo "folder"')
        Git.clone 'repo', 'folder'
      end
    end
  end

  context 'when SIMULATE_GIT is set' do
    it 'prints the git command' do
      with_env 'SIMULATE_GIT' do
        expect{ Git.clone 'repo', 'folder' }.to output("Simulated Execute: git clone repo \"folder\"\n").to_stdout
      end
    end
  end

  describe '::clone' do
    it 'works' do
      with_env 'SIMULATE_GIT' do
        expect{ Git.clone 'repo', 'folder' }.to output("Simulated Execute: git clone repo \"folder\"\n").to_stdout
      end
    end
  end

  describe '::pull' do
    it 'works' do
      with_env 'SIMULATE_GIT' do
        expect{ Git.pull 'examples/minimal' }.to output("Simulated Execute: git pull\n").to_stdout
      end
    end
  end
end
