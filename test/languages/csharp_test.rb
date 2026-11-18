require "test_helper"

class CSharpTest < RepresenterTest
  extend UpstreamTests

  track "csharp"

  LIBRARY_ADD = {
    restore: { "PLACEHOLDER_2" => "Add" },
    remove: ["Add"],
    why: "Add is a library method name (DateTime.Add), so a method the student calls Add keeps its name."
  }.freeze

  DEVIATIONS = {
    "Braces-BracesOnSameLine" => LIBRARY_ADD,
    "WhiteSpace-InconsistentWhiteSpace" => LIBRARY_ADD,
    "WhiteSpace-WindowsLineEndings" => LIBRARY_ADD,
    "DictionaryInitializations-CollectionInitWithFunctionArgs" => {
      add: ["LocalInt"],
      why: "Local functions are renamed. The old representer left them."
    },
    "DictionaryInitializations-ObjectInitWithFunctionArgs" => {
      add: ["LocalInt"],
      why: "Local functions are renamed. The old representer left them."
    },
    "ReadOnly-StructMembers" => {
      add: %w[Fake P P2],
      why: "Structs and properties are renamed. The old representer left them."
    },
    "ReadOnly-Structs" => {
      add: ["Fake"],
      why: "Structs are renamed. The old representer left them."
    },
    "DictionaryInitializations-RealWorldCollectionInit" => {
      restore: { "PLACEHOLDER_2" => "FacialFeatures", "PLACEHOLDER_3" => "Identity" },
      add: %w[Admin Developers Email EyeColor NameAndAddress PhiltrumWidth],
      why: "The old representer renamed FacialFeatures and Identity where they are declared but not where they are " \
           "used, so its output isn't valid code. This representer renames both consistently, and renames properties too."
    },
    "DictionaryInitializations-RealWorldObjectInit" => {
      restore: { "PLACEHOLDER_2" => "FacialFeatures", "PLACEHOLDER_3" => "Identity" },
      add: %w[Admin Developers Email EyeColor NameAndAddress PhiltrumWidth],
      why: "The old representer renamed FacialFeatures and Identity where they are declared but not where they are " \
           "used, so its output isn't valid code. This representer renames both consistently, and renames properties too."
    },
    "Identifiers-CombinationOfEverything" => {
      unrepresentable: true,
      why: "The input has syntax errors (two missing semicolons). Roslyn represents it anyway, but tree-sitter " \
           "reports the errors, so the solution gets no representation."
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

  def test_type_keywords
    assert_same_representation wrap("return Int32.Parse(\"1\") > y;"), wrap("return int.Parse(\"1\") > y;")
    assert_same_representation wrap("Boolean z = x; return z;"), wrap("bool z = x; return z;")
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
    refute_same_representation "public static class A { public static int Sum(int[] a) => a.Sum(); }",
      "public static class A { public static int Max(int[] a) => a.Max(); }"
  end

  def test_tuple_deconstruction_renames_every_variable
    assert_same_representation wrap("var (a, b) = (1, 2); return a - b;"), wrap("var (p, q) = (1, 2); return p - q;")
    refute_same_representation wrap("var (a, b) = (1, 2); return a - b;"), wrap("var (a, b) = (1, 2); return b - a;")
  end

  def test_names_in_the_tests_are_kept
    tests = { "LeapTests.cs" => "public class LeapTests { [Fact] public void T() => Assert.True(Leap.IsLeapYear(2000)); }" }
    result = represent("public static class Leap { public static bool IsLeapYear(int year) => year % 4 == 0; }",
      filename: "Leap.cs", exercise_files: tests)
    assert_equal ["year"], result.mapping.values
  end

  def test_syntax_errors_are_unrepresentable_with_the_csharp_version
    result = represent("public class {")
    assert_nil result.representation
    assert_equal "parse_error", result.reason
    assert_equal Representer::Languages::CSharp.version, result.version
  end
end
