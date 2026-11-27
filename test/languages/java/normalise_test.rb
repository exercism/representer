require_relative "stage_helper"

# Tests Java's Normalise stage, which gives one form to spellings that Java
# reads the same way.
class JavaNormaliseTest < Minitest::Test
  include JavaStages

  def test_drops_the_package_and_imports
    assert_same "package a.b;\nimport java.util.List;\nimport static java.lang.Math.max;\nclass A { }", "class A { }"
  end

  def test_puts_the_bodies_of_ifs_and_loops_in_braces
    code = "class A { void f() { %s } }"
    assert_same format(code, "if (a) b(); else c();"), format(code, "if (a) { b(); } else { c(); }")
    assert_same format(code, "if (a) b(); else if (c) d();"), format(code, "if (a) { b(); } else { if (c) { d(); } }")
    assert_same format(code, "while (a) b(); for (;;) b();"), format(code, "while (a) { b(); } for (;;) { b(); }")
    assert_same format(code, "for (int x : xs) b(); do b(); while (a);"),
      format(code, "for (int x : xs) { b(); } do { b(); } while (a);")
    refute_same format(code, "if (a) b();"), format(code, "while (a) b();")
  end

  def test_an_else_with_more_than_an_if_stays_apart_from_an_else_if
    code = "class A { void f() { if (a) { g(); } else %s } }"
    refute_same format(code, "{ h(); if (b) { h(); } }"), format(code, "if (b) { h(); }")
  end

  def test_drops_package_names_before_class_names
    assert_same "class A { java.util.List<String> f() { return java.util.Arrays.asList(); } }",
      "class A { List<String> f() { return Arrays.asList(); } }"
    assert_same "class A { java.util.Map.Entry<String, Integer> e; }", "class A { Map.Entry<String, Integer> e; }"
    refute_same "class A { example.Foo f() { return null; } }", "class A { Foo f() { return null; } }"
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
