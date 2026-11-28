require_relative "stage_helper"

# Tests YAMLScript's GenerateAST stage. Each assert_same pair compiles to
# the same Clojure, and each refute_same pair compiles to different Clojure.
class YAMLScriptGenerateASTTest < Minitest::Test
  include YAMLScriptStages

  def test_the_version_tags_are_the_same
    assert_equal write(YAMLScript::Common::GenerateAST.(parse("!YS-v0\nx =: 1\n"))),
                 write(YAMLScript::Common::GenerateAST.(parse("!yamlscript/v0\nx =: 1\n")))
  end

  def test_a_pair_a_call_and_a_list_are_the_same_call
    assert_same "f =: die('a')", "f =: (die 'a')"
    assert_same "defn f(x):\n  die: 'a'", "defn f(x):\n  =>: die('a')"
    assert_same "defn f(x):\n  pow 2: x - 1", "defn f(x):\n  pow: 2 (x - 1)"
    assert_same "defn f(x):\n  pow 2: x - 1", "defn f(x):\n  =>: pow(2 (x - 1))"
    refute_same "f =: (g)", "f =: g"
    refute_same "f =: g(h(x))", "f =: g(h x)"
  end

  def test_a_mapping_below_a_key_gives_one_argument_for_each_pair
    assert_same "defn f(x):\n  when x:\n    say: 'a'\n    say: 'b'", "defn f(x):\n  =>: when(x say('a') say('b'))"
  end

  def test_a_value_takes_the_place_of_each_underscore_in_the_key
    assert_same "defn f(xs):\n  filter _ xs: odd?", "defn f(xs):\n  =>: filter(odd? xs)"
  end

  def test_an_arrow_key_gives_its_value
    assert_same "defn f(x):\n  =>: x", "defn f(x): x"
  end

  def test_a_key_that_ends_with_an_operator_puts_it_before_the_value
    assert_same "defn f(x):\n  (x > 1) ||:\n    die: 'a'", "defn f(x):\n  =>: (x > 1) || die('a')"
  end

  def test_a_value_that_starts_with_a_method_call_calls_it_on_the_key
    assert_same "defn f(x):\n  uc(x):\n    .split()\n    .first()", "defn f(x):\n  =>: uc(x).split().first()"
  end

  def test_postfix_operators_and_colon_calls_are_method_calls
    assert_same "f =: x.#", "f =: x.count()"
    assert_same "f =: x.++", "f =: x.inc()"
    assert_same "f =: x:g", "f =: x.g()"
    refute_same "f =: x.g", "f =: x.g()"
  end

  def test_the_clauses_of_cond_are_tests_and_results
    assert_same "defn f(x):\n  cond:\n    x: 1\n    else: 2", "defn f(x):\n  cond:\n    x: 1\n    =>: 2"
    assert_same "defn f(x):\n  cond:\n    x: 1\n    else: 2", "defn f(x):\n  =>: cond(x 1 :else 2)"
    refute_same "defn f(x):\n  cond:\n    a: b\n    c: d", "defn f(x):\n  =>: cond((a b) (c d))"
  end

  def test_then_and_else_give_their_forms
    assert_same "defn f(x):\n  if x:\n    then: 1\n    else: 2", "defn f(x):\n  if x 1: 2"
  end

  def test_the_words_after_a_binding_form_are_one_vector
    assert_same "defn f(x):\n  loop i 0:\n    recur: i", "defn f(x):\n  loop [i 0]:\n    recur: i"
  end

  def test_the_words_after_a_test_form_are_one_test
    refute_same "defn f(x):\n  when a b c:\n    d", "defn f(x):\n  =>: when(a b c d)"
  end

  def test_a_chain_of_one_operator_is_one_expression
    assert_same "f =: 1 <= x <= 3", "f =: (1 <= x <= 3)"
    refute_same "f =: (x + 1) + 2", "f =: x + 1 + 2"
    refute_same "f =: (+ x 1)", "f =: x + 1"
  end

  def test_strings_are_their_values
    assert_equal ["It's"], literals("f =: 'It''s'")
    assert_same "f =: 'a'", 'f =: "a"'
    assert_same "f =: \"a\\\"b\"", "f =: 'a\"b'"
    refute_same "f =: 'a\\nb'", "f =: \"a\\nb\""
  end

  def test_an_interpolated_string_stays_apart_from_a_plain_one
    refute_same "f =: \"a $x\"", "f =: 'a $x'"
    assert_same "f =: \"a $1\"", "f =: 'a $1'"
  end

  def test_numbers_are_their_values
    assert_same "f =: 017", "f =: 15"
    assert_same "f =: 0.90", "f =: 0.9"
    refute_same "f =: 1", "f =: 1.0"
  end

  def test_data_after_a_double_colon_stays_data
    refute_same "defn f(x)::\n  a: x", "defn f(x):\n  a: x"
  end

  private
  def literals(source)
    values = []
    generate_ast(source).each_descendant { |node| values << node.text if node.quoted }
    values
  end

  def assert_same(one, other) = assert_equal(write(generate_ast(one)), write(generate_ast(other)))

  def refute_same(one, other) = refute_equal(write(generate_ast(one)), write(generate_ast(other)))
end
