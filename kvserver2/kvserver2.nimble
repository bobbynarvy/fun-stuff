# Package

version       = "0.1.0"
author        = "Robert Narvaez"
description   = "A simple in-memore key-value store over a TCP server (and in Nim)."
license       = "MIT"
srcDir        = "src"
bin           = @["kvserver2"]


# Dependencies

requires "nim >= 1.4.8"
