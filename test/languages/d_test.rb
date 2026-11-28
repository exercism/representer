require "test_helper"

# Tests Rosetta as a whole on D solutions. The tests of each stage are in
# test/languages/d/.
class DTest < RosettaTest
  track "d"

  def test_comments_layout_and_imports_go
    assert_same_representation "module leap;\nbool isLeap(int year) { return year % 4 == 0; }",
                               "module leap;\nimport std.stdio;\n// A leap year\nbool isLeap(int year)\n{\n" \
                               "    import std.math : abs;\n    return year % 4 == 0; /* done */\n}\n"
  end

  def test_names_the_solution_defines_are_renamed
    code = "module %s;\nstruct %s { int %s; }\nint %s(%s[] %s) { int %s = 0; foreach (%s; %s) %s += %s.%s; return %s; }"
    assert_same_representation format(code, "leap", "Box", "n", "total", "Box", "xs", "sum", "x", "xs", "sum", "x", "n", "sum"),
                               format(code, "year", "Item", "m", "count", "Item", "ys", "acc", "y", "ys", "acc", "y", "m", "acc")
  end

  def test_names_from_the_library_keep_their_names
    refute_same_representation "int f(int[] xs) { return xs.maxElement; }", "int f(int[] xs) { return xs.minElement; }"
  end

  def test_numbers_and_strings_are_their_values
    assert_same_representation 'auto f() { return 1_000 ~ `a`; }', 'auto f() { return 1000 ~ "a"; }'
  end

  def test_syntax_errors_get_a_basic_representation_with_the_d_version
    assert_basic_representation "int f( { return; }"
  end
end
