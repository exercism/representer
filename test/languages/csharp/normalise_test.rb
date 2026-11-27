require_relative "stage_helper"

# Tests C#'s Normalise stage, which keeps the old representer's rewriters and
# the changes made by Roslyn's simplifier.
class CSharpNormaliseTest < Minitest::Test
  include CSharpStages

  def test_drops_empty_brackets_before_an_initializer
    assert_same "var l = new List<int>() { 1 };", "var l = new List<int> { 1 };"
    refute_same "var l = new List<int>(2) { 1 };", "var l = new List<int> { 1 };"
  end

  def test_drops_system_before_a_name
    assert_same "var x = System.Math.Max(1, 2);", "var x = Math.Max(1, 2);"
    assert_same "class A { System.Text.StringBuilder b; }", "class A { Text.StringBuilder b; }"
  end

  def test_writes_string_as_its_keyword
    assert_same "class A { String b = String.Empty; }", "class A { string b = string.Empty; }"
    refute_same "class A { Int32 b; }", "class A { int b; }"
  end

  def test_turns_a_negative_ternary_into_a_positive_one
    assert_same "var x = a != b ? 1 : 2;", "var x = a == b ? 2 : 1;"
    assert_same "var x = !a ? 1 : 2;", "var x = a ? 2 : 1;"
  end

  def test_drops_comparisons_with_true_and_false
    assert_same "var x = a == true;", "var x = a;"
    assert_same "var x = false == a;", "var x = !a;"
    assert_same "var x = a != true;", "var x = !a;"
    refute_same "var x = a && true;", "var x = a;"
  end

  def test_drops_readonly
    assert_same "class A { readonly int b; }", "class A { int b; }"
    assert_same "readonly struct S { }", "struct S { }"
    assert_same "class A { ref readonly int B() => ref c; }", "class A { ref int B() => ref c; }"
  end

  def test_drops_this_and_the_class_name_before_its_own_members
    code = "class A { int c; static int B() => 1; int D() => %s + %s(); }"
    assert_same format(code, "this.c", "A.B"), format(code, "c", "B")
    shadowed = "class A { int c; void D(int c) { %s = c; } }"
    refute_same format(shadowed, "this.c"), format(shadowed, "c")
  end

  def test_puts_the_bodies_of_if_and_else_in_braces
    assert_same "if (a) b(); else c();", "if (a) { b(); } else { c(); }"
    assert_same "if (a) b(); else if (c) d();", "if (a) { b(); } else { if (c) { d(); } }"
  end

  def test_writes_dictionary_entries_as_pairs
    assert_same 'var d = new Dictionary<int, string> { [1] = "a" };', 'var d = new Dictionary<int, string> { { 1, "a" } };'
    refute_same 'var d = new Foo<int, string> { [1] = "a" };', 'var d = new Foo<int, string> { { 1, "a" } };'
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
