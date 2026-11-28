require_relative "stage_helper"

# Tests Crystal's Reorder stage, through Inspector as a whole, because it
# sorts by the code with the renamed names left out.
class CrystalReorderTest < InspectorTest
  include CrystalStages

  track "crystal"

  def test_the_order_of_methods_in_a_class_makes_no_difference
    assert_same_representation in_class("def a\n  1\nend\ndef b(x)\n  x + 1\nend"),
      in_class("def b(x)\n  x + 1\nend\ndef a\n  1\nend")
    assert_same_representation in_class("private def a\n  1\nend\ndef b\n  2\nend"),
      in_class("def b\n  2\nend\nprivate def a\n  1\nend")
    refute_same_representation in_class("def a\n  1\nend\ndef b\n  2\nend"), in_class("def a\n  1\nend\ndef b\n  3\nend")
  end

  def test_the_order_of_methods_in_modules_and_structs_makes_no_difference
    assert_same_representation "module M\n  def self.a\n    1\n  end\n  def self.b\n    2\n  end\nend\n",
      "module M\n  def self.b\n    2\n  end\n  def self.a\n    1\n  end\nend\n"
    assert_same_representation "struct S\n  def a\n    1\n  end\n  def b\n    2\n  end\nend\n",
      "struct S\n  def b\n    2\n  end\n  def a\n    1\n  end\nend\n"
  end

  def test_the_order_of_top_level_methods_makes_no_difference
    assert_same_representation "def a\n  1\nend\n\ndef b(x)\n  x + 1\nend\n", "def b(x)\n  x + 1\nend\n\ndef a\n  1\nend\n"
  end

  def test_other_code_stays_where_it_is
    refute_same_representation in_class("X = 1\ndef a\n  1\nend"), in_class("def a\n  1\nend\nX = 1")
    refute_same_representation "def f\n  a(1)\n  b(2)\nend\n", "def f\n  b(2)\n  a(1)\nend\n"
  end
end
