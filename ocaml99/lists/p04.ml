let length l =
  let rec length2 l acc =
    match l with _ :: t -> length2 t (acc + 1) | [] -> acc
  in
  length2 l 0
;;

assert (length [ "a"; "b"; "c" ] = 3);;

assert (length [] = 0)
