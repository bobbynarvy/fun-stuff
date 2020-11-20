let iprb ki mi ni =
    let k, m, n = float ki, float mi, float ni
    let t = k + m + n |> float
    let tSub = t - 1.0
    [
        k / t * (k - 1.0) / tSub * 1.0;     // DD and DD
        k / t * m / tSub * 1.0;             // DD and Dd
        k / t * n / tSub * 1.0;             // DD and dd
        m / t * k / tSub * 1.0;             // Dd and DD
        m / t * (m - 1.0) / tSub * 0.75;    // Dd and Dd
        m / t * n / tSub * 0.5;             // Dd and dd
        n / t * k / tSub * 1.0;             // dd and DD
        n / t * m / tSub * 0.5;             // dd and Dd
        n / t * (n - 1.0) / tSub * 0.0;     // dd and dd
    ] |> List.sum

printf "%f" (iprb 2 2 2)