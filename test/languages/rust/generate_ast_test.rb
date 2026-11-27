require_relative "stage_helper"

# Tests Rust's GenerateAST stage. Each assert_same pair gets the same tree from
# Rust's parser (syn, comparing each literal's value and ignoring comments and
# spacing), and each refute_same pair gets different trees. The last test
# lists the pairs where this stage deliberately differs from the parser.
class RustGenerateASTTest < Minitest::Test
  include RustStages

  def test_drops_comments_and_layout
    assert_same "fn f() { let a = 1; // one\n/* two */\n}", "fn f(){let a=1;}"
    assert_same "/// Docs.\nfn f() {}", "fn f() {}"
  end

  def test_drops_empty_statements
    assert_same wrap("let a = 1;;"), wrap("let a = 1;")
    assert_same "struct A;;", "struct A;"
  end

  def test_a_trailing_semicolon_still_changes_the_result
    refute_same wrap("1"), wrap("1;")
  end

  # These semicolons and commas are the only difference between each pair.
  def test_keeps_the_tokens_that_tell_programs_apart
    refute_same wrap("let a = [0; 5];"), wrap("let a = [0, 5];")
    refute_same wrap("let a = vec![0; 5];"), wrap("let a = vec![0, 5];")
    refute_same "fn f(a: i32) -> Vec<i32> { vec![a - 1] }", "fn f(a: i32) -> Vec<i32> { vec![a, -1] }"
    refute_same "fn f() { g(vec![[1, 2]]) }", "fn f() { g(vec![(1, 2)]) }"
  end

  def test_strings_are_their_values
    assert_same wrap('let s = "a\\u{41}\\x41\\n";'), wrap('let s = "aAA\\n";')
    assert_same wrap('let s = r"a";'), wrap('let s = "a";')
    assert_same wrap('let s = r#"a"b"#;'), wrap('let s = "a\\"b";')
    refute_same wrap('let s = b"a";'), wrap('let s = "a";')
    refute_same wrap('let s = r"\\n";'), wrap('let s = "\\n";')
    refute_same 'fn f() -> &str { ";" }', 'fn f() -> &str { ":" }'
  end

  def test_numbers_are_their_values
    assert_same wrap("let x = 1_000 + 0x1F + 0b11 + 0o17;"), wrap("let x = 1000 + 31 + 3 + 15;")
    assert_same wrap("let x = 1_000u32 + 0x1F_u8;"), wrap("let x = 1000u32 + 31u8;")
    assert_same wrap("let x = 1.50 + 2.0_f64;"), wrap("let x = 1.5 + 2.0f64;")
    refute_same wrap("let x = 1u8;"), wrap("let x = 1;")
    refute_same wrap("let x = 1.0;"), wrap("let x = 1;")
  end

  # syn keeps brackets that only group, and the representation has never
  # kept them, so this stage drops them too. The tree's shape still shows the
  # grouping. A capitalised name in a pattern becomes a path, so that no
  # pattern defines it.
  def test_where_this_stage_differs_from_the_parser
    assert_same wrap("let a = (1 + 2);"), wrap("let a = 1 + 2;")
    refute_same wrap("let a = (1 + 2) * 3;"), wrap("let a = 1 + 2 * 3;")
    assert_includes ast(wrap("match x { None => 0, Some(y) => y }")), "(path None)"
    assert_includes ast(wrap("match x { None => 0, Some(y) => y }")), "(path Some) y"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
