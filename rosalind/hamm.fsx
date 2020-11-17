let rec countDist charPairs sum =
    match charPairs with
    | [] -> sum
    | pair :: rest ->
        match pair with
        | (s, t) when s <> t -> countDist rest (sum + 1)
        | _ -> countDist rest sum

let hamm str1 str2 =
    let l1, l2 = Seq.toList str1, Seq.toList str2
    let charPairs = List.zip l1 l2
    countDist charPairs 0

printf "%A" (hamm "GAGCCTACTAACGGGAT" "CATCGTAATGACGGCCT") 