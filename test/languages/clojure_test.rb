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

  ### Expanded macros ###

  def test_and_and_or
    assert_same_representation wrap("(and x y z)"), wrap("(and x (and y z))")
    assert_same_representation wrap("(or x y z)"), wrap("(or x (or y z))")
    assert_same_representation wrap("(and)"), wrap("true")
    assert_same_representation wrap("(or)"), wrap("nil")
    assert_same_representation wrap("(and x)"), wrap("x")
    refute_same_representation wrap("(and x y)"), wrap("(or x y)")
    refute_same_representation wrap("(and x y)"), wrap("(and y x)")
  end

  def test_generated_names_are_numbered_from_one
    code = "(defn f [x y] (or x (and y x)))"
    assert_includes represent(code).representation, "G__1"
    assert_same_representation code, "(defn g [a b] (or a (and b a)))"
  end

  def test_if_let_and_when_let
    assert_same_representation wrap("(if-let [v (get x y)] (inc v) 0)"), wrap("(if-let [w (get x y)] (inc w) 0)")
    assert_same_representation wrap("(if-let [v x] v)"), wrap("(if-let [v x] v nil)")
    assert_same_representation wrap("(when-let [v x] (inc v) 2)"), wrap("(when-let [w x] (inc w) 2)")
    refute_same_representation wrap("(if-let [v x] v 0)"), wrap("(when-let [v x] v)")
  end

  def test_for
    assert_same_representation wrap("(for [i x] (inc i))"), wrap("(map (fn [n] (inc n)) x)")
    assert_same_representation wrap("(for [i x :when (odd? i)] i)"), wrap("(for [i (filter (fn [i] (odd? i)) x)] i)")
    assert_same_representation wrap("(for [i x :while (odd? i)] i)"), wrap("(map (fn [i] i) (take-while (fn [i] (odd? i)) x))")
    assert_same_representation wrap("(for [i x j y] [i j])"), wrap("(mapcat (fn [a] (map (fn [b] [a b]) y)) x)")
    assert_same_representation wrap("(for [i x :let [k (* i i)] :when (odd? k)] k)"),
      wrap("(for [m x :let [n (* m m)] :when (odd? n)] n)")
    refute_same_representation wrap("(for [i x :when (odd? i)] i)"), wrap("(for [i x :when (even? i)] i)")
    refute_same_representation wrap("(for [i x j y] [i j])"), wrap("(for [j y i x] [i j])")
  end

  def test_ns
    plain = "(ns app (:require [clojure.string :as str] [clojure.set :refer [union difference]]) (:import (java.util List Map)))"
    assert_same_representation plain,
      "(ns app \"Docs.\" {:doc 1} (:import java.util.Map [java.util List]) " \
      "(:require [clojure.set :refer [difference union]]) (:require [clojure.string :as str]))"
    assert_same_representation "(ns app (:require clojure.string))", "(ns app (:require [clojure.string]))"
    assert_same_representation "(ns app (:require [clojure string set]))", "(ns app (:require [clojure.set] [clojure.string]))"
    assert_same_representation "(ns app (:use [clojure.set :only [union]]))", "(ns app (:require [clojure.set :refer [union]]))"
    refute_same_representation plain, plain.sub("clojure.set", "clojure.walk")
    refute_same_representation plain, plain.sub("Map", "Set")
  end

  def test_let_destructuring
    assert_same_representation "(let [[a b] v] (+ a b))", "(let [[c d] v] (+ c d))"
    assert_same_representation "(let [[a & more] v] more)", "(let [[b & others] v] others)"
    assert_same_representation "(let [{:keys [a b]} m] a)", "(let [{a :a b :b} m] a)"
    assert_same_representation "(let [{:strs [a]} m] a)", "(let [{a \"a\"} m] a)"
    assert_same_representation "(let [{:keys [a] :or {a 1}} m] a)", "(let [{b :a :or {b 1}} m] b)"
    assert_same_representation "(let [[a [b c]] v] c)", "(let [[d [e f]] v] f)"
    refute_same_representation "(let [[a b] v] a)", "(let [[b a] v] a)"
    refute_same_representation "(let [{:keys [a]} m] a)", "(let [{:strs [a]} m] a)"
  end

  def test_fn_destructuring
    assert_same_representation "(defn f [[a b] c] (+ a b c))", "(defn f [[x y] z] (+ x y z))"
    assert_same_representation "(fn [{:keys [a]}] a)", "(fn [{b :a}] b)"
    refute_same_representation "(defn f [[a b]] a)", "(defn f [[a b]] b)"
  end

  def test_student_macros_are_expanded
    unless_macro = "(defmacro unless [c & body] `(if ~c nil (do ~@body)))"
    assert_same_representation "#{unless_macro} (defn f [x] (unless x 1 2))", "#{unless_macro} (defn f [x] (if x nil (do 1 2)))"
    refute_same_representation "#{unless_macro} (defn f [x] (unless x 1))", "#{unless_macro} (defn f [x] (unless x 2))"
    twice = "(defmacro twice [e] `(let [v# ~e] (+ v# v#)))"
    expanded = represent("#{twice} (defn f [x] (twice (inc x)))").representation
    assert_includes expanded, "G__1"
    refute_includes expanded.split("defmacro").last, "twice"
  end

  def test_macros_with_other_bodies_are_left_alone
    code = "(defmacro m [x] (list 'inc x)) (defn f [y] (m y))"
    assert_includes represent(code).representation, "(list_lit PLACEHOLDER_1 PLACEHOLDER_4)"
  end

  def test_recursive_macros_end
    assert represent("(defmacro m [x] `(m ~x)) (defn f [y] (m y))").representation
  end

  ### Names ###

  def test_locals_are_renamed
    assert_same_representation "(defn f [a] (let [b (inc a)] (* b b)))", "(defn g [c] (let [d (inc c)] (* d d)))"
    refute_same_representation "(defn f [a] (let [b (inc a)] (* b a)))", "(defn f [a] (let [b (inc a)] (* b b)))"
  end

  def test_destructuring_names_are_renamed
    assert_same_representation "(defn f [[a b] {:keys [c] :as m}] (+ a b c m))", "(defn f [[x y] {:keys [c] :as w}] (+ x y c w))"
    assert_same_representation "(let [{k :a} m] k)", "(let [{j :a} m] j)"
    refute_same_representation "(let [{:keys [a]} m] a)", "(let [{:keys [b]} m] b)"
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

  ### Unrepresentable solutions ###

  def test_unbalanced_code_is_unrepresentable
    assert_unrepresentable "(defn f [x] (inc x)"
  end

  def test_macros_are_never_run
    code = "(defmacro boom [] (System/exit 1)) (defn f [] (boom))"
    assert represent(code).representation.include?("boom") || represent(code).mapping.value?("boom")
  end
end
