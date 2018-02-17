require 'spec_helper'

describe Commands::List::ListHandler do
  let(:args) { {} }
  subject { described_class.new args }

  describe '#execute' do
    context "without arguments" do
      it "shows a list of installed rigs" do
        expect{ subject.execute }.to output(/- full.*- minimal/m).to_stdout
      end
    end

    context "when a rig folder is provided" do
      let(:args) {{ 'SUBFOLDER' => 'minimal' }}

      it 'shows a list of subfolders' do
        supress_output do
          expect{ subject.execute }.to output(/Subfolders.*- base.*- subfolder/m).to_stdout
        end
      end
    end
  end
end
