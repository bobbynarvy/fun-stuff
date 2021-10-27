let main () = Lwt_io.write_line Lwt_io.stdout "hello world"

let () =
  Lwt_main.run (main ())
