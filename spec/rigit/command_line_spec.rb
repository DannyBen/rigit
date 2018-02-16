require 'spec_helper'

describe CommandLine do
  let(:workdir) { 'spec/tmp' }

  context "without arguments" do
    it "shows usage" do
      expect{ described_class.execute }.to output_fixture 'cli/usage'
    end
  end

  describe 'build' do
    let(:argv) { %w[build minimal] }
    before { reset_workdir }

    it 'works' do
      Dir.chdir workdir do
        expect{ described_class.execute argv }.to output_fixture 'cli/build'
      end
    end
  end

  describe 'install' do
    let(:argv) { %w[install pulled https://github.com/DannyBen/example-rig.git] }
    before { system 'rm -rf examples/pulled' if Dir.exist? 'examples/pulled' }

    it 'works' do
      expect_any_instance_of(Commands::Install::Installer).to receive(:system)
      expect{ described_class.execute argv }.to output(/Installing.*DannyBen\/example-rig.*successfully/m).to_stdout
    end
  end
end
