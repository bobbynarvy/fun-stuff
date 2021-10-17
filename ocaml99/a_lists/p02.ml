let rec last_two = function
  | [ x; y ] -> Some (x, y)
  | [ _ ] | [] -> None
  | _ :: t -> last_two t
;;

assert (last_two [ "a"; "b"; "c"; "d" ] = Some ("c", "d"));;

assert (last_two [ "a" ] = None)
