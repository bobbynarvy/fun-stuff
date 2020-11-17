let rec private count chars sum =
    match chars with
    | [] -> sum
    | char :: rest ->
        match char with
        | char when char = 'G' || char = 'C' -> count rest (sum + 1)
        | _ -> count rest sum

let gc str =
    let chars = Seq.toList str |> List.filter (fun x -> x <> '\n')
    let length = List.length chars |> float
    (count chars 0 |> float) / length * 100.0

printf "%A" (gc "AGCTATAG") 