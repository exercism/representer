require_relative "stage_helper"

# Tests Ruby's Reorder stage, through the whole representer, because it
# sorts by the code with the renamed names left out.
class RubyReorderTest < RepresenterTest
  track "ruby"

  def test_the_order_of_methods_in_a_class_or_module_makes_no_difference
    assert_same_representation "class A\n  def a = 1\n  def b(x) = x\nend", "class A\n  def b(y) = y\n  def a = 1\nend"
    assert_same_representation "module M\n  def self.a = 1\n  X = 2\nend", "module M\n  X = 2\n  def self.a = 1\nend"
  end

  def test_a_method_keeps_its_visibility_when_it_moves
    refute_same_representation "class A\n  def a = 1\n  private\n  def b = 2\nend", "class A\n  def b = 2\n  private\n  def a = 1\nend"
    assert_same_representation "class A\n  def a = 1\n  private\n  def b = 2\nend", "class A\n  private def b = 2\n  def a = 1\nend"
  end

  def test_the_order_of_a_hash_makes_no_difference
    assert_same_representation "x = { b: 1, a: 2 }", "x = { a: 2, b: 1 }"
    refute_same_representation "x = [1, 2]", "x = [2, 1]"
  end

  def test_the_order_of_statements_in_a_method_stays
    refute_same_representation "def f\n  a = 1\n  puts a\nend", "def f\n  puts a\n  a = 1\nend"
  end
end
