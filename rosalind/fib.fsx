let rec fib n k =
    match n with
    | 1L -> 1L
    | 2L -> 1L
    | _ -> fib (n - 1L) k + k * fib (n - 2L) k

printf "%A" (fib 32L 5L)