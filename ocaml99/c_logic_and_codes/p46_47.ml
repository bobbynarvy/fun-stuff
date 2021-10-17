type bool_expr =
  | Var of string
  | Not of bool_expr
  | And of bool_expr * bool_expr
  | Or of bool_expr * bool_expr

let rec expr_val a_var a_val b_val expr =
  match expr with
  | Var x -> if x = a_var then a_val else b_val
  | Not not_expr -> not (expr_val a_var a_val b_val not_expr)
  | And (expr_x, expr_y) ->
      expr_val a_var a_val b_val expr_x && expr_val a_var a_val b_val expr_y
  | Or (expr_x, expr_y) ->
      expr_val a_var a_val b_val expr_x || expr_val a_var a_val b_val expr_y

let table2 a b expr =
  [
    (true, true, expr_val a true true expr);
    (true, false, expr_val a true false expr);
    (false, true, expr_val a false true expr);
    (false, false, expr_val a false false expr);
  ]
;;

assert (
  table2 "a" "b" (And (Var "a", Or (Var "a", Var "b")))
  = [
      (true, true, true);
      (true, false, true);
      (false, true, false);
      (false, false, false);
    ])
