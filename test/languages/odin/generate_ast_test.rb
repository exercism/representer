require_relative "stage_helper"

# Tests Odin's GenerateAST stage. Each assert_same pair is code that Odin's
# parser reads the same way, ignoring spacing, and each refute_same pair is
# code that it reads differently.
class OdinGenerateASTTest < Minitest::Test
  include OdinStages

  def test_drops_layout
    assert_same "f :: proc(a, b: int) -> int {\n\treturn a + b\n}\n", "f :: proc(a,b:int)->int { return a+b }\n"
    assert_same in_proc("x := 1; y := 2"), in_proc("x := 1\ny := 2")
    assert_same "Point :: struct { x, y: int }\n", "Point :: struct {\n\tx, y: int,\n}\n"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same in_proc("return (a + b)"), in_proc("return a + b")
    assert_same in_proc("if (x > 1) { f() }"), in_proc("if x > 1 { f() }")
    assert_same "f :: proc() -> (int) { return 1 }\n", "f :: proc() -> int { return 1 }\n"
    refute_same in_proc("return (a + b) * c"), in_proc("return a + b * c")
    refute_same "f :: proc() -> (n: int) { return }\n", "f :: proc() -> int { return }\n"
  end

  def test_a_do_body_is_a_block
    assert_same in_proc("if x do return 1"), in_proc("if x { return 1 }")
    assert_same in_proc("if x do f() else do g()"), in_proc("if x { f() } else { g() }")
    assert_same in_proc("for x in xs do f(x)"), in_proc("for x in xs { f(x) }")
    assert_same in_proc("if a do f()\nelse if b do g()\nelse do h()"), in_proc("if a { f() } else if b { g() } else { h() }")
    refute_same in_proc("if x do f()\ng()"), in_proc("if x { f(); g() }")
  end

  def test_both_ternaries_are_the_same
    assert_same in_proc("y := a if b else c"), in_proc("y := b ? a : c")
    refute_same in_proc("y := a if b else c"), in_proc("y := a ? b : c")
    refute_same in_proc("y := a when b else c"), in_proc("y := a if b else c")
  end

  def test_type_assertions_keep_their_brackets
    refute_same in_proc("y := v.(int)"), in_proc("y := v.int")
    refute_same in_proc("y := v.?"), in_proc("y := v.(int)")
  end

  def test_numbers_are_their_values
    assert_same in_proc("x := 1_000 + 0x1F"), in_proc("x := 1000 + 31")
    assert_same in_proc("x := 1.50"), in_proc("x := 1.5")
    assert_same in_proc("x := -1"), in_proc("x := - 1")
    refute_same in_proc("x := 1.0"), in_proc("x := 1")
  end

  def test_strings_are_their_values
    assert_same in_proc("s := \"a\\tb\""), in_proc("s := \"a\tb\"")
    assert_same in_proc("s := `a`"), in_proc("s := \"a\"")
    assert_same in_proc("s := \"\\x41\""), in_proc("s := \"A\"")
    refute_same in_proc("s := `a\\n`"), in_proc("s := \"a\\n\"")
    refute_same in_proc("s := \"\\xff\""), in_proc("s := \"\\xfe\"")
    refute_same in_proc("c := 'a'"), in_proc("c := \"a\"")
    refute_same in_proc("c := ','"), in_proc("c := ';'")
  end

  # These keywords and punctuation are the only difference between each pair.
  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same in_proc("x = 1"), in_proc("x := 1")
    refute_same in_proc("x: int = 1"), in_proc("x: int : 1")
    refute_same in_proc("y := a[1:]"), in_proc("y := a[:1]")
    refute_same in_proc("switch x { case a: b() }"), in_proc("switch x { case a, b(): }")
    refute_same in_proc("f(a = 1)"), in_proc("f(a, 1)")
    refute_same in_proc("for i := 0; ; {}"), in_proc("for ; ; i := 0 {}")
    refute_same in_proc("for x in xs {}"), in_proc("for &x in xs {}")
    refute_same in_proc("xs: [dynamic]int"), in_proc("xs: []int")
    refute_same in_proc("y := p^"), in_proc("y: ^p")
    refute_same "f :: proc(a, b: int) {}\n", "f :: proc(a, b, int) {}\n"
  end

  private
  def in_proc(code) = "f :: proc() {\n#{code}\n}\n"
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
