require "test_helper"

# Tests Rosetta as a whole on Dart solutions. The tests of each stage are in
# test/languages/dart/.
class DartTest < RosettaTest
  track "dart"

  def wrap(body) = "int f(int a, int b) {\n#{body}\n}\n"

  def test_comments_and_formatting
    assert_same_representation "// c\nint f() {\n  return 1; // x\n}\n", "int f() { return 1; }"
    assert_same_representation wrap("var c = (a + b);\nreturn c;"), wrap("var c = a + b; return c;")
    refute_same_representation wrap("return (a + b) * a;"), wrap("return a + b * a;")
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation wrap("var total = a + b;\nreturn total;"), wrap("var sum = a + b;\nreturn sum;")
    assert_same_representation "int add(int x) => x;\nint g() => add(1);", "int plus(int y) => y;\nint g() => plus(1);"
    refute_same_representation wrap("var total = a + b;\nreturn total;"), wrap("var total = a + a;\nreturn total;")
  end

  def test_names_the_solution_does_not_define_are_kept
    refute_same_representation wrap("return [a].length;"), wrap("return [a].first;")
  end

  def test_a_method_named_like_a_library_method_is_renamed_where_it_is_called_too
    refute_same_representation "int length(String s) => s.length;", "int size(String s) => s.length;"
  end

  def test_imports_and_exports_are_dropped
    assert_same_representation "import 'dart:math';\nexport 'src/a.dart';\nint f() => 1;", "int f() => 1;"
    assert_same_representation "import 'dart:math' as math;\nint f() => 1;", "int f() => 1;"
  end

  def test_numbers_and_strings_are_their_values
    assert_same_representation wrap("return a + 1_000 + 0x1F;"), wrap("return a + 1000 + 31;")
    assert_same_representation "String f() => 'you';", 'String f() => "you";'
    refute_same_representation "String f() => 'you';", "String f() => 'me';"
  end

  def test_code_that_does_not_parse_gets_basics_representation
    assert_basic_representation "int f( {"
  end
end
