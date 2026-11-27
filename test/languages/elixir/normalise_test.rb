require_relative "stage_helper"

# Tests Elixir's Normalise stage, which keeps three rules of the old
# representer and moves each spec into its function.
class ElixirNormaliseTest < Minitest::Test
  include ElixirStages

  def test_drops_documentation
    assert_same "@moduledoc \"m\"\n@doc \"\"\"\nd\n\"\"\"\n@typedoc \"t\"\ndef f, do: 1", "def f, do: 1"
    assert_same "@doc false\ndef f, do: 1", "def f, do: 1"
    refute_same "@deprecated \"d\"\ndef f, do: 1", "def f, do: 1"
  end

  def test_a_spec_moves_into_the_function_after_it
    assert_includes tree("@spec f() :: integer\ndef f, do: 1"), "(do_block 1)\n    (unary_operator @"
    assert_includes tree("def f, do: 1\n@spec g() :: integer"), "(do_block 1))\n  (unary_operator @"
  end

  def test_a_pipe_into_a_name_calls_it
    assert_same "x |> f", "x |> f()"
    assert_same "x |> String.upcase", "x |> String.upcase()"
    refute_same "x |> f(1)", "x |> f()"
  end

  def test_types_lose_empty_brackets
    assert_same "@spec f(integer()) :: String.t()", "@spec f(integer) :: String.t"
    assert_same "@type t() :: atom()", "@type t :: atom"
    refute_same "x = integer()", "x = integer"
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
