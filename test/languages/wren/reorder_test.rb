require_relative "stage_helper"

# Tests Wren's Reorder stage, through Rosetta as a whole, because it
# sorts by the code with the renamed names left out.
class WrenReorderTest < RosettaTest
  include WrenStages

  track "wren"

  def test_the_order_of_a_maps_entries_makes_no_difference
    assert_same_representation 'var m = {"b": 1, "a": 2}', 'var m = {"a": 2, "b": 1}'
    assert_same_representation "var m = {2: 1, 1: 2}", "var m = {1: 2, 2: 1}"
    refute_same_representation 'var m = {"a": 1}', 'var m = {"a": 2}'
  end

  def test_the_order_of_statements_stays
    refute_same_representation "f(1)\ng(2)", "g(2)\nf(1)"
  end
end
