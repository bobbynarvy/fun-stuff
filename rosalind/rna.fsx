let rna t =
    Seq.map 
        (fun char -> 
            match char with
            | 'T' -> 'U'
            | c -> c
        )
        t
    |> Seq.map string
    |> String.concat ""

printfn "%A" (rna "GATGGAACTTGACTACGTAAATT")