let is_palindrome l = List.rev l = l;;

assert (is_palindrome [ "x"; "a"; "m"; "a"; "x" ]);;

assert (not (is_palindrome [ "a"; "b" ]))
