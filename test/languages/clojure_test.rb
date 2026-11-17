require "test_helper"

# The old clojure-representer has two golden suites, two-fer and
# armstrong-numbers, with 500 real student solutions each. Its expected output
# is the solution after `macroexpand-all`, and the tests only compare that
# output. The 1000 solutions give 605 different outputs, and each different
# output is ported once, as test/fixtures/clojure/<exercise>-<number>:
#
# - The input is the first solution with that output.
# - equivalent.clj is the second solution with that output. A solution that
#   has no other solution with its output gets its own code with the comments
#   removed and the whitespace joined.
# - The old representer didn't write a mapping that its tests check, so
#   expected_mapping.json was made by this representer and read through.
#
# Differences from the old tests:
#
# - two-fer-53 is not ported. It is two-fer-2 plus a `(comment ...)` block.
#   `macroexpand-all` turns the block into a `nil`, so the old representer
#   kept the two apart. A mentor would give the same feedback for both, so
#   this representer drops the block (see test_comment_forms_are_dropped).
# - The old output contained the expansion of `ns`, gensym names such as
#   `p1__123#` and object addresses cleaned with regular expressions. None of
#   that is reproduced, because the fixtures only compare which solutions
#   merge.
class ClojureTest < RepresenterTest
  extend UpstreamTests

  track "clojure"

  DEVIATIONS = {}.freeze

  upstream_tests ".clj", deviations: DEVIATIONS

  def wrap(body) = "(defn f [x y] #{body})"

  ### Formatting ###

  def test_comments_and_whitespace_are_dropped
    assert_same_representation "(defn f [x]\n  ;; note\n  #_(ignored)\n  (inc x))", "(defn f [x] (inc x))"
  end

  def test_comment_forms_are_dropped
    assert_same_representation "(defn f [x] x)\n(comment (f 1))", "(defn f [x] x)"
  end

  def test_metadata_is_dropped
    assert_same_representation "(defn ^:private f [^long x] x)", "(defn f [x] x)"
    assert_same_representation "(defn- f [x] x)", "(defn f [x] x)"
  end

  def test_docstring_and_attribute_map_are_dropped
    assert_same_representation "(defn f \"Adds.\" {:added 1} [x] x)", "(defn f [x] x)"
  end

  def test_different_strings_and_numbers_stay_apart
    refute_same_representation wrap('"a"'), wrap('"b"')
    refute_same_representation wrap("1"), wrap("2")
    refute_same_representation wrap(":a"), wrap("::a")
  end

  ### Threading macros ###

  def test_thread_first
    assert_same_representation wrap("(-> x inc (+ y) str)"), wrap("(str (+ (inc x) y))")
    assert_same_representation wrap("(-> x)"), wrap("x")
  end

  def test_thread_last
    assert_same_representation wrap("(->> x (map inc) (filter even?))"), wrap("(filter even? (map inc x))")
    refute_same_representation wrap("(-> x (- y))"), wrap("(->> x (- y))")
  end

  def test_as_thread
    assert_same_representation wrap("(as-> x v (inc v) (- 10 v))"), wrap("(let [v x v (inc v) v (- 10 v)] v)")
  end

  def test_conditional_thread
    assert_same_representation wrap("(cond-> x (pos? y) inc)"), wrap("(cond-> x (pos? y) (inc))")
    refute_same_representation wrap("(cond-> x (pos? y) inc)"), wrap("(cond-> x (neg? y) inc)")
    refute_same_representation wrap("(cond-> x (pos? y) (- 1))"), wrap("(cond->> x (pos? y) (- 1))")
  end

  def test_nil_safe_thread
    assert_same_representation wrap("(some-> x :a inc)"), wrap("(some-> x (:a) (inc))")
    refute_same_representation wrap("(some-> x inc)"), wrap("(-> x inc)")
  end

  ### Conditionals ###

  def test_when
    assert_same_representation wrap("(when x y)"), wrap("(if x (do y))")
    assert_same_representation wrap("(when-not x y)"), wrap("(if x nil (do y))")
    refute_same_representation wrap("(when x y)"), wrap("(when-not x y)")
  end

  def test_if_not
    assert_same_representation wrap("(if-not x y 1)"), wrap("(if (not x) y 1)")
    assert_same_representation wrap("(if-not x y)"), wrap("(if (not x) y nil)")
    refute_same_representation wrap("(if-not x y 1)"), wrap("(if x y 1)")
  end

  def test_cond
    assert_same_representation wrap("(cond x 1 y 2 :else 3)"), wrap("(if x 1 (if y 2 (if :else 3 nil)))")
    assert_same_representation wrap("(cond)"), wrap("nil")
    refute_same_representation wrap("(cond x 1 y 2)"), wrap("(cond x 2 y 1)")
  end

  ### Functions ###

  def test_fn_and_defn_are_the_same
    assert_same_representation "(defn f [x] (inc x))", "(def f (fn [x] (inc x)))"
    assert_same_representation "(defn f ([x] (f x 1)) ([x y] (+ x y)))", "(def f (fn* ([x] (f x 1)) ([x y] (+ x y))))"
  end

  def test_fn_shorthand
    assert_same_representation wrap("(map #(inc %) x)"), wrap("(map (fn [n] (inc n)) x)")
    assert_same_representation wrap("(map #(+ %1 %2) x y)"), wrap("(map (fn [a b] (+ a b)) x y)")
    assert_same_representation wrap("(map #(+ % 1) x)"), wrap("(map #(+ %1 1) x)")
    assert_same_representation wrap("(apply #(count %&) x)"), wrap("(apply (fn [& more] (count more)) x)")
    refute_same_representation wrap("(map #(inc %) x)"), wrap("(map #(dec %) x)")
  end

  def test_pasted_expansion
    assert_same_representation wrap("(map (fn* [n] (inc n)) x)"), wrap("(map #(inc %) x)")
  end

  ### Names ###

  def test_locals_are_renamed
    assert_same_representation "(defn f [a] (let [b (inc a)] (* b b)))", "(defn g [c] (let [d (inc c)] (* d d)))"
    refute_same_representation "(defn f [a] (let [b (inc a)] (* b a)))", "(defn f [a] (let [b (inc a)] (* b b)))"
  end

  def test_destructuring_names_are_renamed
    assert_same_representation "(defn f [[a b] {:keys [c] :as m}] (+ a b c m))", "(defn f [[x y] {:keys [z] :as w}] (+ x y z w))"
    assert_same_representation "(let [{:keys [a] :or {a 1}} m] a)", "(let [{:keys [b] :or {b 1}} m] b)"
  end

  def test_loop_for_and_catch_names_are_renamed
    assert_same_representation "(loop [i 0] (if (< i 3) (recur (inc i)) i))", "(loop [n 0] (if (< n 3) (recur (inc n)) n))"
    assert_same_representation "(for [a xs :let [b a]] b)", "(for [c xs :let [d c]] d)"
    assert_same_representation "(try 1 (catch Exception e (str e)))", "(try 1 (catch Exception ex (str ex)))"
  end

  def test_core_names_are_kept
    refute_same_representation "(defn f [name] (str name))", "(defn f [n] (str n))"
    refute_same_representation "(defn f [x] (count x))", "(defn f [x] (first x))"
    refute_same_representation "(defn count [x] x)", "(defn first [x] x)"
  end

  def test_library_calls_are_kept
    refute_same_representation "(defn f [x] (str/join x))", "(defn f [x] (str/split x))"
    refute_same_representation "(defn f [x] (Math/abs x))", "(defn f [x] (Math/sqrt x))"
    refute_same_representation "(defn f [x] (.toUpperCase x))", "(defn f [x] (.toLowerCase x))"
  end

  def test_names_the_tests_use_are_kept
    tests = { "f_test.clj" => "(ns f-test (:require f)) (is (= 1 (f/two-fer)))" }
    refute_same_representation "(defn two-fer [] 1)", "(defn other [] 1)", exercise_files: tests
    assert_equal({}, represent("(defn two-fer [] 1)", exercise_files: tests).mapping)
  end

  def test_other_definitions_are_renamed
    assert_same_representation "(def limit 5) (declare helper) (defn f [x] (+ x limit))",
      "(def top 5) (declare other) (defn g [y] (+ y top))"
    assert_same_representation "(defrecord Point [x y]) (defn f [p] (->Point 1 2))", "(defrecord Spot [a b]) (defn g [q] (->Spot 1 2))"
    assert_same_representation "(defprotocol Shape (area [this]))", "(defprotocol Figure (size [self]))"
  end

  ### Fallback ###

  def test_unbalanced_code_falls_back
    assert_falls_back "(defn f [x] (inc x)"
  end

  def test_macros_are_never_run
    code = "(defmacro boom [] (System/exit 1)) (defn f [] (boom))"
    assert represent(code).representation.include?("boom") || represent(code).mapping.value?("boom")
  end
end
