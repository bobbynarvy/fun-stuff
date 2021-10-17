let rev l =
  let rec rev2 l acc =
    match l with h :: tl -> rev2 tl (h :: acc) | [] -> acc
  in
  rev2 l []
;;

assert (rev [ "a"; "b"; "c" ] = [ "c"; "b"; "a" ])
