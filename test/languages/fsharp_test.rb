require "test_helper"

class FSharpTest < InspectorTest
  extend UpstreamTests

  track "fsharp"

  DEVIATIONS = {
    "TypeDefinitionNotIndented" => {
      add: %w[Volume Liter USPint ImperialPint],
      why: "Inspector renames every name the solution defines, including type and " \
           "union case names."
    }
  }.freeze

  upstream_tests ".fs", deviations: DEVIATIONS

  def wrap(body) = "module M\n\n#{body}\n"

  def test_comments_and_opens_are_dropped
    assert_same_representation wrap("let f x = x"), wrap("open System\n// a\n(* b *)\n/// c\nlet f x = x")
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

  def test_a_member_named_like_a_library_member_is_renamed
    code = "type C() =\n    member this.%s = 1"
    assert_same_representation wrap(format(code, "Length")), wrap(format(code, "Size"))
    assert_same_representation wrap(format(code, "Total")), wrap(format(code, "Amount"))
  end

  def test_syntax_errors_get_a_basic_representation
    assert_basic_representation "module M\nlet f = = =\n"
  end
end
