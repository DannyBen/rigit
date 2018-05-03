require 'spec_helper'

describe Commands::Build::BuildHandler do
  let(:args) {{ 'RIG' => 'full', 'PARAMS' => [] }}
  subject { described_class.new args }

  describe '#execute' do
    let(:workdir) { 'spec/tmp' }
    before { reset_workdir }

    context "without config" do
      let(:args) {{ 'RIG' => 'minimal', 'PARAMS' => [] }}
      
      it 'copies the files without complaining' do
        Dir.chdir workdir do
          supress_output { subject.execute }
          expect(ls).to match_fixture 'ls/minimal'
        end
      end
    end

    context "with full example" do
      let(:args) {{ 'RIG' => 'full', 'PARAMS' => [] }}

      it "asks for user input and copies the files" do
        Dir.chdir workdir do
          stdin_send('hello', 'n', 'n') do 
            expect{ subject.execute }.to output(/Name your project.*Include RSpec files.*Select console/m).to_stdout
          end
          expect(ls).to match_fixture 'ls/full2'
        end
      end
    end

    context "when params are provided in the command" do
      let(:args) {{ 'RIG' => 'full', 'PARAMS' => %w[name=hello spec=no console=irb license=MIT] }}

      it "does not ask for user input and copies the files" do
        Dir.chdir workdir do
          expect{ subject.execute }.to output_fixture('cli/build-full')
          expect(ls).to match_fixture 'ls/full2'
        end
      end
    end

    context "when the config includes before/after actions" do
      let(:args) {{ 'RIG' => 'actions', 'PARAMS' => %w[name=hello] }}

      it "executes the commands" do
        Dir.chdir workdir do
          expect{ subject.execute }.to output_fixture('cli/build-actions')
          expect(ls).to match_fixture 'ls/actions'
        end
      end      
    end

    context "when the target dir is not empty" do
      let(:args) {{ 'RIG' => 'minimal', 'PARAMS' => [] }}
      before { File.deep_write "#{workdir}/lonely-file", 'anything' }

      it "asks if the user wants to continue" do
        Dir.chdir workdir do
          supress_output do
            stdin_send('') do 
              expect{ subject.execute }.to raise_error(Rigit::Exit)
            end
          end
          expect(ls).to match_fixture 'ls/not-empty'
        end
      end

      context "when the user answers Abort" do
        it "raises an error" do
          Dir.chdir workdir do
            supress_output do
              stdin_send('') do 
                expect{ subject.execute }.to raise_error(Rigit::Exit)
              end
            end
            expect(ls).to match_fixture 'ls/not-empty'
          end
        end
      end

      context "when the user answers Continue" do
        it "copies the files" do
          Dir.chdir workdir do
            stdin_send(down_arrow) do 
              expect{ subject.execute }.to output(/Building.*minimal.*Continue here.*Done/m).to_stdout
            end
            expect(ls).to match_fixture 'ls/not-empty-after'
          end
        end
      end

      context "when the user answers Create" do
        it "creates a subfolder and copies the files" do
          Dir.chdir workdir do
            stdin_send("#{down_arrow}#{down_arrow}", "new_dir") do 
              expect{ subject.execute }.to output(/Building.*minimal.*Continue in a sub directory.*Creating in \.\/new_dir.*Done/m).to_stdout
            end
            expect(ls).to match_fixture 'ls/subdir-build'
          end
        end
      end

    end

    context "when files with the same name exist" do
      let(:args) {{ 'RIG' => 'minimal', 'PARAMS' => [] }}
      before { File.deep_write "#{workdir}/some-file.txt", 'OLD CONTENT' }

      it "asks if the user wants to ovrewrite" do
        Dir.chdir workdir do
          stdin_send(down_arrow, 'n') do
            expect{ subject.execute }.to output(/File.*\.\/some-file.txt.*already exists.\n\s*Overwrite\?.*skip/m).to_stdout
          end
        end
      end

      context "when --force is provided" do
        let(:args) {{ 'RIG' => 'minimal', '--force' => true, 'PARAMS' => [] }}

        it "does not ask if the user wants to overwrite" do
          Dir.chdir workdir do
            stdin_send(down_arrow) do
              expect{ subject.execute }.not_to output(/Overwrite/).to_stdout
            end
          end
        end
      end

      context "when the user answers no" do
        it "keeps the old content" do
          Dir.chdir workdir do
            stdin_send(down_arrow, 'n') do
              expect{ subject.execute }.to output(/File.*\.\/some-file.txt.*already exists.\n\s*Overwrite\?.*skip/m).to_stdout
            end
            expect(File.read 'some-file.txt').to eq 'OLD CONTENT'
          end
        end
      end

      context "when the user answers yes" do
        it "copies the file content" do
          Dir.chdir workdir do
            stdin_send(down_arrow, 'y') do
              expect{ subject.execute }.to output(/File.*\.\/some-file.txt.*already exists.\n\s*Overwrite\?.*overwrite/m).to_stdout
            end
            expect(File.read 'some-file.txt').to eq 'static content'
          end
        end
      end

      context "when the user answers skip all" do
        it "keeps the old content" do
          Dir.chdir workdir do
            stdin_send(down_arrow, 's') do
              expect{ subject.execute }.to output(/File.*\.\/some-file.txt.*already exists.\n\s*Overwrite\?.*skip all/m).to_stdout
            end
            expect(File.read 'some-file.txt').to eq 'OLD CONTENT'
          end
        end
      end

      context "when the user answers overwrite all" do
        it "copies the file content" do
          Dir.chdir workdir do
            stdin_send(down_arrow, 'a') do
              expect{ subject.execute }.to output(/File.*\.\/some-file.txt.*already exists.\n\s*Overwrite\?.*overwrite all/m).to_stdout
            end
            expect(File.read 'some-file.txt').to eq 'static content'
          end
        end
      end

    end

    context "when the source dir does not exist" do
      let(:args) {{ 'RIG' => 'no-such-rig', 'PARAMS' => [] }}

      it "raises an error" do
        supress_output do
          expect{ subject.execute }.to raise_error(Rigit::Exit)
        end
      end
    end
  end
end
