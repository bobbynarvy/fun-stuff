open Lwt.Infix

(* Playing with Lwt to say hello world *)
let () =
  Lwt_main.run
    (let p1, r1 = Lwt.wait () in
     let p2, r2 = Lwt.wait () in
     Lwt.wakeup_later r1 "Hello" ;
     Lwt.wakeup_later r2 "world!" ;
     Lwt.all [p1; p2]
     >|= (fun p -> String.concat " " p)
     >>= fun x -> Lwt_io.printl x )
