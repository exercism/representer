require "test_helper"

# Ported from exercism/nim-representer: its golden test (example-two-fer), the
# end-to-end tests in tests/tnormalizations.nim ("All the things", "No params,
# return type or statements", "Just one let statement", "All features" and the
# two fmt tests) and the name tests in tests/tmapping.nim (see
# test_names_ignore_case_after_the_first_letter). The old tests compared the
# printed code, so each equivalent.nim is the old expected output.
#
# Differences from the old tests:
#
# - The old representer left type sections as written. This one renames the
#   types, fields and enum values that the student defines, so all-features
#   also maps `Dollar` (see its deviation).
# - The old unit tests only counted the names in all-features, so its
#   expected mapping lists the names found in the input and its equivalent.nim
#   was written by hand.

class NimTest < RepresenterTest
  extend UpstreamTests

  track "nim"

  DEVIATIONS = {
    "all-features" => {
      add: ["Dollar"],
      why: "The old representer left type sections as written, so it didn't rename the type Dollar. This one renames it."
    }
  }.freeze

  upstream_tests ".nim", deviations: DEVIATIONS

  def wrap(body) = "proc f(x: int, y: int): int =\n#{body.gsub(/^/, '  ')}\n"

  ### Formatting ###

  def test_comments_are_dropped
    assert_same_representation "# one\nproc f(x: int): int =\n  ## doc\n  #[ block ]#\n  x\n", "proc f(x: int): int =\n  x\n"
  end

  def test_brackets_commas_and_semicolons
    assert_same_representation "proc f(a: int; b: int): int = a + (b)", "proc f(a: int, b: int): int = a + b"
    assert_same_representation "echo(1, 2,)", "echo 1, 2"
  end

  def test_numbers_with_underscores
    assert_same_representation wrap("1_000"), wrap("1000")
    refute_same_representation wrap("1000"), wrap("100")
  end

  def test_parameters_that_share_a_type
    assert_same_representation "proc f(a, b: int): int = a", "proc f(a: int, b: int): int = a"
    refute_same_representation "proc f(a, b: int): int = a", "proc f(a: int, b: string): int = a"
  end

  def test_a_proc_without_parentheses
    assert_same_representation "proc f = discard", "proc f() = discard"
  end

  ### Operators ###

  def test_operators_are_calls
    assert_same_representation wrap("x + y"), wrap("`+`(x, y)")
    assert_same_representation wrap("not (x == y)"), wrap("`not`(`==`(x, y))")
    assert_same_representation wrap("-x"), wrap("`-`(x)")
    refute_same_representation wrap("x + y"), wrap("x - y")
    refute_same_representation wrap("-x"), wrap("x - y")
  end

  def test_commands_are_calls
    assert_same_representation "echo \"a\", 1", "echo(\"a\", 1)"
  end

  def test_defined_operators_are_not_renamed
    refute_same_representation "proc `+`(a, b: int): int = a", "proc `-`(a, b: int): int = a"
  end

  ### Strings ###

  def test_fmt_strings
    assert_same_representation wrap("fmt\"{x} and {y}\""), wrap("&\"{x} and {y}\"")
    assert_same_representation wrap("fmt\"{x:>3}\""), wrap("fmt\"{x:>3}\"")
    refute_same_representation wrap("fmt\"{x}\""), wrap("fmt\"{y}\"")
    refute_same_representation wrap("fmt\"{x:>3}\""), wrap("fmt\"{x:<3}\"")
  end

  def test_names_in_fmt_strings_are_renamed
    assert_same_representation "proc f(name: string): string = fmt\"hi {name}\"", "proc g(who: string): string = fmt\"hi {who}\""
    assert_same_representation "proc f(n: string): string = fmt\"{{n}} {n.len}\"", "proc g(m: string): string = fmt\"{{n}} {m.len}\""
  end

  ### Imports ###

  def test_imports_are_sorted
    assert_same_representation "import strutils, algorithm", "import algorithm, strutils"
    assert_same_representation "import std/[strutils, sequtils]", "import std/[sequtils, strutils]"
    assert_same_representation "from strutils import split, join", "from strutils import join, split"
    refute_same_representation "import strutils", "import sequtils"
  end

  ### Names ###

  def test_names_ignore_case_after_the_first_letter
    assert_same_representation "proc hello_world(a: int): int = a\necho helloWorld(1)",
      "proc helloworld(a: int): int = a\necho hELLOWORLD(1)"
    refute_same_representation "echo Hello(1)", "echo hello(1)"
    assert_same_representation "echo toUpper(\"a\")", "echo to_upper(\"a\")"
    refute_same_representation "echo toUpper(\"a\")", "echo toLower(\"a\")"
  end

  def test_the_mapping_keeps_the_first_spelling
    assert_equal %w[helloWorld a], represent("proc helloWorld(a: int): int = a\necho hello_WORLD(1)").mapping.values
  end

  def test_defined_names_are_renamed
    assert_same_representation "let a = 1\nvar b = a", "let c = 1\nvar d = c"
    assert_same_representation "for i in 1..3: echo i", "for j in 1..3: echo j"
    assert_same_representation "type Dollar = object\n  amount: int", "type Euro = object\n  value: int"
    assert_same_representation "type Color = enum red, green", "type Hue = enum cold, warm"
    assert_same_representation "let (a, b) = (1, 2)\necho a + b", "let (c, d) = (1, 2)\necho c + d"
  end

  def test_named_arguments_follow_the_parameters
    assert_same_representation "proc f(name: int): int = name\necho f(name = 1)", "proc f(who: int): int = who\necho f(who = 1)"
  end

  def test_fields_and_methods_after_a_dot
    assert_same_representation "type P = object\n  size: int\nlet p = P(size: 1)\necho p.size",
      "type P = object\n  width: int\nlet p = P(width: 1)\necho p.width"
    refute_same_representation "echo p.size", "echo p.width"
  end

  def test_core_names_are_kept
    refute_same_representation "proc sum(a: seq[int]): int = a.sum", "proc max(a: seq[int]): int = a.max"
    refute_same_representation "proc f(a: seq[int]): int = a.len", "proc f(a: seq[int]): int = a.high"
    refute_same_representation "proc f(): int = result", "proc f(): int = 1"
  end

  def test_names_the_tests_use_are_kept
    tests = { "f_test.nim" => "import f\ncheck twoFer() == 1" }
    refute_same_representation "proc twoFer(): int = 1", "proc other(): int = 1", exercise_files: tests
    assert_equal({}, represent("proc twoFer(): int = 1", exercise_files: tests).mapping)
  end

  ### Fallback ###

  def test_syntax_errors_fall_back
    assert_falls_back "proc f( =\n"
  end
end
