require_relative "stage_helper"

# Tests Prolog's GenerateAST stage. Each assert_same pair has the same
# meaning in Prolog, and each refute_same pair has different meanings.
class PrologGenerateASTTest < Minitest::Test
  include PrologStages

  def test_layout_makes_no_difference
    assert_same "f(X) :-\n    Y is X + 1,\n    g(Y).\n", "f( X ):-Y is X+1,g(Y)."
  end

  def test_brackets_that_only_group_are_dropped
    assert_same "f(X) :- (X > 1 -> true ; false).", "f(X) :- X > 1 -> true ; false."
    refute_same "f(X, Y) :- Y is (X + 1) * 2.", "f(X, Y) :- Y is X + 1 * 2."
    refute_same "f(X, Y) :- Y is X - (1 - 2).", "f(X, Y) :- Y is X - 1 - 2."
  end

  def test_a_conjunction_in_brackets_stays_one_argument
    refute_same "f :- g((a, b)).", "f :- g(a, b)."
  end

  def test_operators_stay_apart
    refute_same "f(X) :- X =:= 1.", "f(X) :- X == 1."
    refute_same "f(X) :- X = 1.", "f(X) :- X is 1."
    refute_same "f(X) :- \\+ g(X).", "f(X) :- g(X)."
    refute_same "f(X) :- a, b.", "f(X) :- a ; b."
  end

  def test_a_negative_number_stays_apart_from_negation
    refute_same "f(-1).", "f(- 1)."
    assert_same "f(- 1).", "f(-(1))."
  end

  def test_numbers_are_their_values
    assert_same "f(X) :- X is 0x1F + 0b11 + 0o7 + 1_000.", "f(X) :- X is 31 + 3 + 7 + 1000."
    assert_same "f(1.0e3).", "f(1000.0)."
    refute_same "f(1).", "f(1.0)."
    refute_same "f(100).", "f(1000)."
  end

  def test_a_character_code_is_its_integer
    assert_same "f(0'a).", "f(97)."
    assert_same "f(0' ).", "f(32)."
    assert_same "f(0'\\n).", "f(10)."
    assert_same "f(0''').", "f(39)."
    refute_same "f(0'a).", "f(0'b)."
  end

  def test_strings_are_their_values
    assert_equal ["a\tb\n"], literals('f("a\\tb\\n").')
    assert_same 'f("say ""hi""").', 'f("say \\"hi\\"").'
    refute_same 'f("a").', 'f("b").'
    refute_same 'f("a").', "f(a)."
    refute_same 'f("a").', "f(`a`)."
  end

  def test_an_escape_the_stage_does_not_read_stays_apart_from_its_text
    refute_same 'f("\\x41\\").', 'f("\\\\x41\\\\").'
  end

  def test_a_quoted_atom_is_the_atom
    assert_same "f('ok').", "f(ok)."
    refute_same "f('hello world').", "f(hello)."
    refute_same "f('Ok').", "f(ok)."
    refute_same "f('[]').", "f([])."
  end

  def test_empty_lists_and_braces_are_atoms
    assert_same "f([ ], { }).", "f([], {})."
  end

  def test_a_list_with_a_list_as_its_tail_is_one_list
    assert_same "f([a|[b, c]]).", "f([a, b, c])."
    assert_same "f([a|[]]).", "f([a])."
    refute_same "f([a|T]).", "f([a, T])."
  end

  def test_wildcards_stay_apart_from_variables
    refute_same "f(_).", "f(X)."
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
