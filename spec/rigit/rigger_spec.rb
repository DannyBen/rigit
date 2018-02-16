require 'spec_helper'

describe Rigger do

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
      subject { described_class.new 'full', arguments }

      it 'copies all files and folders', :focus do
        Dir.chdir workdir do
          subject.scaffold
          expect(ls).to match_fixture 'ls/full'
        end
      end

      it 'replaces string tokens in all files' do
        Dir.chdir workdir do
          subject.scaffold
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
end
