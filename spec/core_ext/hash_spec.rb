require 'spec_helper'

describe Hash do
  describe "#symbolize_keys_deep!" do
    it "symbolizes recusively" do
      hash = { "a" => 1, "b" => { "c" => 2, "d" => 3 } }
      hash.symbolize_keys_deep!
      expect(hash.fetch(:a)).to eq(1)
      expect(hash.fetch(:b)).to eq({ :c => 2, :d => 3 })
    end
  end
end
