import coder
import os
import sequtils
import strutils
import unicode

# Note: this is probably incorrect.
# Need to read up on character encodings
proc compressFile(filepath: string) =
  let content = readFile(filepath)
  let (encoded, encodings) = encode(content)
  # first line is the encoding table
  # the chars are stored in hex
  let table = encodings.map(proc(e: Encoding): string = ($e[0]).toRunes[0].int.toHex(5) & "," & e[1]).join("|")
  let file = open(extractFilename(filepath) & ".huff", fmWrite)

  file.writeLine(table)
  file.writeLine(encoded)
  file.close()
