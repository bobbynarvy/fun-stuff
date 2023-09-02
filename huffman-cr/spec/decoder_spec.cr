require "./spec_helper"

describe Huffman::Encoder do
  it "encodes string" do
    map = Hash(String, Char).new
    map["10"] = 'a'
    map["11"] = 'b'
    map["0"] = 'c'
    bit_str = "10101111110000"
    decoder = Huffman::Decoder.new(map, bit_str)
    output = decoder.decode
    output.should eq("aabbbcccc")
  end
end
