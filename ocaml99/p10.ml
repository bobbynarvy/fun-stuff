let encode l =
  let rec encode2 l count acc =
    match l with
    | [] -> []
    | [ a ] -> acc @ [ (count + 1, a) ]
    | a :: (b :: _ as tl) ->
        if a = b then encode2 tl (count + 1) acc
        else encode2 tl 0 (acc @ [ (count + 1, a) ])
  in
  encode2 l 0 []
;;

assert (
  encode
    [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e" ]
  = [ (4, "a"); (1, "b"); (2, "c"); (2, "a"); (1, "d"); (4, "e") ])
