require 'spec_helper'

describe Commands::Build::Builder do
  let(:args) {{ 'RIG' => 'full', 'PARAMS' => [] }}
  subject { described_class.new args }

  describe '#execute' do
    context "without config" do
      let(:args) {{ 'RIG' => 'minimal', 'PARAMS' => [] }}
      
      it 'works'
    end
  end
end
