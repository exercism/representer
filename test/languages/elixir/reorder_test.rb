require_relative "stage_helper"

# Tests Elixir's Reorder stage, through the whole representer, because it
# sorts by the code with the renamed names left out.
class ElixirReorderTest < RepresenterTest
  track "elixir"

  def wrap(body) = "defmodule M do\n  def f(x) do\n    #{body}\n  end\nend\n"

  def test_sorts_the_use_statements_at_the_start
    assert_same_representation "defmodule M do\n  use B\n  use A\nend", "defmodule M do\n  use A\n  use B\nend"
    refute_same_representation "defmodule M do\n  x = 1\n  use B\n  use A\nend", "defmodule M do\n  x = 1\n  use A\n  use B\nend"
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
