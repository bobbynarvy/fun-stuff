let rec gcd a b = if b = 0 then a else gcd b (a mod b);;

assert (gcd 13 27 = 1);;

assert (gcd 20536 7826 = 2)

let coprime a b = gcd a b = 1;;

assert (coprime 13 27);;

assert (not (coprime 20536 7826))

let phi n =
  let rec count_coprimes current count =
    if current = n then count
    else
      count_coprimes (current + 1)
        (if coprime n current then count + 1 else count)
  in
  count_coprimes 1 0
;;

assert (phi 10 = 4);;

assert (phi 13 = 12)
