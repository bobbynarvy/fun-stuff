require "bit_array"

module Huffman
  class FileWriter
    @enc_map : Hash(Char, String)
    @bit_str : String

    def initialize(encoded : {Hash(Char, String), String})
      @enc_map = encoded[0]
      @bit_str = encoded[1]
      @padding = 0_u8
    end

    def write(path = "")
      if path.empty?
        path = "./encoded.huff"
      end

      # add padding as trailing zeros to bit string
      @padding = 8_u8 - (@bit_str.size % 8_u8)
      @bit_str = @bit_str + (0...@padding).map { '0' }.join
      File.write(path, Slice.join([header, data]), mode: "wb")
    end

    # A slice of bytes containing the encoding mapping
    # of the encoded data. The structure is as follows:
    # Number of ASCII characters - 1 byte
    # Padding size of the encoded data - 1 byte
    # For each character:
    #   utf-8 character - 1 bytes
    #   encoded bit string
    #   0 to denote end of the bit string
    private def header
      num_chars = @enc_map.size.to_u8 # chars are limited to ASCII (128 chars)
      bytes = [num_chars, @padding] of UInt8
      @enc_map.each do |c, bs|
        bytes.concat(c.bytes)
        bytes.concat(bs.bytes)
        bytes.push(0)
      end
      Slice(UInt8).new(bytes.size) { |i| bytes[i] }
    end

    # A slice of bytes containing the bit string data converted
    # to bits and packed as bytes
    private def data
      byte_slice = Slice(UInt8).new(@bit_str.size // 8)
      byte_slice_i = 0
      byte = 0_u8
      @bit_str.each_char_with_index do |c, i|
        shift = 7 - i % 8
        if c == '1'
          byte = byte | (1 << shift)
        end

        if shift == 0
          byte_slice[byte_slice_i] = byte
          byte_slice_i += 1
          byte = 0_u8
        end
      end
      byte_slice
    end
  end
end
