require_relative "stage_helper"

# Tests Dart's GenerateAST stage, which gives one tree to code that differs
# only in comments, layout, brackets that only group and the spelling of
# strings and numbers.
class DartGenerateASTTest < Minitest::Test
  include DartStages

  def test_drops_comments_and_layout
    assert_same "// c\nint f() {\n  return 1; // x\n}\n", "int f() { return 1; }"
    assert_same "/// Docs.\nint f() => 1;", "int f()=>1;"
  end

  def test_unwraps_brackets_that_only_group
    assert_same wrap("return (a + b);"), wrap("return a + b;")
    refute_same wrap("return (a + b) * a;"), wrap("return a + b * a;")
  end

  def test_keeps_the_kind_of_optional_parameters
    refute_same "void f({int a = 1}) {}", "void f([int a = 1]) {}"
    refute_same "void f({required int a}) {}", "void f({int a = 0}) {}"
  end

  def test_keeps_the_parts_of_a_for_loop_apart
    refute_same wrap("for (;; a++) {}"), wrap("for (a++;;) {}")
  end

  def test_keeps_compound_assignments_apart
    refute_same wrap("a = b;"), wrap("a += b;")
  end

  def test_numbers_are_their_values
    assert_same wrap("return a + 1_000 + 0x1F + 010;"), wrap("return a + 1000 + 31 + 10;")
    assert_same wrap("var x = 1.50 + 1e3;"), wrap("var x = 1.5 + 1000.0;")
    refute_same wrap("return a + 1;"), wrap("return a + 1.0;")
  end

  def test_strings_are_their_values
    assert_same wrap("var s = 'it\\'s';"), wrap("var s = \"it's\";")
    assert_same wrap("var s = r'a\\n';"), wrap("var s = 'a\\\\n';")
    assert_same wrap("var s = '''\nab''';"), wrap("var s = 'ab';")
    assert_same wrap("var s = '\\x41\\u0041\\u{41}';"), wrap("var s = 'AAA';")
    refute_same wrap("var s = 'a';"), wrap("var s = 'b';")
    refute_same wrap("var s = 'a\\n';"), wrap("var s = r'a\\n';")
  end

  def test_unknown_escapes_stay_as_they_are
    refute_same wrap("var s = '\\a';"), wrap("var s = 'a';")
  end

  def test_interpolations_keep_their_code
    assert_same wrap("var s = 'a $a';"), wrap("var s = \"a ${a}\";")
    refute_same wrap("var s = 'a $a';"), wrap("var s = 'a $b';")
    refute_same wrap("var s = 'a $a';"), wrap("var s = r'a $a';")
  end

  def test_adjacent_strings_stay_apart
    refute_same wrap("var s = 'a' 'b';"), wrap("var s = 'ab';")
    assert_same wrap("var s = 'a' \"b\";"), wrap("var s = 'a'   'b';")
  end

  def test_names_spelled_like_keywords_are_leaves
    assert_includes ast(wrap("var set = <int>{};")), "set"
    refute_includes ast(wrap("var set = <int>{};")), "(identifier"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
