import asyncnet, asyncdispatch
import strutils
import os
import tables

type
  KV = TableRef[string, string]

var clients {.threadvar.}: seq[AsyncSocket]

proc processRequest(payload: string, kv: KV): string =
  let invalid_args = "Invalid arguments"
  let args = split(payload, " ") 
  if args.len < 2:
    result = invalid_args 
  else:
    let key = args[1]
    result = case args[0]:
      of "GET":
        kv.getOrDefault(key, "Not found")
      of "PUT":
        if args.len < 3:
          invalid_args
        else:
          kv[key] = args[2]
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
