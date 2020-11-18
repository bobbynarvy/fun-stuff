let rec private findSubs s t p acc =
    match s with
    | "" -> acc
    | _ ->
        match s.[0..((Seq.length t) - 1)] with
        | sSub when sSub = t -> findSubs s.[1..] t (p + 1) (p :: acc)
        | _ -> findSubs s.[1..] t (p + 1) acc

let subs s t = findSubs s t 1 [] |> List.rev

printf "%A" (subs "GATATATGCATATACTT" "ATAT")