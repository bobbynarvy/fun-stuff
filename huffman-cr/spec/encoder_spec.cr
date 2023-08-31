require "./spec_helper"

describe Huffman::Encoder do
  it "encodes string" do
    encoder = Huffman::Encoder.new("aabbbcccc")
    enc_map, bit_string = encoder.encode
    enc_map['a'].should eq("10")
    enc_map['b'].should eq("11")
    enc_map['c'].should eq("0")
    bit_string.should eq("10101111110000")
  end
end
