require_relative "stage_helper"

# Tests Red's GenerateAST stage. Each assert_same pair has the same meaning
# in Red, and each refute_same pair has different meanings.
class RedGenerateASTTest < Minitest::Test
  include RedStages

  def test_keeps_every_block_and_paren
    refute_same "x: [a b]", "x: (a b)"
    refute_same "x: [a b]", "x: [a [b]]"
  end

  def test_numbers_are_their_values
    assert_same "x: 1'000 + 1.50", "x: 1000 + 1.5"
    refute_same "x: 1.0", "x: 1"
    refute_same "x: 50%", "x: 50"
  end

  def test_keeps_the_text_of_literals
    refute_same "x: #\"a\"", "x: #\"b\""
    refute_same "x: http://a.com", "x: http://b.com"
    refute_same "x: \#{FF}", "x: \#{00}"
    refute_same "x: {a}", "x: {b}"
  end

  def test_puts_the_word_of_each_set_word_and_path_start_in_a_word
    assert_includes ast("total: 0"), "(set_word total)"
    assert_includes ast("print obj/x"), "(path_start obj)"
  end

  def test_gives_each_function_spec_a_type_of_its_own
    assert_includes ast("f: func [a /local b] [b: a]"), "(function_spec a /local b)"
    refute_includes ast("f: does [a]"), "function_spec"
  end

  def test_marks_the_word_after_each_foreach_and_repeat
    assert_includes ast("foreach c \"ab\" [print c]"), "(loop_variable c)"
    assert_includes ast("f: does [repeat i 3 [print i]]"), "(loop_variable i)"
    refute_includes ast("foreach [k v] m [print k]"), "loop_variable"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
