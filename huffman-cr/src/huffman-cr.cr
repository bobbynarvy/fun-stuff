require "./decoder"
require "./encoder"
require "./file_reader"
require "./file_writer"

module Huffman::Cr
  begin
    unless ARGV[0]?
      raise "Arguments not present."
    end

    command = ARGV[0]
    unless ["encode", "decode"].includes?(command)
      raise "Invalid command. Expected 'encode' or 'decode'."
    end

    unless ARGV[1]?
      raise "Path to file is not present"
    end

    path = ARGV[1]
    if command == "encode"
      encoder = Encoder.new(File.read(path))
      result = encoder.encode
      writer = FileWriter.new(result)
      if ARGV[2]?
        writer.write(ARGV[2])
      else
        writer.write
      end
    else
      reader = FileReader.new(path)
      map, bit_str = reader.read
      decoder = Decoder.new(map, bit_str)
      output = decoder.decode
      if ARGV[2]?
        File.write(ARGV[2], output)
      else
        puts output
      end
    end
    puts "Success."
  rescue ex
    puts ex.message
  end
end
