let rec private getNextPrime n acc =
    let n1 = n + 2L
    if (List.exists (fun x -> n1 % x = 0L) acc) then getNextPrime n1 acc
    else n1 :: acc

let rec getNPrimes n acc =
    if List.length acc = n then acc
    else
        match acc with
        | [] -> getNPrimes n (getNextPrime 3L [3L; 2L])
        | p :: rest -> getNPrimes n (getNextPrime p acc)

printfn "%i" (getNPrimes 10001 [] |> List.head)