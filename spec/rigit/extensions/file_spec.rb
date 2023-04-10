require 'spec_helper'

describe File do
  describe '::deep_write' do
    let(:dir) { 'spec/tmp/deep/folder' }
    let(:file) { "#{dir}/file.txt" }
    let(:content) { 'some content' }

    before do
      system "rm -rf #{dir}" if Dir.exist? dir
    end

    after do
      system "rm -rf #{dir}" if Dir.exist? dir
    end

    it 'writes to a file and creates directories as needed' do
      described_class.deep_write file, content
      expect(described_class).to exist file
      expect(described_class.read file).to eq content
    end
  end
end
