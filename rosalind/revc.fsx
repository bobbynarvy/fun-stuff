let private complement sym =
    match sym with
    | 'A' -> 'T'
    | 'T' -> 'A'
    | 'C' -> 'G'
    | 'G' -> 'C'

let revc str =
    Seq.rev str
    |> Seq.map complement
    |> Seq.map string
    |> String.concat ""

printf "%A" (revc "AAAACCCGGT")