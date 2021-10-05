import db_postgres
import strformat
import os

# Main idea:
# Two worker threads try to update a database row.
# Each one can take a row and lock it (through FOR UPDATE)
# and at the same time not be blocked by selecting rows
# that are not locked (through SKIP LOCKED)

var threads: array[0..2, Thread[int]]

proc createDbConn(): DbConn =
  let
    host = getEnv("DB_HOST", "localhost")
    user = getEnv("DB_USER", "postgres")
    pass = getEnv("DB_PASS", "password")
    name = getEnv("DB_NAME", "postgres")
  db_postgres.open(host, user, pass, name)

proc workerThread (i: int) {.thread.} =
  let db = createDbConn()
  db.exec(sql"BEGIN")

  let row = db.getRow(sql"""SELECT * FROM jobs 
          WHERE worker_id IS NULL
          LIMIT 1 
          FOR UPDATE 
          SKIP LOCKED""")
  let rowId = row[0]

  if rowId != "":
    echo fmt"Thread {i}: Locking row with id {rowId} and sleeping for 500 ms"
    sleep(500)

    echo fmt"Thread {i}: Updating row with id {rowId}"
    db.exec(sql"""UPDATE jobs SET worker_id = ?
            WHERE id = ?
            """, i, rowId)
    db.exec(sql"COMMIT")
    db.close

    workerThread(i)

let db = createDbConn()
db.exec(sql"""DROP TABLE IF EXISTS jobs""")
db.exec(sql"""CREATE TABLE IF NOT EXISTS jobs (
  id SERIAL,
  worker_id VARCHAR(50)
  )""")

db.exec(sql"""INSERT INTO jobs 
  SELECT * 
  FROM generate_series(1, 10)
  """)

createThread(threads[0], workerThread, 0)
createThread(threads[1], workerThread, 1)

joinThreads(threads)

echo "Final rows:"
for row in db.getAllRows(sql"SELECT * FROM jobs"):
  echo row

db.close
