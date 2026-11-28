require_relative "stage_helper"

# Tests Bash's GenerateAST stage. Each assert_same pair is the same program
# to Bash's parser, and each refute_same pair is a different program.
class BashGenerateASTTest < Minitest::Test
  include BashStages

  def test_layout_and_separators_make_no_difference
    assert_same "a; b", "a\nb"
    assert_same "if true; then a; fi", "if true\nthen\n  a\nfi"
    assert_same "for x in a b; do c; done", "for x in a b\ndo\n  c\ndone"
    assert_same "for ((i = 0; i < 3; i++)); do a; done", "for ((i=0;i<3;i++))\ndo a; done"
    assert_same "case $x in a) b ;; esac", "case $x in\n  (a)\n    b\n    ;;\nesac"
    refute_same "a; b", "a & b"
    refute_same "a && b", "a || b"
  end

  def test_the_spellings_of_a_function_are_the_same
    assert_same "f() { a; }", "function f { a; }"
    assert_same "f() { a; }", "function f() { a; }"
    refute_same "f() { a; }", "f() ( a )"
  end

  def test_the_spellings_of_a_command_substitution_are_the_same
    assert_same "x=$(date)", "x=`date`"
    assert_same "x=$((1 + 2))", "x=$[1 + 2]"
    refute_same "x=$(date)", "x=<(date)"
  end

  def test_the_keywords_that_change_a_loop_stay
    refute_same "while a; do b; done", "until a; do b; done"
    refute_same "for x in a; do b; done", "select x in a; do b; done"
    refute_same "[ $a == b ]", "[[ $a == b ]]"
    refute_same "{ a; }", "( a )"
    refute_same "{ a; }", "(( a ))"
  end

  def test_the_condition_of_an_if_stays_apart_from_its_body
    refute_same "if a; then b; c; fi", "if a; b; then c; fi"
    refute_same "if a; then b; elif c; then d; e; fi", "if a; then b; elif c; d; then e; fi"
  end

  def test_the_parts_of_a_for_loop_stay_in_place
    refute_same "for ((; i < 3;)); do a; done", "for ((i < 3;;)); do a; done"
    refute_same "for ((;; i++)); do a; done", "for ((i++;;)); do a; done"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "(( x = (a * b) + c ))", "(( x = a * b + c ))"
    refute_same "(( x = (a + b) * c ))", "(( x = a + b * c ))"
  end

  def test_strings_are_written_as_their_values
    assert_same "echo 'a b'", 'echo "a b"'
    assert_same "echo $'a\\tb'", "echo \"a\tb\""
    assert_same 'echo "say \\"hi\\""', %q(echo 'say "hi"')
    assert_same 'echo "\\$x"', "echo '$x'"
    assert_same "echo \"a\\\nb\"", 'echo "ab"'
    assert_same "echo ''", 'echo ""'
    refute_same 'echo "a\\b"', 'echo "ab"'
    refute_same "echo $'a\\x41'", 'echo "aA"'
    refute_same 'echo "$x"', "echo '$x'"
    refute_same 'echo "$x"', "echo $x"
    refute_same 'echo "a"', "echo a"
  end

  def test_numbers_in_arithmetic_are_written_as_their_values
    assert_same "(( x = 0x1F ))", "(( x = 31 ))"
    assert_same "(( x = 010 ))", "(( x = 8 ))"
    assert_same "(( x = 2#101 ))", "(( x = 5 ))"
    assert_same "echo ${s:01:2}", "echo ${s:1:2}"
    refute_same "x=010", "x=8"
    refute_same "echo 0x1F", "echo 31"
    refute_same 'echo $((10#$d))', 'echo $((11#$d))'
  end

  def test_text_the_grammar_leaves_out_is_kept
    refute_same '[[ "$x" =~ - ]]', '[[ "$x" =~ + ]]'
  end

  private
  def ast(source) = write(generate_ast(source))

  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
