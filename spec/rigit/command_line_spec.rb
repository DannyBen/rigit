require 'spec_helper'

describe CommandLine do
  context "without arguments" do
    it "shows usage" do
      expect{ described_class.execute }.to output_fixture 'cli/usage'
    end
  end

  describe 'build' do
    it 'works (...and has additional tests)'
  end
end