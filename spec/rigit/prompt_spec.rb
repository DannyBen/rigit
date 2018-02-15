require 'spec_helper'

describe Prompt do
  subject { described_class.new params }

  describe '#get_input' do
    let(:params) { Config.load('spec/fixtures/prompt.yml').params }

    it 'asks the user for input' do
      stdin_send('hello', 'y', "\n") do 
        expect{ @result = subject.get_input }.to output(/Name your project.*Include RSpec files.*Select console/m).to_stdout
        expect(@result).to eq({ name: "hello", spec: "yes", console: "irb" })
      end
    end

    context "with invalid type", :focus do
      let(:params) { Config.load('spec/fixtures/prompt-invalid.yml').params }

      it "raises ConfigError" do
        expect{ subject.get_input }.to raise_error(Rigit::ConfigError)
      end
    end
  end
end
