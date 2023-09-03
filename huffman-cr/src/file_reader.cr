module Huffman
  class FileReader
    def initialize(@path = "")
      if path.empty?
        raise "Path is not valid"
      end

      @map = Hash(String, Char).new
      @bit_str = ""
      @padding = 0_u8
    end

    def read
      File.open(@path, "rb") do |file|
        read_header(file)
        read_bit_str(file)
        {@map, @bit_str}
      end
    end

    private def read_header(file)
      num_chars = file.read_byte
      return if num_chars.nil?

      padding = file.read_byte
      if padding.nil?
        raise "Padding data not available"
      end
      @padding = padding

      while num_chars != 0
        utf8_offset = file.read_byte
        if utf8_offset.nil?
          raise "Could not read character"
        end

        char = '\u0000' + utf8_offset
        bit_str = ""
        while true
          case file.read_byte
          when 0x31
            bit_str += "1"
          when 0x30
            bit_str += "0"
          else
            break
          end
        end
        @map[bit_str] = char
        num_chars -= 1
      end
    end

    private def read_bit_str(file)
      while true
        byte = file.read_byte
        if byte.nil?
          break
        end

        (0..7).each do |i|
          mask = 1 << 7 - i
          if byte & mask != 0
            @bit_str += "1"
          else
            @bit_str += "0"
          end
        end
      end

      # trucate the padded bits
      @bit_str = @bit_str[0, @bit_str.size - @padding]
    end
  end
end
