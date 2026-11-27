require "test_helper"

class ElixirTest < RepresenterTest
  extend UpstreamTests

  track "elixir"

  AS = "The engine drops every alias, so the name given with `as:` is never defined, and keeps its name.".freeze
  FIELDS = "Renaming goes by name, so a field with the name of something the solution defines, such as %s, gets " \
           "its placeholder. The old representer never renamed a field.".freeze

  DEVIATIONS = {
    "local_function_calls" => {
      replace: { "Enum.reverse" => "Enum.placeholder_4" },
      why: "Renaming goes by name, so Enum.reverse gets the placeholder of the solution's own function reverse."
    },
    "special_variables" => {
      restore: { "placeholder_6" => "some_value" },
      remove: ["some_value"],
      why: "The old representer renamed every variable it met, including one that the solution never defines. This " \
           "representer only renames names the solution defines, so some_value keeps its name."
    },
    "modules" => {
      restore: { "Placeholder_2" => "Two", "Placeholder_8" => "Eight", "Placeholder_12" => "Twelve",
                 "Placeholder_13" => "Thirteen" },
      remove: %w[Eight Twelve Thirteen Two],
      why: AS
    },
    "user_defined_structs" => { restore: { "Placeholder_4" => "Automobile" }, remove: %w[Automobile], why: AS },
    "import_order" => { remove: %w[Ba], why: AS },
    "maps" => {
      replace: { ".minute" => ".placeholder_6", ".hour" => ".placeholder_3" },
      why: format(FIELDS, "the variables minute and hour")
    },
    "macros_and_guards" => { replace: { ".first_name" => ".placeholder_2" }, why: format(FIELDS, "the function first_name") },
    "module_attributes" => {
      restore: {
        "placeholder_3" => "three", "placeholder_4" => "four", "placeholder_5" => "five", "placeholder_6" => "six",
        "placeholder_7" => "seven", "placeholder_8" => "eight", "placeholder_9" => "nine", "placeholder_10" => "ten",
        "placeholder_11" => "eleven", "placeholder_12" => "twelve", "placeholder_13" => "thirteen",
        "placeholder_15" => "fifteen", "placeholder_16" => "sixteen", "placeholder_17" => "seventeen",
        "placeholder_19" => "nineteen", "placeholder_20" => "twenty", "placeholder_21" => "twentyone",
        "placeholder_24" => "twentyfour", "placeholder_25" => "twentyfive"
      },
      replace: {
        "placeholder_22: 0" => "twentytwo: 0", "placeholder_23: 0" => "twentythree: 0", "placeholder_23: 1" => "twentythree: 1"
      },
      remove: %w[three four five six seven eight nine ten eleven twelve thirteen fifteen sixteen seventeen nineteen twenty
                 twentyone twentyfour twentyfive],
      why: "This fixture isn't valid code: it has specs for functions that it never defines, which doesn't compile. A " \
           "spec's name is renamed by the function's definition, so these keep their names, and so do the names " \
           "that label a spec's arguments and its type variables. The old representer also renamed a parametrised " \
           "type (three(four)), a callback's name, an attribute that is set but never read (twentyfour), and the " \
           "function names in `@optional_callbacks` and `@compile`. This representer counts an attribute as defined " \
           "only if the solution reads it, so that Elixir's own attributes (@impl, @behaviour) keep their names, " \
           "and the other names keep theirs because no golden solution defines them."
    }
  }.freeze

  upstream_tests ".ex", deviations: DEVIATIONS

  def wrap(body) = "defmodule M do\n  def f(x) do\n#{body}\n  end\nend\n"

  def test_alias_import_and_require_are_dropped_and_use_stays
    assert_same_representation wrap("    Enum.sum(x)"),
      "defmodule M do\n  alias Foo.Bar\n  require Logger\n  import Bitwise\n  def f(x) do\n    Enum.sum(x)\n  end\nend\n"
    assert_same_representation wrap("    x"), "defmodule M do\n  import :math, only: [pi: 0]\n  def f(x) do\n    x\n  end\nend\n"
    refute_same_representation wrap("    x"), "defmodule M do\n  use GenServer\n  def f(x) do\n    x\n  end\nend\n"
  end

  def test_an_alias_keeps_its_short_name
    refute_same_representation "defmodule M do\n  alias Foo.Bar\n  def f, do: Bar.x()\nend",
      "defmodule M do\n  def f, do: Foo.Bar.x()\nend"
  end

  def test_docs_and_comments_are_dropped
    assert_same_representation "defmodule M do\n  @moduledoc \"hi\"\n  # note\n  @doc \"d\"\n  def f(x), do: x\nend",
      "defmodule M do\n  def f(x), do: x\nend"
  end

  def test_solutions_that_only_name_things_differently_are_the_same
    assert_same_representation "defmodule M do\n  @a 1\n  def f(b), do: @a + b\nend",
      "defmodule N do\n  @c 1\n  def g(d), do: @c + d\nend"
  end

  def test_maps_are_sorted_and_keyword_lists_are_not
    assert_same_representation wrap("%{b: 1, a: 2}"), wrap("%{a: 2, b: 1}")
    refute_same_representation wrap("[b: 1, a: 2]"), wrap("[a: 2, b: 1]")
  end

  def test_syntax_errors_get_a_basic_representation
    assert_basic_representation "defmodule M do\n  def f(\nend"
  end
end
