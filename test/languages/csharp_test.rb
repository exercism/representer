require "test_helper"

class CSharpTest < RosettaTest
  extend UpstreamTests

  track "csharp"

  DEVIATIONS = {
    "Identifiers-LocalFunction" => { add: ["Add"], why: "Local functions are renamed." },
    "DictionaryInitializations-CollectionInitWithFunctionArgs" => {
      add: ["LocalInt"],
      why: "Local functions are renamed."
    },
    "DictionaryInitializations-ObjectInitWithFunctionArgs" => {
      add: ["LocalInt"],
      why: "Local functions are renamed."
    },
    "ReadOnly-StructMembers" => {
      add: %w[Fake P P2],
      why: "Structs and properties are renamed."
    },
    "ReadOnly-Structs" => {
      add: ["Fake"],
      why: "Structs are renamed."
    },
    "DictionaryInitializations-RealWorldCollectionInit" => {
      restore: { "PLACEHOLDER_2" => "FacialFeatures", "PLACEHOLDER_3" => "Identity" },
      add: %w[Admin Developers Email EyeColor NameAndAddress PhiltrumWidth],
      why: "The fixture renames FacialFeatures and Identity where they are declared but not where they are " \
           "used, so its output isn't valid code. Rosetta renames both consistently, and renames properties too."
    },
    "DictionaryInitializations-RealWorldObjectInit" => {
      restore: { "PLACEHOLDER_2" => "FacialFeatures", "PLACEHOLDER_3" => "Identity" },
      add: %w[Admin Developers Email EyeColor NameAndAddress PhiltrumWidth],
      why: "The fixture renames FacialFeatures and Identity where they are declared but not where they are " \
           "used, so its output isn't valid code. Rosetta renames both consistently, and renames properties too."
    },
    "Identifiers-CombinationOfEverything" => {
      parse_error: true,
      why: "The input has syntax errors (two missing semicolons). Roslyn represents it anyway, but tree-sitter " \
           "reports the errors, so the solution gets Basic's representation."
    }
  }.freeze

  upstream_tests ".cs", deviations: DEVIATIONS

  def wrap(body) = "public static class Fake\n{\n    public static bool Test(bool x, int y)\n    {\n#{body}\n    }\n}"

  def test_not_equals_true_is_not_x
    assert_same_representation wrap("return x != true;"), wrap("return !x;")
    assert_same_representation wrap("return x != false;"), wrap("return x;")
    refute_same_representation wrap("return x != true;"), wrap("return x;")
  end

  def test_negated_ternary
    assert_same_representation wrap("return !x ? 1 > y : 2 > y;"), wrap("return x ? 2 > y : 1 > y;")
  end

  # Only `String` is written as its keyword.
  def test_string_is_written_as_its_keyword
    assert_same_representation wrap("String z = \"\"; return x;"), wrap("string z = \"\"; return x;")
    assert_same_representation wrap("return String.IsNullOrEmpty(\"\");"), wrap("return string.IsNullOrEmpty(\"\");")
    refute_same_representation wrap("return Int32.Parse(\"1\") > y;"), wrap("return int.Parse(\"1\") > y;")
  end

  def test_object_creation_brackets
    assert_same_representation wrap("var l = new List<int>() { 1 }; return x;"), wrap("var l = new List<int> { 1 }; return x;")
  end

  def test_string_escapes
    assert_same_representation wrap("return \"\\x41\" == \"A\";"), wrap("return \"\\u0041\" == \"A\";")
    refute_same_representation wrap("return \"a b\" == \"\";"), wrap("return \"ab\" == \"\";")
  end

  def test_library_calls_stay_apart
    refute_same_representation wrap("return y.Equals(1);"), wrap("return y.CompareTo(1) == 0;")
    assert_same_representation "public static class A { public static int Sum(int[] a) => 1; }",
      "public static class A { public static int Max(int[] a) => 1; }"
  end

  def test_tuple_deconstruction_renames_every_variable
    assert_same_representation wrap("var (a, b) = (1, 2); return a - b;"), wrap("var (p, q) = (1, 2); return p - q;")
    refute_same_representation wrap("var (a, b) = (1, 2); return a - b;"), wrap("var (a, b) = (1, 2); return b - a;")
  end

  def test_syntax_errors_get_a_basic_representation_with_the_csharp_version
    assert_basic_representation "public class {"
  end

  # These keywords and punctuation are the only difference between each pair.
  def test_tokens_that_tell_programs_apart_are_kept
    refute_same_representation wrap("using var r = G(); return x;"), wrap("var r = G(); return x;")
    refute_same_representation wrap("await foreach (var r in G()) {} return x;"), wrap("foreach (var r in G()) {} return x;")
    refute_same_representation wrap("await using var r = G(); return x;"), wrap("using var r = G(); return x;")
    refute_same_representation wrap("await using (G()) {} return x;"), wrap("using (G()) {} return x;")
    refute_same_representation "class A<T> where T : class { }", "class A<T> where T : struct { }"
    refute_same_representation "class A<T> where T : class { }", "class A<T> where T : class? { }"
    refute_same_representation "class A { int[] b; }", "class A { int[,] b; }"
    refute_same_representation "record struct R(int X);", "record class R(int X);"
    refute_same_representation "record struct R(int X);", "record R(int X);"
    refute_same_representation wrap("for (;; y++) {} return x;"), wrap("for (y++;;) {} return x;")
    refute_same_representation "class A { object F() => typeof(D<,>); }", "class A { object F() => typeof(D<>); }"
    refute_same_representation "class A { object F() => new[,] { {1} }; }", "class A { object F() => new[] { {1} }; }"
  end

  def test_own_members_need_no_qualifier
    code = "public class A\n{\n    private int count;\n    public A(int start) { %s = start; }\n" \
           "    public static int B() => 1;\n    public int C() => %s();\n}"
    assert_same_representation format(code, "this.count", "B"), format(code, "count", "A.B")
    assert_same_representation format(code, "this.count", "this.B"), format(code, "count", "B")

    # A parameter with the member's name gets the same placeholder anyway.
    shadowed = "public class A\n{\n    private int count;\n    public A(int count) { %s = count; }\n}"
    assert_same_representation format(shadowed, "this.count"), format(shadowed, "count")
  end

  def test_numbers_are_their_values
    assert_same_representation wrap("return y == 1_000 + 0x1F;"), wrap("return y == 1000 + 31;")
    assert_same_representation wrap("return 1.50 == 1.5f;").sub("1.5f", "1.50f"), wrap("return 1.5 == 1.5f;")
    refute_same_representation wrap("return 1.50m == 1.5m;"), wrap("return 1.5m == 1.5m;")
    refute_same_representation wrap("return 1.0 == 1;"), wrap("return 1 == 1;")
  end
end
