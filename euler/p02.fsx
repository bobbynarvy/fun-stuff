let rec fib acc = 
    match acc with
    | [] -> fib [2; 1]
    | first :: second :: rest -> 
        if (first > 4000000) then acc
        else fib (first + second :: acc)

let answer = 
    fib []
    |> List.filter (fun x -> x % 2 = 0)
    |> List.sum
 
printfn "%A" answer