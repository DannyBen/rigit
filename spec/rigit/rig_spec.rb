require 'spec_helper'

describe Rig do
  subject { described_class.new 'minimal' }

  describe '::home' do
    context 'when RIG_HOME is not set' do
      it 'returns ~/.rigs' do
        without_env 'RIG_HOME' do
          expect(described_class.home).to eq "#{Dir.home}/.rigs"
        end
      end
    end

    context 'when RIG_HOME is set' do
      it 'returns RIG_HOME' do
        with_env 'RIG_HOME', 'some/path' do
          expect(described_class.home).to eq 'some/path'
        end
      end
    end
  end

  describe '::home=' do
    it 'sets Rig.home' do
      without_env 'RIG_HOME' do
        described_class.home = 'some/new/path'
        expect(described_class.home).to eq 'some/new/path'
      end
    end
  end

  describe '::create' do
    before { system "rm -rf #{described_class.home}/created_rig" if Dir.exist? "#{described_class.home}/created_rig" }

    it 'creates a new rig template' do
      expect(Dir).not_to exist("#{described_class.home}/created_rig")

      described_class.create 'created_rig'

      expect(File).to exist("#{described_class.home}/created_rig/config.yml")
      expect(Dir).to exist("#{described_class.home}/created_rig/base")
    end
  end

  describe '#scaffold' do
    let(:workdir) { 'spec/tmp' }

    before { reset_workdir }

    context 'with minimal example and no config' do
      it 'copies all files and folders' do
        Dir.chdir workdir do
          subject.scaffold
          expect(ls).to match_approval 'ls/minimal'
        end
      end
    end

    context 'with full example' do
      subject { described_class.new 'full' }

      let(:arguments) { { name: 'myapp', license: 'MIT', spec: 'yes', console: 'irb' } }

      it 'copies all files and folders' do
        Dir.chdir workdir do
          subject.scaffold arguments: arguments
          expect(ls).to match_approval 'ls/full'
        end
      end

      it 'replaces string tokens in all files' do
        Dir.chdir workdir do
          subject.scaffold arguments: arguments
          files = Dir['**/*.*']
          expect(files.count).to eq 7

          files.each do |file|
            fixture_name = "content/#{File.basename(file)}"
            expect(File.read file).to match_approval(fixture_name)
          end
        end
      end
    end

    context 'with templates that contain errors' do
      subject { described_class.new 'template-error' }

      let(:arguments) { { name: 'myapp' } }

      it 'raises TemplateError' do
        Dir.chdir workdir do
          expect { subject.scaffold }.to raise_error(TemplateError, 'malformed format string - %Q')
        end
      end
    end

    context 'with filenames that contain errors' do
      subject { described_class.new 'filename-error' }

      let(:arguments) { { name: 'myapp' } }

      it 'raises TemplateError' do
        Dir.chdir workdir do
          expect { subject.scaffold }.to raise_error(TemplateError, 'key{no-such-key} not found')
        end
      end
    end

    context 'with rigs that contain binary files' do
      subject { described_class.new 'binary' }

      it 'copies the binaries as is without evaluatin garguments' do
        Dir.chdir workdir do
          subject.scaffold
          expect(ls).to match_approval 'ls/binary'
          expect(File.size 'sample-logo.png').to be > 29_000
        end
      end
    end
  end

  describe '#path' do
    it 'returns full rig path' do
      expect(subject.path).to eq "#{described_class.home}/#{subject.name}"
    end
  end

  describe '#exist?' do
    context 'when the rig path exists' do
      it 'returns true' do
        expect(subject).to exist
      end
    end

    context 'when the rig path does not exist' do
      subject { described_class.new 'no-such-rig' }

      it 'returns false' do
        expect(subject).not_to exist
      end
    end
  end

  describe '#has_config?' do
    context 'when the rig has a config file' do
      subject { described_class.new 'full' }

      it 'returns true' do
        expect(subject).to have_config
      end
    end

    context 'when the rig does not have a config file' do
      it 'returns false' do
        expect(subject).not_to have_config
      end
    end
  end

  describe '#config_file' do
    it 'returns path to config file' do
      expect(subject.config_file).to eq "#{subject.path}/config.yml"
    end
  end

  describe '#config' do
    subject { described_class.new 'full' }

    it 'returns the config object' do
      expect(subject.config.intro).to eq 'If you y`rig` it, g`they will come`'
    end
  end

  describe '#info' do
    it 'returns a hash with meta data' do
      expect(subject.info).to be_a Hash
      expect(subject.info[:name]).to eq 'minimal'
    end

    context 'when the rig has a config file' do
      subject { described_class.new 'full' }

      it 'returns the config yaml in the config key' do
        expect(subject.info[:config]).to match_approval('info-config.yml')
      end
    end
  end
end
