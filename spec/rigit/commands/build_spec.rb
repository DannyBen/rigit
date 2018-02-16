require 'spec_helper'

describe Commands::Build do
  describe '::load' do
    it 'loads a config yaml file' do
      config = Config.load 'spec/fixtures/config.yml'
      expect(config.hello).to eq 'world'
    end
  end
end
