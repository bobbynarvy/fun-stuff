let private square n = n * n

let answer = 
    let nums = [1..100]
    let sumOfSquares = List.map square nums |> List.sum
    let squareOfSums = List.sum nums |> square

    squareOfSums - sumOfSquares

printfn "%i" answer