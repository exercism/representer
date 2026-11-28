require_relative "stage_helper"

# Tests Groovy's GenerateAST stage. Each assert_same pair has the same meaning
# in Groovy, and each refute_same pair has different meanings.
class GroovyGenerateASTTest < Minitest::Test
  include GroovyStages

  def test_layout_makes_no_difference
    assert_same "def a = f(1, 2,); def b = [3, 4,]", "def a = f(1, 2)\ndef b = [3, 4]"
    assert_same "enum A { X, Y; }", "enum A { X, Y }"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "def a = (1 + 2)", "def a = 1 + 2"
    refute_same "def a = (1 + 2) * 3", "def a = 1 + 2 * 3"
  end

  def test_def_and_var_are_a_declaration_with_no_type
    assert_same "def a = 1", "var a = 1"
    assert_same "class A { static def f() { 1 } }", "class A { static f() { 1 } }"
    assert_same "def f(def a) { a }", "def f(a) { a }"
    refute_same "def a = 1", "int a = 1"
    refute_same "def f() { a = 1 }", "def f() { def a = 1 }"
  end

  def test_each_variable_of_a_typed_declaration_is_a_declarator
    refute_same "int a, b = 1", "int a = b, c"
    assert_includes ast("int a = 1, b"), "(variable_declarator a 1)"
  end

  def test_a_call_without_brackets_is_a_call_with_them
    assert_same 'println "a"', 'println("a")'
    assert_same "a.b c, d", "a.b(c, d)"
  end

  def test_a_closure_after_the_brackets_is_the_last_argument
    assert_same "a.each { it }", "a.each({ it })"
    assert_same "a.inject(0) { s, x -> s + x }", "a.inject(0, { s, x -> s + x })"
    assert_same "a.find() { it }", "a.find { it }"
    refute_same "a.each { it }", "a.each { -> it }"
  end

  def test_both_loops_over_a_collection_are_the_same
    assert_same "for (x in xs) {}", "for (x : xs) {}"
  end

  def test_strings_are_their_values
    assert_same "def a = 'a'", 'def a = "a"'
    assert_same "def a = '''a'''", 'def a = """a"""'
    assert_same "def a = /a/", "def a = 'a'"
    assert_same "def a = 'a\\u0041\\t\\$'", "def a = \"aA\t$\""
    assert_same "def a = /a\\/b/", "def a = 'a/b'"
    refute_same "def a = /a\\s/", "def a = 'a\\s'"
    refute_same "def a = '$b'", 'def a = "$b"'
  end

  def test_both_spellings_of_an_interpolation_are_the_same
    assert_same 'def a = "x$b"', 'def a = "x${b}"'
    assert_same 'def a = "$b.c"', 'def a = "${b.c}"'
    refute_same 'def a = "$b.c()"', 'def a = "${b.c()}"'
    refute_same 'def a = "a$b"', 'def a = "${b}a"'
  end

  def test_a_map_key_that_is_a_name_is_a_string
    assert_same "def m = [a: 1]", "def m = ['a': 1]"
    assert_same "f(a: 1)", "f('a': 1)"
    refute_same "def m = [a: 1]", "def m = [(a): 1]"
  end

  def test_numbers_are_their_values
    assert_same "def a = 1_000 + 0x1F + 0b11 + 017 + 1.50 + 1e3", "def a = 1000 + 31 + 3 + 15 + 1.5 + 1000.0"
    assert_same "def a = 1.5F + 2D + 0x10l + 2g + 1.5G", "def a = 1.5f + 2.0d + 16L + 2G + 1.5"
    refute_same "def a = 1", "def a = 1L"
    refute_same "def a = 1", "def a = 1G"
    refute_same "def a = 1.0", "def a = 1.0d"
  end

  def test_dropping_the_imports_leaves_nothing_behind
    imports = "import a.B\nimport a.*\nimport a.B as C\nimport static a.B.c\nimport static a.B.*\nimport static a.B.c as d\n"
    assert_equal write(prepare("def a = 1")), write(prepare("#{imports}\ndef a = 1"))
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
