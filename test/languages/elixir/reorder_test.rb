require_relative "stage_helper"

# Tests Elixir's Reorder stage, through Inspector as a whole, because it
# sorts by the code with the renamed names left out.
class ElixirReorderTest < InspectorTest
  track "elixir"

  def wrap(body) = "defmodule M do\n  def f(x) do\n    #{body}\n  end\nend\n"

  def test_sorts_the_code_in_a_module
    assert_same_representation "defmodule M do\n  use B\n  use A\nend", "defmodule M do\n  use A\n  use B\nend"
    assert_same_representation "defmodule M do\n  def a, do: 1\n  def b(x), do: x\nend",
      "defmodule M do\n  def b(y), do: y\n  def a, do: 1\nend"
  end

  def test_a_spec_moves_with_its_function
    refute_same_representation "defmodule M do\n  @spec a() :: integer\n  def a, do: 1\n  def b, do: :b\nend",
      "defmodule M do\n  def a, do: 1\n  @spec b() :: integer\n  def b, do: :b\nend"
    assert_same_representation "defmodule M do\n  @spec a() :: integer\n  def a, do: 1\n  def b, do: :b\nend",
      "defmodule M do\n  def b, do: :b\n  @spec a() :: integer\n  def a, do: 1\nend"
  end

  def test_keeps_the_order_of_a_function_body
    refute_same_representation wrap("a = 1\n    IO.puts(a)"), wrap("IO.puts(a)\n    a = 1")
  end

  def test_sorts_maps_and_structs
    assert_same_representation wrap("%{b: 1, a: x}"), wrap("%{a: x, b: 1}")
    assert_same_representation wrap('%{"b" => 1, "a" => 2}'), wrap('%{"a" => 2, "b" => 1}')
    assert_same_representation wrap("%User{b: 1, a: 2}"), wrap("%User{a: 2, b: 1}")
    assert_same_representation wrap("%{x | b: 1, a: 2}"), wrap("%{x | a: 2, b: 1}")
  end

  def test_keeps_the_order_of_lists
    refute_same_representation wrap("[b: 1, a: 2]"), wrap("[a: 2, b: 1]")
  end

  def test_the_order_ignores_renamed_names
    assert_same_representation "defmodule M do\n  def f(a, b), do: %{a => 1, b => 2}\nend",
      "defmodule M do\n  def f(z, y), do: %{z => 1, y => 2}\nend"
  end
end
