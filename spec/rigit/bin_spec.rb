require 'spec_helper'

describe 'bin/rig' do
  context "without arguments" do
    it "shows usage" do
      expect(`bin/rig`).to match_fixture('cli/usage')
    end
  end

  context "without --help" do
    it "shows extended usage" do
      expect(`bin/rig --help`).to match_fixture('cli/help')
    end
  end

  describe 'build' do
    let(:workdir) { 'spec/tmp' }
    before { reset_workdir }

    it "builds a rig" do
      Dir.chdir workdir do
        expect(`../../bin/rig build minimal`).to match_fixture('cli/build-nocolor')
      end
    end

    context "when source rig does not exist" do
      it "exits with grace" do
        expect(`bin/rig build norig`).to match_fixture('cli/build-norig')
      end
    end

    context "with an invalid rig config" do
      before do
        system 'rm -rf examples/broken' if Dir.exist? 'examples/bdoken'
        system 'cp -R examples/minimal examples/broken'
        system 'cp spec/fixtures/prompt-invalid.yml examples/broken/config.yml'
      end

      it "exits with grace" do
        Dir.chdir workdir do
          expect(`../../bin/rig build broken`).to match_fixture('cli/build-broken')
        end
      end
    end
  end

end
