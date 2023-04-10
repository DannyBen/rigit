require 'spec_helper'

describe Config do
  describe '::load' do
    it 'loads a config yaml file' do
      config = Config.load 'spec/fixtures/config.yml'
      expect(config.hello).to eq 'world'
    end

    context 'when config file is not found' do
      it 'returns an empty config object' do
        config = Config.load 'no-such-config.yml'
        expect(config.has_key? :hello).to be false
      end
    end
  end
end
