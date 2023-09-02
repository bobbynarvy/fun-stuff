module Huffman
  class Encoder
    class Node
      @char : Char?

      property left : Node?
      property right : Node?
      getter freq : UInt32

      def initialize(@char : Char, @freq)
      end

      def initialize(@left, @right)
        @freq = left.freq + right.freq
      end

      def get_code(map, bit_str = "")
        left = @left
        right = @right
        char = @char

        unless left.nil?
          left.get_code(map, bit_str + "0")
        end
        unless right.nil?
          right.get_code(map, bit_str + "1")
        end

        unless char.nil?
          map[char] = bit_str
        end
      end
    end

    @src : String

    def initialize(@src)
      @count_map = Hash(Char, UInt32).new(0)
    end

    def encode
      check_ascii
      calc_freqs
      root = create_root_node
      enc_map = Hash(Char, String).new
      root.get_code(enc_map, "")
      bit_string = @src.chars.map { |c| enc_map[c] }.join
      {enc_map, bit_string}
    end

    # Checks if the characters in the source data are ASCII.
    # Character set is limited to ASCII for simplification purposes.
    private def check_ascii
      @src.each_char do |char|
        unless char.ascii?
          raise "Non-ASCII characters are not permitted."
        end
      end
    end

    private def calc_freqs
      @src.each_char do |char|
        @count_map.update(char) { |freq| freq + 1 }
      end
    end

    private def create_root_node
      nodes = @count_map.map { |k, v| Node.new(k, v) }
      while nodes.size != 1
        nodes = nodes.sort { |a, b| a.freq <=> b.freq }
        nodes.push(Node.new(nodes.shift, nodes.shift))
      end
      nodes.pop
    end
  end
end
