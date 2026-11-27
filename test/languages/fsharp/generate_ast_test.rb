require_relative "stage_helper"

# Tests F#'s GenerateAST stage. Each assert_same pair gets the same tree
# from the F# compiler's parser (its untyped syntax tree, ignoring ranges,
# trivia and brackets that only group), and each refute_same pair gets
# different trees. The last test lists the pairs where this stage
# deliberately differs from the parser.
class FSharpGenerateASTTest < Minitest::Test
  include FSharpStages

  def test_drops_comments_and_layout
    assert_same "// a\n(* b *)\n/// c\nlet f x = x", "let f x = x"
    assert_same "let xs = [1; 2; 3]", "let xs = [\n    1\n    2\n    3 ]"
    assert_same "let f a =\n    let b = a + 1\n    b", "let f a = let b = a + 1 in b"
    assert_same "let f a b = a   +   b", "let f a b = a + b"
    refute_same "let f a b = a + b", "let f a b = a - b"
    refute_same "let f a b = a <= b", "let f a b = a < b"
  end

  def test_unwraps_brackets_that_only_group
    assert_same "let f x = (x)", "let f x = x"
    assert_same "let f (x) = x", "let f x = x"
    assert_same "let f x = g (x)", "let f x = g x"
    assert_same "let f x = g(x)", "let f x = g x"
    assert_same "let f x = [ (x + 1); 2 ]", "let f x = [ x + 1; 2 ]"
    assert_same "let f x = (x + 1)", "let f x = x + 1"
    assert_same "let r x y = sqrt (x * x + y * y)", "let r x y = sqrt(x * x + y * y)"
    refute_same "let f x = (x + 1) * 2", "let f x = x + 1 * 2"
    refute_same "let f a b c = (a + b) * c", "let f a b c = a + b * c"
  end

  def test_groups_operators_by_precedence
    assert_same "let f a b c = a + (b * c)", "let f a b c = a + b * c"
    assert_same "let f a b c = (a * b) + c", "let f a b c = a * b + c"
    assert_same "let f a b = a + (g b)", "let f a b = a + g b"
    assert_same "let f a b = (g a) + (g b)", "let f a b = g a + g b"
    assert_same "let f x = (g x) |> h", "let f x = g x |> h"
    assert_same "let f a b = a :: (b :: [])", "let f a b = a :: b :: []"
    assert_same "let f a b = (a = b) && (b > 1) || a < 0", "let f a b = a = b && b > 1 || a < 0"
    assert_same "let f a b = a ** (b ** 2.0)", "let f a b = a ** b ** 2.0"
    assert_same "let f x = (x |> g) >> h", "let f x = x |> g >> h"
    assert_same "let f x = -(g x) + 1", "let f x = -g x + 1"
    refute_same "let f a b = a - (b - 1)", "let f a b = a - b - 1"
    refute_same "let f a b = (a :: b) :: []", "let f a b = a :: b :: []"
  end

  def test_method_call_brackets
    assert_same "let f x = Seq.map(string >> int) x", "let f x = Seq.map (string >> int) x"
    assert_same "let f a b = g (a)(b)", "let f a b = g a b"
    assert_same "let f x = h (g(x))", "let f x = h (g x)"
    refute_same "let f a b = g (a b)", "let f a b = g a b"
  end

  def test_the_first_bar_is_optional
    assert_same "type T =\n    | A\n    | B", "type T =\n    A\n    | B"
    assert_same "let f x =\n    match x with\n    | A -> 1\n    | B -> 2", "let f x =\n    match x with\n    A -> 1\n    | B -> 2"
    refute_same "let f x =\n    match x with\n    | A -> 1\n    | B -> 2", "let f x =\n    match x with\n    | A -> 2\n    | B -> 1"
  end

  def test_elif_is_else_if
    assert_same "let f x = if x then 1 elif y then 2 else 3", "let f x = if x then 1 else if y then 2 else 3"
  end

  def test_strings
    assert_same 'let s = "a"', 'let s = """a"""'
    assert_same 'let s = "a\\\\nb"', 'let s = @"a\\nb"'
    assert_same 'let s = "a\\u0041"', 'let s = "aA"'
    refute_same 'let s = "a"', 'let s = "b"'
    refute_same 'let s = "a\\qb"', 'let s = "aqb"'
    refute_same 'let s = "a\\nb"', 'let s = @"a\\nb"'
  end

  def test_numbers
    assert_same "let x = 31_557_600.0 + 1.50", "let x = 31557600.0 + 1.5"
    assert_same "let x = 1_000 + 0x1F + 0b1", "let x = 1000 + 31 + 1"
    refute_same "let n = 1.5", "let n = 2.5"
    refute_same "let x = 10L", "let x = 10"
    refute_same "let x = 1.0", "let x = 1"
    refute_same "let n = 1.0", "let n = 1.0f"
    refute_same "let n = 1.0", "let n = 1.0m"
  end

  def test_patterns_of_one_name
    assert_includes ast("let f x = x"), "(named_pattern x)"
    assert_includes ast("let f (x: int) = x"), "(named_pattern x)"
    assert_includes ast("let X = 1"), "(named_pattern X)"
    assert_includes ast("let f o = match o with | Some v -> v | None -> 0"), "(named_pattern v)"
    refute_includes ast("let f o = match o with | Some v -> v | None -> 0"), "(named_pattern None)"
    refute_includes ast("let f _ = 1"), "(named_pattern _)"
  end

  def test_a_function_with_a_return_type_is_a_function
    assert_includes ast("let add (a: int) (b: int): int = a + b"), "(function_declaration_left add"
    assert_same "let add (a: int) (b: int): int = a + b", "let add (a: int) (b: int) : int = a + b"
    refute_same "let add (a: int) (b: int): int = a + b", "let add (a: int) (b: int) = a + b"
  end

  def test_module_names
    assert_includes ast("module A.B\nlet x = 1", wrap: false), "(module_name A . B)"
    assert_includes ast("namespace A\nmodule B =\n    let x = 1", wrap: false), "(module_name A)"
  end

  # The F# compiler's parser reads the cases of a match written on one line
  # as cases. The grammar reads all but the first as `|` and `->` operators
  # in the first case's body, and this stage keeps that reading.
  def test_where_this_stage_differs_from_the_parser
    refute_same "let f x = match x with | A -> 1 | B -> 2", "let f x =\n    match x with\n    | A -> 1\n    | B -> 2"
  end

  private
  def ast(source, wrap: true) = write(generate_ast(wrap ? "module M\n\n#{source}\n" : source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
