require_relative "stage_helper"

# Tests Elixir's GenerateAST stage. Each assert_same pair gets the same tree
# from Elixir's parser (`Code.string_to_quoted`, ignoring metadata such as
# line numbers), and each refute_same pair gets different trees. The last
# test lists the pairs where this stage deliberately differs from the parser.
class ElixirGenerateASTTest < Minitest::Test
  include ElixirStages

  def test_drops_comments_layout_and_grouping_brackets
    assert_same "x = 1 # one\n\n", "x = 1"
    assert_same "a\nb", "a; b"
    assert_same "x = (1 + 2)", "x = 1 + 2"
    refute_same "x = (a + b) * c", "x = a + b * c"
  end

  def test_brackets_around_arguments
    assert_same "IO.puts(x)", "IO.puts x"
    assert_same "Mod.f()", "Mod.f"
    assert_same "x.f()", "x.f"
    refute_same "f()", "f"
    refute_same "f.()", "f"
  end

  def test_do_keywords_are_do_blocks
    assert_same "def f(x), do: x + 1", "def f(x) do\n  x + 1\nend"
    assert_same "defmodule M, do: nil", "defmodule M do\n  nil\nend"
    assert_same "if x, do: 1, else: 2", "if x do\n  1\nelse\n  2\nend"
    assert_same "if x, else: 2, do: 1", "if x do\n  1\nelse\n  2\nend"
    assert_same "def f(x), do: (a; b)", "def f(x) do\n  a\n  b\nend"
    assert_same "for a <- x, into: %{}, do: {a, a}", "for a <- x, into: %{} do\n  {a, a}\nend"
    refute_same "for a <- x, into: %{}, do: a", "for a <- x do\n  a\nend"
    refute_same "if x, do: 1, else: 2", "if x, do: 2, else: 1"
  end

  def test_keyword_lists_and_maps
    assert_same "x = [a: 1]", "x = [{:a, 1}]"
    assert_same "x = %{a: 1}", "x = %{:a => 1}"
    assert_same "f(x, a: 1)", "f(x, [a: 1])"
    refute_same 'x = %{"a" => 1}', "x = %{a: 1}"
    refute_same "x = [a: 1]", "x = [a: 2]"
  end

  def test_atoms
    assert_same 'x = :"a"', "x = :a"
    refute_same 'x = :"a b"', "x = :a"
  end

  def test_numbers
    assert_same "x = 1_000 + 0x1F + 0b11 + 0o17", "x = 1000 + 31 + 3 + 15"
    assert_same "x = 1.50e1", "x = 15.0"
    assert_same "x = ?a + ?\\s", "x = 97 + 32"
    refute_same "x = 1.0", "x = 1"
  end

  def test_strings
    assert_same 'x = "a\\sb"', 'x = "a b"'
    assert_same "x = \"\"\"\n  a\n    b\n  \"\"\"", "x = \"a\\n  b\\n\""
    assert_same "x = \"\"\"\n  a \#{y}\n  \"\"\"", "x = \"a \#{y}\\n\""
    refute_same 'x = "a"', "x = 'a'"
    refute_same 'x = "\\x41"', 'x = "A"'
    assert_same "x = ''", "x = []"
  end

  def test_definitions_get_their_own_types
    assert_includes ast("defmodule A.B do\nend"), "(module_name A B)"
    assert_includes ast("def f(x) when x > 1, do: x"), "(function_head f"
    assert_includes ast("def f do\nend"), "(function_head f)"
    assert_includes ast("@type t :: integer"), "(type_definition t :: integer)"
    assert_includes ast("x = @a"), "(attribute a)"
  end

  def test_module_bodies_and_map_updates_get_their_own_types
    assert_includes ast("defmodule M do\n  def f, do: 1\nend"), "(module_body\n      (call def"
    assert_includes ast("defimpl P, for: M do\n  def f(_), do: 1\nend"), "(module_body"
    refute_includes ast("def f do\n  1\nend"), "module_body"
    assert_includes ast("%{x | a: 1}"), "(map_update"
  end

  def test_variables_bound_by_patterns
    assert_includes ast("{:ok, v} = x"), "(variable v)"
    assert_includes ast("for v <- x, do: v"), "(variable v)"
    assert_includes ast("fn v -> v end"), "(variable v)"
    assert_includes ast("def f(v \\\\ y), do: v"), "(variable v)"
    refute_includes ast("def f(v \\\\ y), do: v"), "(variable y)"
    refute_includes ast("^v = x"), "(variable v)"
    refute_includes ast("<<v::binary>> = x"), "(variable binary)"
    refute_includes ast("_ = x"), "(variable _)"
  end

  # Elixir's parser gives each of these pairs the same tree. No golden
  # solution writes either spelling, so this stage keeps them apart.
  def test_where_this_stage_differs_from_the_parser
    refute_same "x = 'ab'", "x = [97, 98]"
    refute_same "try(do: a, rescue: (e -> e))", "try do\n  a\nrescue\n  e -> e\nend"
    refute_same 'x = ["a b": 1]', 'x = [{:"a b", 1}]'
    refute_same 'x = "\\u0041"', 'x = "A"'
    refute_same "x = %{m | a: 1}", "x = %{m | :a => 1}"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
