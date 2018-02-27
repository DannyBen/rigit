require 'spec_helper'

describe Commands::Uninstall::UninstallHandler do
  let(:args) {{ 'RIG' => 'removeme' }}
  subject { described_class.new args }

  describe '#execute' do
    context "when the rig is installed" do
      file = "#{Rig.home}/removeme/touchy-file"

      before :all do
        File.deep_write file, 'i am touched'
      end

      after :all do
        system "rm -rf #{Rig.home}/removeme" if Dir.exist? "#{Rig.home}/removeme"
      end

      context "when the user says no" do
        it "does not delete the folder" do
          stdin_send('n', "\n") do 
            expect{ subject.execute }.to output(/This will remove.*removeme.*and delete.*spec\/rigs\/removeme/m).to_stdout
          end
          expect(File).to exist file
        end
      end

      context "when the user says yes" do
        it "deletes the folder" do
          stdin_send('y', "\n") do 
            expect{ subject.execute }.to output(/Uninstalling.*removeme.*Rig uninstalled.*successfully/m).to_stdout
          end
          expect(File).not_to exist file
        end
      end
    end

    context "when the rig is not installed" do
      before { system "rm -rf #{Rig.home}/removeme" if Dir.exist? "#{Rig.home}/removeme" }

      it 'shows a friendly message and raises Exit' do
        supress_output do
          allow(subject).to receive(:say)
          expect(subject).to receive(:say).with('Rig !txtgrn!removeme!txtrst! is not installed')
          expect{ subject.execute }.to raise_error(Rigit::Exit)
        end
      end
    end

  end
end
