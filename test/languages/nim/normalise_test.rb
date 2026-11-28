require_relative "stage_helper"

# Tests Nim's Normalise stage, through Inspector as a whole, because the
# names it writes are renamed afterwards.
class NimNormaliseTest < InspectorTest
  include NimStages

  track "nim"

  def test_imports_includes_and_exports_are_dropped
    assert_same_representation "import strutils, algorithm\nlet x = 1", "let x = 1"
    assert_same_representation "import std/[strutils, sequtils]\nfrom math import sqrt\ninclude foo\nexport foo\nlet x = 1",
      "let x = 1"
    refute_same_representation "import strutils\nlet x = \"a\".toUpper", "import strutils\nlet x = \"a\".toLower"
  end

  def test_parameters_that_share_a_type_each_get_the_type
    assert_same_representation "proc f(a, b: int): int = a", "proc f(a: int, b: int): int = a"
    assert_same_representation "proc f(a, b = 1): int = a", "proc f(a = 1, b = 1): int = a"
    refute_same_representation "proc f(a, b: int): int = a", "proc f(a: int, b: string): int = a"
  end
end
