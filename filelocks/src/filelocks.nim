import os
import strformat
import strutils

# This small program aims to demonstrate how to make use of
# file locks, in particular the `flock` function in C.
#
# The program creates 10 threads, each one trying to acquire an exclusive lock
# for a file that is initialized with 0. Once acquired, each thread 
# adds 100 to the value in the file and writes the new value into the file.
# The final value in the file should be 1000.

var threads: array[0..9, Thread[string]]

# import flock through Nim's FFI.
# more at https://linux.die.net/man/2/flock
let LOCK_EX {.header: "<sys/file.h>", importc: "LOCK_EX".}: int
let LOCK_UN {.header: "<sys/file.h>", importc: "LOCK_UN".}: int

# The following ones are declared but not used.
# Only used for reference.
# LOCK_SH stands for shared lock
let LOCK_SH {.header: "<sys/file.h>", importc: "LOCK_SH".}: int
# LOCK_NB is meant to be used with other locks so that the locking
# operation is non-blocking/exits immediately with success or error.
# Can be with bitor in the bitops module like:
#   flock(fd, bitor(LOCK_EX, LOCK_NB))
let LOCK_NB {.header: "<sys/file.h>", importc: "LOCK_NB".}: int

proc flock(fd: int, mode: int): int {.header: "<sys/file.h>", importc: "flock".}

proc threadFunc(index: string) {.thread.} =
  # try to get an exclusive lock;
  # get an independent file descriptor so that the lock
  # isn't shared among threads
  let file = open("lockfile", fmReadWriteExisting)
  let fd = getFileHandle(file)
  if flock(fd, LOCK_EX) == -1:
    raise newException(OSError, "Acquisition of lock failed.")

  # read the content of the file
  echo fmt"Opening file on thread {index}"
  let line = file.readLine
  let val = parseInt(line)

  # increment it by 100
  file.setFilePos(0)
  let newVal = val + 100
  echo fmt"Writing new value of file: {newVal}"
  file.write($newVal)
  file.flushFile

  # release the lock
  if flock(fd, LOCK_UN) == -1:
    raise newException(OSError, "Releasing of lock failed.")

let filename = "lockfile"
let file = open(filename, fmWrite)
file.write("0")
file.flushFile

for i in 0..high(threads):
  createThread(threads[i], threadFunc, $i)

joinThreads(threads)

removeFile(filename)
