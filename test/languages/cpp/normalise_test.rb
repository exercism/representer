require_relative "stage_helper"

# Tests C++'s Normalise stage and the imports, which give one form to
# spellings that C++ reads the same way.
class CppNormaliseTest < Minitest::Test
  include CppStages

  def test_drops_includes_pragmas_and_using_declarations
    assert_same "#pragma once\n#include \"x.h\"\n#include <vector>\nint x;", "int x;"
    assert_same "using namespace std;\nusing std::string;\nint x;", "int x;"
    assert_same "namespace a { using namespace std; int x; }", "namespace a { int x; }"
    assert_same "int f() { using namespace std; return 1; }", "int f() { return 1; }"
    refute_same "struct B : A { using A::A; };", "struct B : A { };"
    refute_same "#define N 1\nint x = N;", "int x = N;"
  end

  def test_drops_an_include_guard_around_a_whole_file
    assert_same "#ifndef X_H\n#define X_H\n#include <string>\nint x;\n#endif\n", "int x;"
    refute_same "#ifndef X_H\n#define Y_H\nint x;\n#endif\n", "int x;"
    refute_same "#ifndef X_H\n#define X_H\nint x;\n#endif\nint y;\n", "int x;\nint y;"
  end

  def test_puts_the_bodies_of_ifs_and_loops_in_braces
    code = "int f(int a, int b) { %s }"
    assert_same format(code, "if (a) return b; else return a;"), format(code, "if (a) { return b; } else { return a; }")
    assert_same format(code, "while (a) a--;"), format(code, "while (a) { a--; }")
    assert_same format(code, "for (int i = 0; i < a; ++i) b++;"), format(code, "for (int i = 0; i < a; ++i) { b++; }")
    assert_same format(code, "for (auto x : v) b++;"), format(code, "for (auto x : v) { b++; }")
    assert_same format(code, "do a--; while (a);"), format(code, "do { a--; } while (a);")
    refute_same format(code, "if (a) return b;"), format(code, "while (a) return b;")
  end

  def test_an_else_with_only_an_if_is_an_else_if
    code = "int f(int a, int b) { if (a) { b++; } else %s }"
    assert_same format(code, "if (b) { a++; }"), format(code, "{ if (b) { a++; } }")
    refute_same format(code, "if (b) { a++; }"), format(code, "{ a--; if (b) { a++; } }")
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
