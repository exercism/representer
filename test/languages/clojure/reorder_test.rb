require_relative "stage_helper"

# Tests Clojure's Reorder stage, through Inspector as a whole.
class ClojureReorderTest < InspectorTest
  track "clojure"

  def test_sorts_sets_of_values
    assert_same_representation '(def x #{\\A \\C \\G \\T})', '(def x #{\\A \\T \\C \\G})'
    assert_same_representation '(def x #{"b" :a 1})', '(def x #{1 "b" :a})'
  end

  def test_sorts_the_entries_of_maps_of_values
    assert_same_representation '(def x {\\G \\C, \\A \\U})', '(def x {\\A \\U, \\G \\C})'
    refute_same_representation '(def x {\\G \\C, \\A \\U})', '(def x {\\G \\U, \\A \\C})'
  end

  def test_keeps_the_order_of_sets_and_maps_of_other_code
    refute_same_representation "(defn f [a b] \#{a (inc b)})", "(defn f [a b] \#{(inc b) a})"
    refute_same_representation "(defn f [a] {:b a :a 1})", "(defn f [a] {:a 1 :b a})"
  end

  def test_keeps_the_order_of_vectors_and_lists
    refute_same_representation "(def x [1 2])", "(def x [2 1])"
    refute_same_representation "(def x '(1 2))", "(def x '(2 1))"
  end
end
