let replicate l count =
  let rec rep a count acc =
    match count with 0 -> acc | c -> rep a (count - 1) (a :: acc)
  in
  let rec repl l acc =
    match l with h :: tl -> repl tl (acc @ rep h count []) | [] -> acc
  in
  repl l []
;;

assert (
  replicate [ "a"; "b"; "c" ] 3
  = [ "a"; "a"; "a"; "b"; "b"; "b"; "c"; "c"; "c" ])
