require "test_helper"

class ElixirTest < RepresenterTest
  extend UpstreamTests

  track "elixir"

  DEVIATIONS = {
    "local_function_calls" => {
      restore: { "placeholder_4" => "reverse" },
      remove: ["reverse"],
      why: "reverse is a library function name (Enum.reverse), so a function the student calls reverse keeps its name."
    },
    "special_variables" => {
      restore: { "placeholder_6" => "some_value" },
      remove: ["some_value"],
      why: "The old representer renamed every variable it met, including one that the solution never defines. This " \
           "representer only renames names the solution defines, so some_value keeps its name."
    },
    "modules" => {
      why: "The old representer left the function name in Five.External.Seven.nine(), because the module isn't " \
           "defined in the file. This representer renames nine wherever the solution defines a function called nine " \
           "in one of its own modules, so the equivalent has the placeholder. It also sorts the names in an alias " \
           "group without looking at names that the solution defines, so the group {Ten, Eleven} stays in its order " \
           "and the equivalent has it in that order, not sorted by the old names."
    },
    "module_attributes" => {
      restore: {
        "placeholder_6" => "six", "placeholder_8" => "eight", "placeholder_9" => "nine", "placeholder_11" => "eleven",
        "placeholder_19" => "nineteen", "placeholder_20" => "twenty", "placeholder_21" => "twentyone"
      },
      remove: %w[six eight nine eleven nineteen twenty twentyone],
      why: "The old representer renamed the type variables in a spec's `when` list, and the names that label the " \
           "arguments of a spec or a callback. This representer leaves them, because a spec's variables are part of " \
           "the signature and never name anything in the code. It also renames the type integer, because the " \
           "solution has a variable called integer and renaming goes by name, so the equivalent has the placeholder " \
           "wherever it has integer."
    }
  }.freeze

  upstream_tests ".ex", deviations: DEVIATIONS

  def wrap(body) = "defmodule M do\n  def f(x) do\n#{body}\n  end\nend\n"

  ### do: and do ... end ###

  def test_do_keyword_is_do_block
    assert_same_representation "defmodule M do\n  def f(x), do: x + 1\nend", "defmodule M do\n  def f(x) do\n    x + 1\n  end\nend"
    assert_same_representation "defmodule M, do: nil", "defmodule M do\n  nil\nend"
  end

  def test_if_with_do_and_else_keywords
    assert_same_representation wrap("if x, do: 1, else: 2"), wrap("if x do\n 1\n else\n 2\n end")
    assert_same_representation wrap("if x, else: 2, do: 1"), wrap("if x do\n 1\n else\n 2\n end")
    assert_same_representation wrap("unless x, do: 1"), wrap("unless x do\n 1\n end")
  end

  def test_do_keyword_with_other_keywords_keeps_them
    assert_same_representation wrap("for a <- x, into: %{}, do: {a, a}"), wrap("for a <- x, into: %{} do\n {a, a}\n end")
    refute_same_representation wrap("for a <- x, into: %{}, do: {a, a}"), wrap("for a <- x do\n {a, a}\n end")
  end

  def test_else_branch_stays_apart_from_do_branch
    refute_same_representation wrap("if x, do: 1, else: 2"), wrap("if x, do: 2, else: 1")
  end

  ### Spelling ###

  def test_parentheses_around_arguments
    assert_same_representation wrap("IO.puts x"), wrap("IO.puts(x)")
    refute_same_representation wrap("foo()"), wrap("foo")
  end

  def test_pipes_with_and_without_parentheses
    assert_same_representation wrap("x |> String.upcase"), wrap("x |> String.upcase()")
    assert_same_representation wrap("x |> Enum.map(&(&1))"), wrap("x |> Enum.map(&(&1))")
  end

  def test_strings
    assert_same_representation wrap('"a\\nb"'), wrap('"a\\u000Ab"')
    refute_same_representation wrap('"a"'), wrap('"b"')
    assert_same_representation wrap("\"a \#{x} b\""), wrap("\"a \#{x} b\"")
    refute_same_representation wrap("\"a \#{x} b\""), wrap("\"a \#{y} b\"")
  end

  def test_docs_and_comments_are_dropped
    assert_same_representation "defmodule M do\n  @moduledoc \"hi\"\n  # note\n  @doc \"d\"\n  def f(x), do: x\nend",
      "defmodule M do\n  def f(x), do: x\nend"
  end

  def test_map_keys_are_sorted_but_keyword_lists_are_not
    assert_same_representation wrap("%{b: 1, a: 2}"), wrap("%{a: 2, b: 1}")
    assert_same_representation wrap('%{"b" => 1, "a" => 2}'), wrap('%{"a" => 2, "b" => 1}')
    assert_same_representation wrap("%{m | b: 1, a: 2}"), wrap("%{m | a: 2, b: 1}")
    refute_same_representation wrap("[b: 1, a: 2]"), wrap("[a: 2, b: 1]")
  end

  def test_imports_at_the_start_are_sorted
    assert_same_representation "defmodule M do\n  import B\n  alias A\n  require C\n  use D\nend",
      "defmodule M do\n  use D\n  alias A\n  require C\n  import B\nend"
  end

  def test_grouped_alias_names_are_sorted
    assert_same_representation "defmodule M do\n  alias X.{B, A}\nend", "defmodule M do\n  alias X.{A, B}\nend"
  end

  def test_types_have_no_parentheses
    assert_same_representation "defmodule M do\n  @type t :: integer()\nend", "defmodule M do\n  @type t :: integer\nend"
    refute_same_representation "defmodule M do\n  @type t :: String.t()\nend", "defmodule M do\n  @type t :: String.t\nend"
  end

  ### Names ###

  def test_variables_and_functions_are_renamed
    assert_same_representation "defmodule M do\n  def f(a), do: a\nend", "defmodule N do\n  def g(b), do: b\nend"
  end

  def test_pattern_variables_are_renamed
    assert_same_representation wrap("{:ok, v} = x\n v"), wrap("{:ok, w} = x\n w")
    assert_same_representation wrap("case x do\n [h | t] -> h\n end"), wrap("case x do\n [a | b] -> a\n end")
    assert_same_representation wrap("fn a, b -> a + b end"), wrap("fn c, d -> c + d end")
  end

  def test_pinned_variables_are_not_new_names
    refute_same_representation wrap("y = 1\n ^y = x"), wrap("y = 1\n z = x")
  end

  def test_names_that_are_not_defined_are_kept
    refute_same_representation wrap("foo(x)"), wrap("bar(x)")
    refute_same_representation wrap("Enum.map(x, &(&1))"), wrap("Enum.each(x, &(&1))")
  end

  def test_a_function_named_like_a_library_function_keeps_its_name
    code = "defmodule M do\n  def %s(x), do: x\nend"
    refute_same_representation format(code, "map"), format(code, "each")
    assert_same_representation format(code, "foo"), format(code, "bar")
  end

  def test_fields_of_a_variable_are_not_function_names
    code = "defmodule M do\n  def %s(u), do: 1\n  def g(u), do: u.name\nend"
    assert_same_representation format(code, "name"), format(code, "other")
    refute_same_representation format(code, "name"), format(code, "other").sub("u.name", "u.age")
  end

  def test_module_attributes_are_renamed
    assert_same_representation "defmodule M do\n  @a 1\n  def f, do: @a\nend", "defmodule M do\n  @b 1\n  def f, do: @b\nend"
  end

  def test_module_and_alias_names
    assert_same_representation "defmodule A.B do\n  alias A.B, as: C\n  def f, do: C.f()\nend",
      "defmodule X.Y do\n  alias X.Y, as: Z\n  def f, do: Z.f()\nend"
    refute_same_representation "defmodule M do\n  def f, do: Foo.f()\nend", "defmodule M do\n  def f, do: Bar.f()\nend"
  end

  def test_names_the_tests_use_are_kept
    refute_same_representation "defmodule M do\n  def f(x), do: x\nend", "defmodule M do\n  def g(x), do: x\nend",
      exercise_files: { "m_test.exs" => "defmodule MTest do\n  test \"a\" do\n    assert M.f(1) == 1\n  end\nend" }
  end

  def test_syntax_errors_fall_back
    assert_falls_back "defmodule M do\n  def f(\nend"
  end
end
