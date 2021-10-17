type 'a node = One of 'a | Many of 'a node list

let flatten l =
  let rec flatten2 l acc =
    match l with
    | One a :: tl -> flatten2 tl (acc @ [ a ])
    | Many l2 :: tl -> flatten2 tl (flatten2 l2 acc)
    | [] -> acc
  in
  flatten2 l []
;;

assert (
  flatten [ One "a"; Many [ One "b"; Many [ One "c"; One "d" ]; One "e" ] ]
  = [ "a"; "b"; "c"; "d"; "e" ])
