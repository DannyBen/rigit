require 'spec_helper'

describe Commands::Build::Builder do
  let(:args) {{ 'RIG' => 'full', 'PARAMS' => [] }}
  subject { described_class.new args }

  describe '#execute' do
    let(:workdir) { 'spec/tmp' }
    before { reset_workdir }

    context "without config" do
      let(:args) {{ 'RIG' => 'minimal', 'PARAMS' => [] }}
      
      it 'copies the files without complaining' do
        Dir.chdir workdir do
          subject.execute
          expect(ls).to match_fixture 'ls/minimal'
        end
      end
    end

    context "with full example" do
      it "asks for user input and copies the files"
    end

    context "when the target dir is not empty" do
      it "asks if the user wants to continue"

      context "when the user answers no" do
        it "raises an error"
      end

      context "when the user answers yes" do
        it "copies the files"
      end
    end

    context "when the source dir is not" do
      it "raises an error"
    end
  end
end
