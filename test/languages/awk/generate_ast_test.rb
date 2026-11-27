require_relative "stage_helper"

# Tests AWK's GenerateAST stage. Each assert_same pair gets the same tree
# from gawk's parser, and each refute_same pair gets different trees.
class AwkGenerateASTTest < Minitest::Test
  include AwkStages

  def test_layout_and_separators_make_no_difference
    assert_same "{ x = 1; y = 2 }", "{\n  x = 1\n  y = 2\n}"
    assert_same "{ x = 1;; }", "{ x = 1 }"
    assert_same "{ x = 1 + \\\n 2 }", "{ x = 1 + 2 }"
    assert_same "BEGIN { x = 1 }; END { print x }", "BEGIN { x = 1 }\nEND { print x }"
    assert_same "func f(a) { return a }", "function f(a) { return a }"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "{ x = (a * b) + c }", "{ x = a * b + c }"
    assert_same "{ x = $(NF) }", "{ x = $NF }"
    assert_same "{ if ((a)) print a }", "{ if (a) print a }"
    refute_same "{ x = (a + b) * c }", "{ x = a + b * c }"
    refute_same "{ x = $(i + 1) }", "{ x = $i + 1 }"
    refute_same "{ x = a (b c) }", "{ x = a b c }"
  end

  def test_print_reads_its_arguments_with_or_without_brackets
    assert_same '{ printf("%s\n", $1) }', '{ printf "%s\n", $1 }'
    assert_same "{ print(a, b) }", "{ print a, b }"
    refute_same "{ print a, b }", "{ print a b }"
    refute_same '{ print a > "f" }', '{ print (a > "f") }'
  end

  def test_a_block_is_its_statements
    assert_same "{ if (x) { y = 1 } }", "{ if (x) y = 1 }"
    assert_same "{ if (x) y = 1; else { if (z) w = 2 } }", "{ if (x) y = 1; else if (z) w = 2 }"
    assert_same "{ while (x) { x-- } }", "{ while (x) x-- }"
    assert_same "{ a = 1; { b = 2 } }", "{ a = 1; b = 2 }"
    refute_same "{ if (x) { y = 1; z = 2 } }", "{ if (x) y = 1; z = 2 }"
    refute_same "/x/", "/x/ {}"
  end

  def test_the_parts_of_a_for_loop_stay_in_place
    refute_same "{ for (;i < 3;) x++ }", "{ for (i < 3;;) x++ }"
    refute_same "{ for (;;i++) x++ }", "{ for (i++;;) x++ }"
  end

  def test_strings_are_written_as_their_values
    assert_same '{ x = "a\\tb" }', "{ x = \"a\tb\" }"
    refute_same '{ x = "a\\101" }', '{ x = "aA" }'
    refute_same '{ x = "1" }', "{ x = 1 }"
    refute_same '{ if ($0 ~ "a") print }', "{ if ($0 ~ /a/) print }"
  end

  def test_numbers_are_written_as_their_values
    assert_same "{ x = 1.0 }", "{ x = 1 }"
    assert_same "{ x = 0x1F }", "{ x = 31 }"
    assert_same "{ x = 011 }", "{ x = 9 }"
    assert_same "{ x = 1e3 }", "{ x = 1000 }"
    refute_same "{ x = 011 }", "{ x = 11 }"
  end

  def test_length_reads_the_same_with_or_without_brackets
    assert_same "{ print length }", "{ print length() }"
    refute_same "{ print length }", "{ print length($1) }"
  end

  def test_regular_expressions_keep_their_text
    refute_same "/a+/", "/a*/"
    refute_same "/(a|b)/", "/a|b/"
  end

  private
  def ast(source) = write(generate_ast(source))

  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
