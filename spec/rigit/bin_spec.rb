require 'spec_helper'

describe 'bin/rig' do
  context "without arguments" do
    it "shows usage" do
      expect(`bin/rig`).to match_approval('cli/usage')
    end
  end

  context "without --help" do
    it "shows extended usage" do
      expect(`bin/rig --help`).to match_approval('cli/help')
    end
  end

  describe 'build' do
    let(:workdir) { 'spec/tmp' }
    before { reset_workdir }

    it "builds a rig" do
      Dir.chdir workdir do
        expect(`../../bin/rig build minimal`).to match_approval('cli/build-nocolor')
      end
    end

    context "when source rig does not exist" do
      it "exits with grace" do
        expect(`bin/rig build norig`).to match_approval('cli/build-norig')
      end
    end

    context "when there is a template error" do
      it "exits with grace" do
        Dir.chdir workdir do
          expect(`../../bin/rig build template-error`).to match(/TemplateError.*malformed format string/m)
        end
      end
    end

    context "with an invalid rig config" do
      it "exits with grace" do
        Dir.chdir workdir do
          expect(`../../bin/rig build broken`).to match_approval('cli/build-broken')
        end
      end
    end
  end

end
