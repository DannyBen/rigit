require 'spec_helper'

describe 'bin/rig' do
  context "without arguments" do
    it "shows usage"
  end

  describe 'build' do
    it "asks for input and builds a rig"

    context "when source rig does not exist" do
      it "exits with grace"
    end

    context "with an invalid rig config" do
      it "exits with grace"
    end

    context "with input is interrupted" do
      it "exits with grace"
    end
  end

end
