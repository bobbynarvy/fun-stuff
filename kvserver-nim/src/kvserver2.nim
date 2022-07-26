import asyncnet, asyncdispatch
import strutils
import options
import os
import tables

type
  KV = TableRef[string, string]

var clients {.threadvar.}: seq[AsyncSocket]

proc getArg(args: seq[string], i: int): Option[string] = 
  try:
    result = some(args[i])
  except:
    result = none(string)

proc processRequest(payload: string, kv: KV): string =
  let invalid_args = "Invalid arguments"
  let args = split(payload, " ") 
  let command = getArg(args, 0)
  if command.isNone:
    return invalid_args
  
  let key = getArg(args, 1)
  if key.isNone:
    return invalid_args

  case command.get:
    of "GET":
      kv.getOrDefault(key.get, "Not found")
    of "PUT":
      let val = getArg(args, 2)
      if val.isNone:
        return invalid_args

      kv[key.get] = val.get
      "OK"
    else:
      invalid_args
  
proc processClient(client: AsyncSocket, kv: KV) {.async.} =
  while true:
    let line = await client.recvLine()
    if line.len == 0: break

    for c in clients:
      await c.send(processRequest(line, kv) & "\c\L")

proc serve() {.async.} =
  clients = @[]
  var server = newAsyncSocket()
  let port = getEnv("PORT", "8080")
  let kv: KV = newTable[string, string]()

  server.setSockOpt(OptReuseAddr, true)
  server.bindAddr(Port(parseInt(port)))
  server.listen()

  while true:
    let client = await server.accept()
    clients.add client

    asyncCheck processClient(client, kv)

when isMainModule:
  echo("Accepting connections.")
  asyncCheck serve()
  runForever()
