require 'spec_helper'

describe Commands::Update::UpdateHandler do
  subject { described_class.new args }

  let(:args) { { 'RIG' => 'pulled' } }

  describe '#execute' do
    context 'when the rig is installed' do
      it 'pulls the rig from the git repo' do
        with_env 'SIMULATE_GIT' do
          expect { subject.execute }.to output_approval('cli/update')
        end
      end
    end

    context 'when the rig is not installed' do
      let(:args) { { 'RIG' => 'no-such-rig' } }

      it 'shows a friendly message and raises Exit' do
        supress_output do
          expect(subject).to receive(:say).with('Rig g`no-such-rig` is not installed')
          expect { subject.execute }.to raise_error(Rigit::Exit)
        end
      end
    end
  end
end
