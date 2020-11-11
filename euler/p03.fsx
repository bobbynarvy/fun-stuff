// filter out:
// - non-prime numbers
// - prime numbers that do not divide n
// - multiples of prime nums that divide n

// let getPrimes acc next =
let getPrime acc =
    let rec getNextPrime n acc =
        let n1 = n + 2
        if (List.exists (fun x -> n1 % x = 0) acc) then getNextPrime n1 acc
        else n1 :: acc 

    match acc with
    | [] -> getNextPrime 3 [3]
    | biggestP :: next -> getNextPrime biggestP acc

let rec private getNextPrime n acc =
    let n1 = n + 2L
    if (List.exists (fun x -> n1 % x = 0L) acc) then getNextPrime n1 acc
    else n1 :: acc

let rec private accPrimesUntil n acc =
    match acc with
    | [] -> accPrimesUntil n (getNextPrime 3L [3L])
    | p :: rest ->
        if p > n then rest 
        else (getNextPrime p acc) |> accPrimesUntil n

// let getPrimeFactors n = accPrimeFactors n []

// printfn "%A" (accPrimesUntil 600851475143L [])

accPrimesUntil 600851475143L []