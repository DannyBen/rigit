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

  describe 'uninstall' do
    let(:argv) { %w[uninstall removeme] }
    before { File.deep_write "#{Rig.home}/removeme/touchy-file", 'i am touched' }
    after { system "rm -rf #{Rig.home}/removeme" if Dir.exist? "#{Rig.home}/removeme" }

    it 'works' do
      stdin_send('y', "\n") do
        expect{ described_class.execute argv }.to output(/Rig uninstalled.*successfully/).to_stdout
      end
      expect(Dir).not_to exist "#{Rig.home}/removeme"
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

  describe 'new' do
    let(:argv) { %w[new created_rig] }
    before { system "rm -rf #{Rig.home}/created_rig" if Dir.exist? "#{Rig.home}/created_rig" }

    it 'works' do
      expect{ described_class.execute argv }.to output(/Rig template created in .*created_rig/).to_stdout
    end
  end
end
