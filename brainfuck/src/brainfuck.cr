module Brainfuck
  class VM
    @ip : Int32
    @dp : UInt16
    @cells : Array(UInt8)
    @src : String

    def initialize(@src)
      @ip = 0
      @dp = 0
      @cells = Array(UInt8).new(30_000, 0)
      @bracemap = Hash(Int32, Int32).new

      create_bracemap
    end

    def run
      while @ip < @src.size
        interpret
      end
    end

    private def interpret
      case instruction
      when '>'
        @dp += 1
      when '<'
        @dp -= 1
      when '+'
        @cells[@dp] += 1
      when '-'
        @cells[@dp] -= 1
      when '.'
        # I don't know yet how to convert bytes to chars :P
        puts '\u0000' + byte
      when ','
        @cells[@dp] = get_user_byte
      end

      case
      when instruction == '[' && byte == 0
        @ip = @bracemap[@ip]
      when instruction == ']' && byte != 0
        @ip = @bracemap[@ip]
      end

      @ip += 1
    end

    private def byte
      @cells[@dp]
    end

    private def instruction
      @src[@ip]
    end

    private def create_bracemap
      stack = Array(Int32).new
      @src.each_char_with_index do |char, index|
        case char
        when '['
          stack.push(index)
        when ']'
          start = stack.pop
          @bracemap[start] = index
          @bracemap[index] = start
        end
      end
    end

    private def get_user_byte : UInt8
      puts "Please enter a number between 0 and 255"
      input = gets
      if input.nil? || input == ""
        return 0_u8
      end

      num = input.to_u32
      if num > 255
        puts "Invalid input."
        return get_user_byte
      end

      return num.to_u8
    end
  end

  if ARGV.empty?
    puts "No path provided."
  else
    file_contents = ARGF.gets_to_end
    vm = VM.new file_contents
    vm.run
  end
end
