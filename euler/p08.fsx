let rec findTriplets a b =
    let c = a * a + b * b |> float |> sqrt
    let isPerfectSquare = if floor c = ceil c then Some c else None

    let triplets = 
        match isPerfectSquare with
        | Some c -> Some (a, b, (int c))
        | None -> None
    
    match triplets with
    | Some (a, b, c) -> a, b, c
    | None -> findTriplets a (b + 1)

let rec find1000Triplet a =
    let _, b, c = findTriplets a 3

    if (a + b + c) = 1000 then a * b * c
    else find1000Triplet (a + 1)

printfn "%A" (find1000Triplet 3)