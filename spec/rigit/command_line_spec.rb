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
    let(:argv) { %w[install pulled https://github.com/some/repo.git] }
    before { system "rm -rf #{Rig.home}/pulled" if Dir.exist? "#{Rig.home}/pulled" }

    it 'works' do
      with_env 'SIMULATE_GIT' do
        expect{ described_class.execute argv }.to output(/Installing.*some\/repo.*git clone.*successfully/m).to_stdout
      end
    end
  end

  describe 'update' do
    let(:argv) { %w[update pulled] }
    before { FileUtils.mkdir "#{Rig.home}/pulled" unless Dir.exist? "#{Rig.home}/pulled" }

    it 'works' do
      with_env 'SIMULATE_GIT' do
        expect{ described_class.execute argv }.to output_fixture('cli/update')
      end
    end
  end

  describe 'info' do
    let(:argv) { %w[info minimal] }

    it 'works' do
      expect{ described_class.execute argv }.to output(/name.*minimal.*path.*config.*\<empty\>/m).to_stdout
    end
  end

  describe 'list' do
    let(:argv) { %w[list] }

    it 'works' do
      expect{ described_class.execute argv }.to output(/- full.*- minimal/m).to_stdout
    end
  end
end
