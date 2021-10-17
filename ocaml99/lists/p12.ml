type 'a rle = One of 'a | Many of int * 'a

let decode l =
  let rec create_many a count acc =
    match count with 0 -> acc | c -> create_many a (c - 1) (a :: acc)
  in
  let rec decode2 l acc =
    match l with
    | One a :: tl -> decode2 tl (a :: acc)
    | Many (count, a) :: tl -> decode2 tl (create_many a count [] @ acc)
    | [] -> acc
  in
  decode2 l [] |> List.rev
;;

assert (
  decode
    [
      Many (4, "a");
      One "b";
      Many (2, "c");
      Many (2, "a");
      One "d";
      Many (4, "e");
    ]
  = [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e" ])
