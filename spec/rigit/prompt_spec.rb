require 'spec_helper'

describe Prompt do
  subject { described_class.new params }

  describe '#get_input' do
    let(:params) { Config.load('spec/fixtures/prompt/normal.yml').params }

    it 'asks the user for input' do
      stdin_send('hello', 'y', "\n") do 
        expect{ @result = subject.get_input }.to output(/Name your project.*Include RSpec files.*Select console/m).to_stdout
        expect(@result).to eq({ name: "hello", spec: "yes", console: "irb" })
      end
    end

    context "with invalid type" do
      let(:params) { Config.load('spec/fixtures/prompt/invalid.yml').params }

      it "raises ConfigError" do
        expect{ subject.get_input }.to raise_error(Rigit::ConfigError)
      end
    end

    context "with a conditional param" do
      let(:params) { Config.load('spec/fixtures/prompt/conditional.yml').params }

      context "when the condition is met" do
        it "asks for input" do
          stdin_send('y', 'mybin') do 
            expect{ @result = subject.get_input }.to output(/Include bin?.*Yes.*Name of the bin file:.*mybin/m).to_stdout
            expect(@result).to eq({ bin: "yes", binfile: "mybin" })
          end
        end
      end

      context "when the condition is not met" do
        it "does not ask for input" do
          stdin_send('n') do 
            expect{ @result = subject.get_input }.to output(/Include bin?.*no/).to_stdout
            expect(@result).to eq({ bin: "no" })
          end
        end        
      end
    end
  end
end
