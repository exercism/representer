require "test_helper"

class FSharpTest < RepresenterTest
  extend UpstreamTests

  track "fsharp"

  DEVIATIONS = {
    "Lists" => {
      restore: { "placeholder_3" => "sum" },
      why: "The old representer renamed List.sum as well, because it renamed every use of a name. List.sum is a library " \
           "function, not the student's, so this representer keeps it."
    },
    "TypeDefinitionNotIndented" => {
      add: %w[Volume Liter USPint ImperialPint],
      why: "The old representer left type and union case names alone. This representer renames the ones the student " \
           "defines, as it does for functions."
    }
  }.freeze

  upstream_tests ".fs", deviations: DEVIATIONS

  def wrap(body) = "module M\n\n#{body}\n"

  def test_comments_and_opens_are_dropped
    assert_same_representation wrap("let f x = x"), wrap("open System\n// a\n(* b *)\n/// c\nlet f x = x")
  end

  def test_parentheses_that_only_group_are_dropped
    assert_same_representation wrap("let f x = (x)"), wrap("let f x = x")
    assert_same_representation wrap("let f (x) = x"), wrap("let f x = x")
    assert_same_representation wrap("let f x = g (x)"), wrap("let f x = g x")
    refute_same_representation wrap("let f a b c = (a + b) * c"), wrap("let f a b c = a + b * c")
  end

  def test_operators_are_written_one_way
    assert_same_representation wrap("let f a b = a + b"), wrap("let f a b = a   +   b")
    refute_same_representation wrap("let f a b = a + b"), wrap("let f a b = a - b")
    refute_same_representation wrap("let f a b = a <= b"), wrap("let f a b = a < b")
  end

  def test_strings_are_written_as_their_values
    assert_same_representation wrap('let s = "a"'), wrap('let s = """a"""')
    assert_same_representation wrap('let s = "a\\\\nb"'), wrap('let s = @"a\\nb"')
    assert_same_representation wrap('let s = "a\\u0041"'), wrap('let s = "aA"')
  end

  def test_different_strings_stay_apart
    refute_same_representation wrap('let s = "a"'), wrap('let s = "b"')
    refute_same_representation wrap('let s = "a\\qb"'), wrap('let s = "aqb"')
    refute_same_representation wrap('let s = "a\\nb"'), wrap('let s = @"a\\nb"')
  end

  def test_numbers_keep_their_values_and_types
    refute_same_representation wrap("let n = 1.5"), wrap("let n = 2.5")
    refute_same_representation wrap("let n = 1.0"), wrap("let n = 1.0f")
    refute_same_representation wrap("let n = 1.0"), wrap("let n = 1.0m")
  end

  def test_variables_and_parameters_are_renamed
    assert_same_representation wrap("let f a = let b = a + 1 in b"), wrap("let g x = let y = x + 1 in y")
    assert_same_representation wrap("let f = fun a b -> a"), wrap("let f = fun x y -> x")
    refute_same_representation wrap("let f a b = a"), wrap("let f a b = b")
  end

  def test_pattern_variables_are_renamed_and_union_cases_are_not
    code = "let f o = match o with | Some %s -> %s | None -> 0"
    assert_same_representation wrap(format(code, "x", "x")), wrap(format(code, "y", "y"))
    refute_same_representation wrap("let f o = match o with | Some x -> x | None -> 0"),
      wrap("let f o = match o with | Some x -> x | x -> 0")
  end

  def test_records_unions_and_members_are_renamed_everywhere
    record = "type R = { %s: int }\nlet f (r: R) = r.%s\nlet g = { %s = 1 }"
    assert_same_representation wrap(format(record, "A", "A", "A")), wrap(format(record, "B", "B", "B"))
    union = "type U = %s | Other\nlet f = %s"
    assert_same_representation wrap(format(union, "A", "A")), wrap(format(union, "B", "B"))
    cls = "type C(n: int) =\n    member this.%s = n\nlet f (c: C) = c.%s"
    assert_same_representation wrap(format(cls, "A", "A")), wrap(format(cls, "B", "B"))
  end

  def test_the_self_identifier_is_renamed
    code = "type C() =\n    member %s.A = 1"
    assert_same_representation wrap(format(code, "this")), wrap(format(code, "self"))
  end

  def test_functions_in_nested_modules_are_renamed_where_they_are_called
    code = "module N =\n    let %s x = x\nlet f = N.%s 1"
    assert_same_representation wrap(format(code, "a", "a")), wrap(format(code, "b", "b"))
  end

  def test_library_functions_after_a_dot_keep_their_names
    refute_same_representation wrap("let f xs = List.sum xs"), wrap("let f xs = List.max xs")
    refute_same_representation wrap("let sum xs = List.sum xs"), wrap("let sum xs = List.max xs")
  end

  def test_a_member_named_like_a_library_member_keeps_its_name
    code = "type C() =\n    member this.%s = 1"
    refute_same_representation wrap(format(code, "Length")), wrap(format(code, "Size"))
    assert_same_representation wrap(format(code, "Total")), wrap(format(code, "Amount"))
  end

  def test_names_the_tests_use_are_kept
    refute_same_representation wrap("let f x = x"), wrap("let g x = x"),
      exercise_files: { "Tests.fs" => "module T\nlet t = f 1\n" }
  end

  def test_syntax_errors_fall_back
    assert_falls_back "module M\nlet f = = =\n"
  end
end
