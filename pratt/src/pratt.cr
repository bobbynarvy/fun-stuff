module Pratt
  extend self
  record Atom, c : Char
  record Op, c : Char
  record Eof

  alias Token = Atom | Op | Eof

  class Lexer
    @tokens : Array(Token)

    def initialize(input)
      @tokens = input.chars
        .select { |c| !c.ascii_whitespace? }
        .reverse
        .map { |c| (c.alphanumeric? ? Atom.new(c) : Op.new(c)).as(Token) }
    end

    def next : Token
      @tokens.pop { Eof.new }
    end

    def peek : Token
      @tokens.last { Eof.new }
    end
  end

  def expr(input) : SExp
    lexer = Lexer.new(input)
    SExp.new(expr_bp(lexer, 0))
  end

  def expr_bp(lexer, min_bp : UInt8) : S
    token = lexer.next
    lhs = case token
          when Atom
            Atom.new(token.c)
          when Op
            if token.c == '('
              lhs_inner = expr_bp(lexer, 0)
              raise "Missing )" unless tokens_eq?(lexer.next, Op.new(')'))
              lhs_inner
            else
              r_bp = prefix_binding_power(token.c)
              rhs = expr_bp(lexer, r_bp)
              Cons.new(token.c, [rhs])
            end
          else
            raise "bad token"
          end

    loop do
      token = lexer.peek
      op = case token
           when Eof
             break
           when Op
             token.c
           else
             raise "bad token"
           end

      if l_bp = postfix_binding_power(op)
        break if l_bp < min_bp
        lexer.next
        lhs = if op == '['
                rhs = expr_bp(lexer, 0)
                raise "Missing ]" unless tokens_eq?(lexer.next, Op.new(']'))
                Cons.new(op, [lhs, rhs])
              else
                Cons.new(op, [lhs])
              end

        next
      end

      if bp = infix_binding_power(op)
        l_bp, r_bp = bp
        break if l_bp < min_bp

        lexer.next
        lhs = if op == '?'
                mhs = expr_bp(lexer, 0)
                raise "Missing :" unless tokens_eq?(lexer.next, Op.new(':'))
                rhs = expr_bp(lexer, r_bp)
                Cons.new(op, [lhs, mhs, rhs])
              else
                rhs = expr_bp(lexer, r_bp)
                Cons.new(op, [lhs, rhs])
              end
        next
      end

      break
    end

    lhs
  end

  def infix_binding_power(op : Char)
    case op
    when '='
      {2_u8, 1_u8}
    when '?'
      {4_u8, 3_u8}
    when '+', '-'
      {5_u8, 6_u8}
    when '*', '/'
      {7_u8, 8_u8}
    when '.'
      {14_u8, 13_u8}
    end
  end

  def prefix_binding_power(op : Char)
    case op
    when '+', '-'
      9_u8
    else
      raise "bad op: #{op}"
    end
  end

  def postfix_binding_power(op : Char)
    if op == '!' || op == '['
      11_u8
    end
  end

  private def tokens_eq?(t1, t2)
    case {t1, t2}
    when {Atom, Atom}
      t1.c == t2.c
    when {Op, Op}
      t1.c == t2.c
    when {Eof, Eof}
      true
    else
      false
    end
  end

  # S-Expressions
  record Atom, c : Char
  record Cons, head : Char, rest : Array(S)

  alias S = Atom | Cons

  class SExp
    @cell : S

    def initialize(@cell)
    end

    def to_s : String
      case @cell
      in Atom
        @cell.as(Atom).c.to_s
      in Cons
        c = @cell.as(Cons)
        s = "(" + c.head
        c.rest.each { |cell| s += " " + SExp.new(cell).to_s }
        s += ")"
      end
    end

    def to_s(io : IO) : Nil
      io << to_s
    end
  end
end
