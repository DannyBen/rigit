require 'spec_helper'

describe Commands::Install::InstallHandler do
  let(:args) {{ 'RIG' => 'pulled', 'REPO' => 'https://some.repo/url' }}
  subject { described_class.new args }

  describe '#execute' do
    context "when the rig is already installed" do
      before :all do
        File.deep_write "#{Rig.home}/pulled/touchy-file", 'i am touched'
      end

      it 'shows a friendly message and raises Exit' do
        supress_output do
          allow(subject).to receive(:say)
          expect(subject).to receive(:say).with('Rig !txtgrn!pulled!txtrst! is already installed')
          expect{ subject.execute }.to raise_error(Rigit::Exit)
        end
      end
    end

    context "when the rig is not installed" do
      before { system "rm -rf #{Rig.home}/pulled" if Dir.exist? "#{Rig.home}/pulled" }

      it "pulls the rig from the git repo" do
        with_env 'SIMULATE_GIT' do
          expect{ subject.execute }.to output(/Installing.*https:\/\/some.repo\/url.*git clone https:\/\/some.repo\/url.*rigs\/pulled.*successfully/m).to_stdout
        end
      end
    end

  end
end
