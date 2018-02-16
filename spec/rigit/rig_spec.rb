require 'spec_helper'

describe Rig do

  describe '::home' do
    context 'when RIG_HOME is not set' do
      it 'returns ~/.rigs'
    end

    context 'when RIG_HOME is set' do
      it 'returns RIG_HOME' 
    end
  end

  describe '::home=' do
    it 'sets RIG_HOME'
  end

  describe '#scaffold' do
    let(:workdir) { 'spec/tmp' }
    before { reset_workdir }

    context 'with minimal example and no config' do
      subject { described_class.new 'minimal'}

      it 'copies all files and folders' do
        Dir.chdir workdir do
          subject.scaffold
          expect(ls).to match_fixture 'ls/minimal'
        end
      end
    end

    context 'with full example' do
      let(:arguments) {{ name: 'myapp', license: 'MIT', spec: 'y', console: 'irb' }}
      subject { described_class.new 'full' }

      it 'copies all files and folders', :focus do
        Dir.chdir workdir do
          subject.scaffold arguments: arguments
          expect(ls).to match_fixture 'ls/full'
        end
      end

      it 'replaces string tokens in all files' do
        Dir.chdir workdir do
          subject.scaffold arguments: arguments
          files = Dir['**/*.*']
          expect(files.count).to eq 6
          
          files.each do |file|
            fixture_name = "content/#{File.basename(file)}"
            expect(File.read file).to match_fixture(fixture_name)
          end
        end
      end
    end
  end

  describe '#path' do
    it 'returns full rig path'
  end

  describe '#exist?' do
    context 'when the rig path exists' do
      it 'returns true'
    end

    context 'when the rig path does not exist' do
      it 'returns false'
    end
  end

  describe '#config_file' do
    it 'returns path to config file'    
  end

  describe '#config' do
    it 'returns the config object'
  end
end
