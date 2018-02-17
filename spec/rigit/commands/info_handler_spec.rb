require 'spec_helper'

describe Commands::Info::InfoHandler do
  let(:args) {{ 'RIG' => 'full' }}
  subject { described_class.new args }

  describe '#execute' do
    context "when the rig is installed" do
      it "shows meta information" do
        expect{ subject.execute }.to output(/name.*full.*path.*config.*intro.*If you rig it, they will come.*params.*prompt.*Name your project/m).to_stdout
      end
    end

    context "when the rig is not installed" do
      let(:args) {{ 'RIG' => 'no-such-rig' }}

      it 'shows a friendly message and raises Exit' do
        supress_output do
          expect(subject).to receive(:say).with('Cannot find rig !txtgrn!no-such-rig')
          expect{ subject.execute }.to raise_error(Rigit::Exit)
        end
      end
    end
  end
end
