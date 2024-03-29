require 'spec_helper'

describe Commands::NewRig::NewRigHandler do
  subject { described_class.new args }

  let(:args) { { 'NAME' => 'newrig' } }

  describe '#execute' do
    it 'calls Rig::create and shows a message' do
      expect(Rigit::Rig).to receive(:create).with('newrig')
      expect { subject.execute }.to output(/Rig template created in.*newrig/).to_stdout
    end

    context 'when the rig already exists' do
      let(:args) { { 'NAME' => 'minimal' } }

      it 'shows a friendly message and raises Exit' do
        supress_output do
          expect(subject).to receive(:say).with('Rig g`minimal` already exists, choose a different name')
          expect { subject.execute }.to raise_error(Rigit::Exit)
        end
      end
    end
  end
end
