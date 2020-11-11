let rec findSmallestCommonMultiple n =
    if List.exists (fun x -> n % x <> 0) [11..20] then findSmallestCommonMultiple (n + 2)
    else n

printfn "%i" (findSmallestCommonMultiple 10)