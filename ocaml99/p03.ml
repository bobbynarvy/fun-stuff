let rec at k = function
  | [] -> None
  | h :: tl -> if k = 1 then Some h else at (k - 1) tl
;;

assert (at 3 [ "a"; "b"; "c"; "d"; "e" ] = Some "c");;

assert (at 3 [ "a" ] = None)
