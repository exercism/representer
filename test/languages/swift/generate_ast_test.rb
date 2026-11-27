require_relative "stage_helper"

# Tests Swift's GenerateAST stage. Each assert_same pair gets the same tree
# from Swift's parser (`swiftc -dump-parse`, comparing each literal's value
# and ignoring locations), and each refute_same pair gets different trees.
# The last test lists the pairs where this stage deliberately differs from
# the parser.
class SwiftGenerateASTTest < Minitest::Test
  include SwiftStages

  def test_drops_comments_and_layout
    assert_same "func f() { let a = 1 // one\n/* two */\n}", "func f(){let a=1}"
    assert_same "/// Docs.\nfunc f() {}", "func f() {}"
    assert_same "let a = [1, 2,]", "let a = [1, 2]"
  end

  def test_strings_are_their_values
    assert_same 'let s = "a\\u{41}\\n"', 'let s = "aA\\n"'
    assert_same 'let s = #"a"#', 'let s = "a"'
    assert_same 'let s = #"a\\#(x)b"#', 'let s = "a\\(x)b"'
    assert_same "let s = \"\"\"\n    a\n      b\n    \"\"\"", 'let s = "a\\n  b"'
    refute_same 'let s = "a"', 'let s = "b"'
    refute_same 'let s = "a\\(x)"', 'let s = "a(x)"'
    refute_same 'let s = #"\\n"#', 'let s = "\\n"'
  end

  def test_numbers_are_their_values
    assert_same "let x = 1_000 + 0x1F + 0b11 + 0o17 + 010", "let x = 1000 + 31 + 3 + 15 + 10"
    assert_same "let x = 1.50", "let x = 1.5"
    refute_same "let x = 1.0", "let x = 1"
  end

  def test_names_in_backticks_are_the_names
    assert_same "let x = `y` + 1", "let x = y + 1"
  end

  def test_a_closures_parameters_can_be_in_brackets
    assert_same "let f = { (a, b) in a + b }", "let f = { a, b in a + b }"
  end

  def test_a_product_without_spaces_is_a_product
    assert_same "let y = a*b + 1", "let y = a * b + 1"
    assert_same "let y = a*2*b", "let y = a * 2 * b"
  end

  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same "let y = a[0]", "let y = a(0)"
    refute_same "let y = x == .red", "let y = x == red"
    refute_same "private(set) var x = 1", "private var x = 1"
    refute_same "let y = try? f()", "let y = try! f()"
    refute_same in_function("if x > 0 { } else { g() }"), in_function("if x > 0 { g() }")
    refute_same in_function("if let y = z, w { }"), in_function("if let y, z, w { }")
    refute_same in_function("switch x { case let y: g(y) }"), in_function("switch x { case y: g(y) }")
  end

  # Swift's parser keeps brackets that only group and records a trailing
  # `;`. The representation drops both, as layout, and the tree's shape
  # still shows the grouping.
  def test_where_this_stage_differs_from_the_parser
    assert_same "let a = (1 + 2)", "let a = 1 + 2"
    refute_same "let a = (1 + 2) * 3", "let a = 1 + 2 * 3"
    assert_same "let a = 1;", "let a = 1"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
