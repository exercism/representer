require_relative "stage_helper"

# Tests Erlang's GenerateAST stage. Each assert_same pair has the same
# meaning in Erlang, and each refute_same pair has different meanings.
class ErlangGenerateASTTest < Minitest::Test
  include ErlangStages

  def test_layout_makes_no_difference
    assert_same in_module("f(X) ->\n    Y = X + 1,\n    Y."), in_module("f( X )->Y=X+1,Y.")
  end

  def test_behavior_is_the_same_as_behaviour
    assert_same "-module(a).\n-behavior(gen_server).\n", "-module(a).\n-behaviour(gen_server).\n"
  end

  def test_brackets_that_only_group_are_dropped
    assert_same in_module("f(X) -> (X + 1)."), in_module("f(X) -> X + 1.")
    refute_same in_module("f(X) -> (X + 1) * 2."), in_module("f(X) -> X + 1 * 2.")
    refute_same in_module("f(X) -> X - (1 - 2)."), in_module("f(X) -> X - 1 - 2.")
  end

  def test_the_clauses_of_a_function_go_together
    function = generate_ast(in_module("f(0) -> 1;\nf(N) -> N.")).children.last
    assert_equal "function", function.type
    assert_equal %w[function_clause function_clause], function.children.map(&:type)
  end

  def test_guards_keep_their_and_and_or
    refute_same in_module("f(X) when X > 0, X < 9 -> X."), in_module("f(X) when X > 0; X < 9 -> X.")
  end

  def test_operators_stay_apart
    refute_same in_module("f(X) -> X - 1."), in_module("f(X) -> X + 1.")
    refute_same in_module("f(X) -> -X."), in_module("f(X) -> X.")
    refute_same in_module("f(X) -> X / 2."), in_module("f(X) -> X div 2.")
    refute_same in_module("f(M) -> M\#{a => 1}."), in_module("f(M) -> M\#{a := 1}.")
  end

  def test_numbers_are_their_values
    assert_same in_module("f(_) -> 16#FF + 2#11 + 1_000."), in_module("f(_) -> 255 + 3 + 1000.")
    assert_same in_module("f(_) -> 1.0e3."), in_module("f(_) -> 1000.0.")
    refute_same in_module("f(_) -> 1."), in_module("f(_) -> 1.0.")
    refute_same in_module("f(_) -> 100."), in_module("f(_) -> 1000.")
  end

  def test_strings_are_their_values
    assert_equal ["a\tb\n"], literals(in_module('f(_) -> "a\\tb\\n".'))
    assert_same in_module('f(_) -> "a" "b".'), in_module('f(_) -> "ab".')
    refute_same in_module('f(_) -> "a".'), in_module('f(_) -> "b".')
    refute_same in_module('f(_) -> "a".'), in_module("f(_) -> a.")
    refute_same in_module('f(_) -> "a".'), in_module("f(_) -> $a.")
  end

  def test_an_escape_the_stage_does_not_read_stays_apart_from_its_text
    refute_same in_module('f(_) -> "\\101".'), in_module('f(_) -> "\\\\101".')
  end

  def test_a_quoted_atom_is_the_atom
    assert_same in_module("f(_) -> 'ok'."), in_module("f(_) -> ok.")
    refute_same in_module("f(_) -> 'hello world'."), in_module("f(_) -> hello.")
    refute_same in_module("f(_) -> 'Ok'."), in_module("f(_) -> ok.")
  end

  def test_wildcards_stay_apart_from_variables
    refute_same in_module("f(_) -> 1."), in_module("f(X) -> 1.")
  end

  private
  def literals(source)
    values = []
    generate_ast(source).each_descendant { |node| values << node.text if node.quoted }
    values
  end

  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
