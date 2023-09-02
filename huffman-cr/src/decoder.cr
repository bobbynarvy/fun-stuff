module Huffman
  # A very simplistic decoder of encoded data
  class Decoder
    @mapping : Hash(String, Char)
    @bit_str : String

    def initialize(@mapping, @bit_str)
    end

    def decode
      output = ""
      start = 0
      # TODO: What if the a bit pattern from the bit string
      # does not exist in the mapping?
      while start < @bit_str.size
        @mapping.each do |bits, char|
          if bits.size > @bit_str.size - start
            next
          end

          sub = @bit_str[start, bits.size]
          if sub == bits
            output += char
            start = start + bits.size
            next
          end
        end
      end
      output
    end
  end
end
