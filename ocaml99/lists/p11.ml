type 'a rle = One of 'a | Many of int * 'a

let encode l =
  let create_rle count a = if count = 1 then One a else Many (count, a) in
  let rec encode2 l count acc =
    match l with
    | [] -> []
    | [ a ] -> acc @ [ create_rle (count + 1) a ]
    | a :: (b :: _ as tl) ->
        if a = b then encode2 tl (count + 1) acc
        else encode2 tl 0 (acc @ [ create_rle (count + 1) a ])
  in
  encode2 l 0 []
;;

assert (
  encode
    [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e" ]
  = [
      Many (4, "a");
      One "b";
      Many (2, "c");
      Many (2, "a");
      One "d";
      Many (4, "e");
    ])
