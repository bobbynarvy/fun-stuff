import db_postgres
import os

# Main idea:
# Two threads, one creates a transaction and updates the value;
# another one tries to update it.
# The second one will be blocked because a lock holds the update in the first;
# it will only be able to update once the transaction is committed in first.

var threads: array[0..2, Thread[void]]

proc createDbConn(): DbConn =
  let
    host = getEnv("DB_HOST", "localhost")
    user = getEnv("DB_USER", "postgres")
    pass = getEnv("DB_PASS", "password")
    name = getEnv("DB_NAME", "postgres")
  db_postgres.open(host, user, pass, name)

proc selectBruce(db: DbConn): seq[Row] =
  db.getAllRows(sql"""SELECT * FROM users WHERE email = 'bruce@wayne.com' FOR UPDATE""")

proc thread1Proc () {.thread.} =
  let db = createDbConn()
  db.exec(sql"""BEGIN""")

  echo "Thread 1: starting transaction"
  echo "Thread 1: locking value", db.selectBruce
  echo "Thread 1: sleeping for 5 seconds"
  sleep(5000)

  db.exec(sql"""UPDATE users SET name = 'Brucy' WHERE email = 'bruce@wayne.com'""")
  echo "Thread 1: value updated", db.selectBruce
  db.exec(sql"""COMMIT""")

  echo "Thread 1: commited transaction"
  db.close()

proc thread2Proc () {.thread.} =
  let db = createDbConn()

  # sleep initially so that thread 1 goes first
  sleep(1000)

  echo "Thread 2: Trying to update user"
  db.exec(sql"""UPDATE users SET name = 'Bruce' WHERE email = 'bruce@wayne.com'""")
  echo "Thread 2: User updated"

  db.close()

let db = createDbConn()
db.exec(sql"""CREATE TABLE IF NOT EXISTS users (
  id SERIAL,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL UNIQUE
  )""")

db.exec(sql"""INSERT INTO users (name, email)
  VALUES ('Bruce Wayne', 'bruce@wayne.com')
  ON CONFLICT (email)
  DO NOTHING;
  """)

createThread(threads[0], thread1Proc)
createThread(threads[1], thread2Proc)

joinThreads(threads)

echo "Final value:", db.selectBruce
