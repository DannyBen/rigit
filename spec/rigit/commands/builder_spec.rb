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
      let(:args) {{ 'RIG' => 'full', 'PARAMS' => [] }}

      it "asks for user input and copies the files" do
        Dir.chdir workdir do
          stdin_send('hello', 'n', "\n") do 
            expect{ subject.execute }.to output(/Name your project.*Include RSpec files.*Select console/m).to_stdout
          end
          expect(ls).to match_fixture 'ls/full2'
        end
      end
    end

    context "when params are provided in the command" do
      let(:args) {{ 'RIG' => 'full', 'PARAMS' => %w[name=hello spec=n console=irb license=MIT] }}

      it "does not ask for user input and copies the files" do
        Dir.chdir workdir do
          expect{ subject.execute }.to output(/Building.*full.*If you rig it, they will come.*Done/m).to_stdout
          expect(ls).to match_fixture 'ls/full2'
        end
      end
    end

    context "when the target dir is not empty", :focus do
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
