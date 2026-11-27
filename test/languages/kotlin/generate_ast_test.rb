require_relative "stage_helper"

# Tests Kotlin's GenerateAST stage. Each assert_same pair has the same meaning
# in Kotlin, and each refute_same pair has different meanings.
class KotlinGenerateASTTest < Minitest::Test
  include KotlinStages

  def test_layout_makes_no_difference
    assert_same "val a = f(1, 2,); val b = 3", "val a = f(1, 2)\nval b = 3"
    assert_same "enum class A { X, Y; }", "enum class A { X, Y }"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "val a = (1 + 2)", "val a = 1 + 2"
    refute_same "val a = (1 + 2) * 3", "val a = 1 + 2 * 3"
  end

  def test_keywords_that_tell_code_apart_stay
    refute_same "fun interface A { fun f() }", "interface A { fun f() }"
    refute_same "val a = b in c", "val a = b !in c"
    refute_same "val a = b is C", "val a = b !is C"
    refute_same "val (a, b) = c", "val [a, b] = c"
    refute_same "val a = { x }", "val a = { -> x }"
  end

  def test_strings_are_their_values
    assert_same 'val a = """a"""', 'val a = "a"'
    assert_same 'val a = "\\u0041\\t"', "val a = \"A\t\""
    refute_same 'val a = "\\$b"', 'val a = "$b"'
    refute_same 'val a = """\\n"""', 'val a = "\\n"'
    refute_same 'val a = """say "hi""""', 'val a = """say "hi"""'
    refute_same 'val a = "a"', "val a = 'a'"
  end

  def test_both_spellings_of_an_interpolation_are_the_same
    assert_same 'val a = "x$b"', 'val a = "x${b}"'
    assert_same 'val a = "$value"', 'val a = "${value}"'
    refute_same 'val a = "$b.c"', 'val a = "${b.c}"'
    refute_same 'val a = "a$b"', 'val a = "${b}a"'
  end

  def test_characters_are_their_values
    assert_same "val a = '\\u0041'", "val a = 'A'"
    refute_same "val a = 'a'", "val a = 'b'"
  end

  def test_numbers_are_their_values
    assert_same "val a = 1_000 + 0x1F + 0b11 + 1.50 + 1e3", "val a = 1000 + 31 + 3 + 1.5 + 1000.0"
    assert_same "val a = 1.5F + 0x10L + 1U + 2UL", "val a = 1.5f + 16L + 1u + 2uL"
    refute_same "val a = 1", "val a = 1L"
    refute_same "val a = 1u", "val a = 1uL"
    refute_same "val a = 1.0", "val a = 1.0f"
  end

  def test_names_in_backticks_are_the_same_names
    assert_same "val `a` = 1", "val a = 1"
  end

  def test_a_label_wraps_its_expression
    assert_includes ast(in_function("a@ for (x in y) break@a")), "(labeled_expression a\n"
  end

  def test_dropping_the_imports_leaves_nothing_behind
    assert_equal write(prepare("val a = 1")), write(prepare("import b.c\nimport d.*\n\nval a = 1"))
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
