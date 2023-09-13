require "./spec_helper"

describe Pratt do
  it do
    Pratt.expr("1").to_s.should eq("1")

    Pratt.expr("1 + 2 * 3").to_s.should eq("(+ 1 (* 2 3))")

    Pratt.expr("a + b * c * d + e").to_s.should eq("(+ (+ a (* (* b c) d)) e)")

    Pratt.expr("f . g . h").to_s.should eq("(. f (. g h))")

    Pratt.expr("1 + 2 + f . g . h * 3 * 4").to_s.should eq("(+ (+ 1 2) (* (* (. f (. g h)) 3) 4))")

    Pratt.expr("--1 * 2").to_s.should eq("(* (- (- 1)) 2)")

    Pratt.expr("--f . g").to_s.should eq("(- (- (. f g)))")

    Pratt.expr("-9!").to_s.should eq("(- (! 9))")

    Pratt.expr("f . g !").to_s.should eq("(! (. f g))")

    Pratt.expr("(((0)))").to_s.should eq("0")

    Pratt.expr("x[0][1]").to_s.should eq("([ ([ x 0) 1)")

    Pratt.expr("a ? b :
         c ? d
         : e").to_s.should eq("(? a b (? c d e))")

    Pratt.expr("a = 0 ? b : c = d").to_s.should eq("(= a (= (? 0 b c) d))")
  end
end
