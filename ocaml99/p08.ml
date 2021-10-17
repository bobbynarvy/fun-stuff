let rec compress = function
  | a :: (b :: _ as tl) -> if a = b then compress tl else a :: compress tl
  | l -> l
;;

assert (
  compress
    [ "a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e" ]
  = [ "a"; "b"; "c"; "a"; "d"; "e" ])
