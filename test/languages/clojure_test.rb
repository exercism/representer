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

  UNUSED_REQUIRE = "The two tests only differ in a `:require` that the code never uses. This representer drops the " \
                   "`:require`, `:use` and `:import` clauses, which only make names available.".freeze

  CORE_NAME = "This representer renames a name that the solution defines, even if it is also a clojure.core name " \
              "(`name`, `num`). The two tests only differ in such a name, which the old representer kept.".freeze

  DEVIATIONS = {
    "two-fer-4" => { merges_with: "two-fer-5", why: CORE_NAME },
    "two-fer-488" => { merges_with: %w[two-fer-3 two-fer-390 two-fer-464], why: CORE_NAME },
    "two-fer-28" => { merges_with: "two-fer-367", why: CORE_NAME },
    "two-fer-63" => { merges_with: %w[two-fer-2 two-fer-52], why: CORE_NAME },
    "two-fer-175" => { merges_with: %w[two-fer-40 two-fer-87], why: CORE_NAME },
    "armstrong-numbers-44" => { merges_with: "armstrong-numbers-55", why: CORE_NAME },
    "two-fer-148" => { merges_with: "two-fer-41", why: UNUSED_REQUIRE },
    "two-fer-52" => { merges_with: "two-fer-2", why: UNUSED_REQUIRE },
    "two-fer-390" => { merges_with: %w[two-fer-3 two-fer-464], why: UNUSED_REQUIRE },
    "two-fer-464" => { merges_with: "two-fer-3", why: UNUSED_REQUIRE },
    "two-fer-87" => { merges_with: "two-fer-40", why: UNUSED_REQUIRE },
    "two-fer-345" => {
      merges_with: "two-fer-327",
      why: "The two tests only differ in whether the solution requires clojure.string in its `ns` or with a " \
           "`require` form. This representer drops both."
    }
  }.freeze

  # The old representer never renamed a clojure.core name, even if the solution defined it (a local called
  # `name` or `num`). This representer renames every name the solution defines, so the mapping of each test
  # below has these names too.
  RENAMED_WHY = "This representer renames a name that the solution defines, even if it is also a clojure.core name. " \
                "The old representer never renamed a clojure.core name.".freeze

  RENAMED = {
    %w[num] => %w[
      armstrong-numbers-0 armstrong-numbers-2 armstrong-numbers-4 armstrong-numbers-5 armstrong-numbers-6
      armstrong-numbers-7 armstrong-numbers-8 armstrong-numbers-10 armstrong-numbers-14 armstrong-numbers-15
      armstrong-numbers-16 armstrong-numbers-17 armstrong-numbers-18 armstrong-numbers-19 armstrong-numbers-21
      armstrong-numbers-23 armstrong-numbers-24 armstrong-numbers-25 armstrong-numbers-26 armstrong-numbers-27
      armstrong-numbers-28 armstrong-numbers-30 armstrong-numbers-31 armstrong-numbers-33 armstrong-numbers-34
      armstrong-numbers-35 armstrong-numbers-36 armstrong-numbers-38 armstrong-numbers-39 armstrong-numbers-40
      armstrong-numbers-42 armstrong-numbers-43 armstrong-numbers-45 armstrong-numbers-46 armstrong-numbers-48
      armstrong-numbers-49 armstrong-numbers-50 armstrong-numbers-51 armstrong-numbers-52 armstrong-numbers-54
      armstrong-numbers-55 armstrong-numbers-57 armstrong-numbers-58 armstrong-numbers-59 armstrong-numbers-60
      armstrong-numbers-61 armstrong-numbers-62 armstrong-numbers-63 armstrong-numbers-64 armstrong-numbers-65
      armstrong-numbers-66 armstrong-numbers-67 armstrong-numbers-69 armstrong-numbers-70 armstrong-numbers-71
      armstrong-numbers-72 armstrong-numbers-74 armstrong-numbers-75 armstrong-numbers-76 armstrong-numbers-77
      armstrong-numbers-79 armstrong-numbers-80 armstrong-numbers-81 armstrong-numbers-83 armstrong-numbers-84
      armstrong-numbers-85 armstrong-numbers-86 armstrong-numbers-87 armstrong-numbers-88 armstrong-numbers-89
      armstrong-numbers-90 armstrong-numbers-91 armstrong-numbers-92 armstrong-numbers-93 armstrong-numbers-95
      armstrong-numbers-96 armstrong-numbers-98 armstrong-numbers-99 armstrong-numbers-100 armstrong-numbers-101
      armstrong-numbers-102 armstrong-numbers-103 armstrong-numbers-104 armstrong-numbers-105 armstrong-numbers-107
      armstrong-numbers-110 armstrong-numbers-113 armstrong-numbers-114 armstrong-numbers-115 armstrong-numbers-116
      armstrong-numbers-117 armstrong-numbers-119 armstrong-numbers-120 armstrong-numbers-121 armstrong-numbers-122
      armstrong-numbers-123 armstrong-numbers-126 armstrong-numbers-127 armstrong-numbers-131 armstrong-numbers-132
      armstrong-numbers-133 armstrong-numbers-134 armstrong-numbers-135 armstrong-numbers-136 armstrong-numbers-137
      armstrong-numbers-138 armstrong-numbers-139 armstrong-numbers-140 armstrong-numbers-142 armstrong-numbers-143
      armstrong-numbers-144 armstrong-numbers-145 armstrong-numbers-146 armstrong-numbers-147 armstrong-numbers-148
      armstrong-numbers-149 armstrong-numbers-150 armstrong-numbers-151 armstrong-numbers-153 armstrong-numbers-155
      armstrong-numbers-156 armstrong-numbers-157 armstrong-numbers-158 armstrong-numbers-159 armstrong-numbers-160
      armstrong-numbers-161 armstrong-numbers-162 armstrong-numbers-163 armstrong-numbers-164 armstrong-numbers-165
      armstrong-numbers-166 armstrong-numbers-167 armstrong-numbers-169 armstrong-numbers-170 armstrong-numbers-171
      armstrong-numbers-172 armstrong-numbers-173 armstrong-numbers-175 armstrong-numbers-176 armstrong-numbers-178
      armstrong-numbers-179 armstrong-numbers-180 armstrong-numbers-181 armstrong-numbers-182 armstrong-numbers-183
      armstrong-numbers-184 armstrong-numbers-185 armstrong-numbers-188 armstrong-numbers-190 armstrong-numbers-191
      armstrong-numbers-192 armstrong-numbers-193 armstrong-numbers-194 armstrong-numbers-195 armstrong-numbers-196
      armstrong-numbers-198 armstrong-numbers-199 armstrong-numbers-200 armstrong-numbers-201 armstrong-numbers-202
      armstrong-numbers-203 armstrong-numbers-204 armstrong-numbers-207 armstrong-numbers-209 armstrong-numbers-210
      armstrong-numbers-211 armstrong-numbers-212 armstrong-numbers-214 armstrong-numbers-215 armstrong-numbers-216
      armstrong-numbers-217 armstrong-numbers-218 armstrong-numbers-219 armstrong-numbers-220 armstrong-numbers-221
      armstrong-numbers-222 armstrong-numbers-223 armstrong-numbers-225 armstrong-numbers-226 armstrong-numbers-227
      armstrong-numbers-228 armstrong-numbers-229 armstrong-numbers-231 armstrong-numbers-232 armstrong-numbers-233
      armstrong-numbers-234 armstrong-numbers-235 armstrong-numbers-236 armstrong-numbers-241 armstrong-numbers-242
      armstrong-numbers-243 armstrong-numbers-244 armstrong-numbers-245 armstrong-numbers-247 armstrong-numbers-248
      armstrong-numbers-249 armstrong-numbers-250 armstrong-numbers-251 armstrong-numbers-252 armstrong-numbers-253
      armstrong-numbers-254 armstrong-numbers-255 armstrong-numbers-256 armstrong-numbers-258 armstrong-numbers-259
      armstrong-numbers-260 armstrong-numbers-261 armstrong-numbers-263 armstrong-numbers-264 armstrong-numbers-265
      armstrong-numbers-266 armstrong-numbers-267 armstrong-numbers-268 armstrong-numbers-269 armstrong-numbers-270
      armstrong-numbers-271 armstrong-numbers-273 armstrong-numbers-275 armstrong-numbers-277 armstrong-numbers-278
      armstrong-numbers-279 armstrong-numbers-280 armstrong-numbers-281 armstrong-numbers-282 armstrong-numbers-283
      armstrong-numbers-284 armstrong-numbers-285 armstrong-numbers-286 armstrong-numbers-287 armstrong-numbers-288
      armstrong-numbers-289 armstrong-numbers-290 armstrong-numbers-291 armstrong-numbers-292 armstrong-numbers-293
      armstrong-numbers-294 armstrong-numbers-297 armstrong-numbers-299 armstrong-numbers-301 armstrong-numbers-302
      armstrong-numbers-303 armstrong-numbers-304 armstrong-numbers-305 armstrong-numbers-306 armstrong-numbers-308
      armstrong-numbers-309 armstrong-numbers-310 armstrong-numbers-311 armstrong-numbers-312 armstrong-numbers-314
      armstrong-numbers-315 armstrong-numbers-316 armstrong-numbers-317 armstrong-numbers-318 armstrong-numbers-319
      armstrong-numbers-320 armstrong-numbers-321 armstrong-numbers-322 armstrong-numbers-323 armstrong-numbers-324
      armstrong-numbers-325 armstrong-numbers-326 armstrong-numbers-327 armstrong-numbers-329 armstrong-numbers-331
      armstrong-numbers-332 armstrong-numbers-333 armstrong-numbers-335 armstrong-numbers-336 armstrong-numbers-337
      armstrong-numbers-338 armstrong-numbers-340 armstrong-numbers-341 armstrong-numbers-343 armstrong-numbers-344
      armstrong-numbers-345 armstrong-numbers-346 armstrong-numbers-349 armstrong-numbers-350 armstrong-numbers-351
      armstrong-numbers-352 armstrong-numbers-353 armstrong-numbers-355 armstrong-numbers-357 armstrong-numbers-358
      armstrong-numbers-359 armstrong-numbers-361 armstrong-numbers-362 armstrong-numbers-363 armstrong-numbers-364
      armstrong-numbers-365 armstrong-numbers-367 armstrong-numbers-368 armstrong-numbers-369 armstrong-numbers-370
      armstrong-numbers-371 armstrong-numbers-372 armstrong-numbers-373 armstrong-numbers-374 armstrong-numbers-376
      armstrong-numbers-377 armstrong-numbers-378 armstrong-numbers-379 armstrong-numbers-380 armstrong-numbers-381
      armstrong-numbers-382 armstrong-numbers-383 armstrong-numbers-385 armstrong-numbers-386 armstrong-numbers-387
      armstrong-numbers-388 armstrong-numbers-389 armstrong-numbers-390 armstrong-numbers-391 armstrong-numbers-392
      armstrong-numbers-393 armstrong-numbers-395 armstrong-numbers-396 armstrong-numbers-397 armstrong-numbers-398
      armstrong-numbers-399 armstrong-numbers-400 armstrong-numbers-401 armstrong-numbers-402 armstrong-numbers-403
      armstrong-numbers-405 armstrong-numbers-406 armstrong-numbers-407 armstrong-numbers-408 armstrong-numbers-409
      armstrong-numbers-410 armstrong-numbers-412 armstrong-numbers-413 armstrong-numbers-414 armstrong-numbers-415
      armstrong-numbers-416 armstrong-numbers-417 armstrong-numbers-422 armstrong-numbers-423 armstrong-numbers-424
      armstrong-numbers-425 armstrong-numbers-426 armstrong-numbers-428 armstrong-numbers-429 armstrong-numbers-430
      armstrong-numbers-431 armstrong-numbers-432 armstrong-numbers-433 armstrong-numbers-436 armstrong-numbers-438
      armstrong-numbers-439 armstrong-numbers-440 armstrong-numbers-441 armstrong-numbers-445 armstrong-numbers-448
      armstrong-numbers-449 armstrong-numbers-450 armstrong-numbers-452 armstrong-numbers-453 armstrong-numbers-455
      armstrong-numbers-456 armstrong-numbers-457 armstrong-numbers-459 armstrong-numbers-460 armstrong-numbers-461
      armstrong-numbers-462 armstrong-numbers-463 armstrong-numbers-464 armstrong-numbers-465 armstrong-numbers-468
      armstrong-numbers-470 armstrong-numbers-472 armstrong-numbers-473 armstrong-numbers-476 armstrong-numbers-477
      armstrong-numbers-478 armstrong-numbers-479 armstrong-numbers-480 armstrong-numbers-481 armstrong-numbers-482
      armstrong-numbers-483 armstrong-numbers-484 armstrong-numbers-485 armstrong-numbers-487 armstrong-numbers-490
      armstrong-numbers-491 armstrong-numbers-492 armstrong-numbers-494 armstrong-numbers-495 armstrong-numbers-496
      armstrong-numbers-497 armstrong-numbers-498 armstrong-numbers-499
    ],
    %w[name] => %w[
      two-fer-0 two-fer-1 two-fer-2 two-fer-3 two-fer-5
      two-fer-6 two-fer-7 two-fer-10 two-fer-11 two-fer-14
      two-fer-16 two-fer-17 two-fer-18 two-fer-20 two-fer-21
      two-fer-27 two-fer-28 two-fer-29 two-fer-32 two-fer-33
      two-fer-39 two-fer-40 two-fer-41 two-fer-44 two-fer-47
      two-fer-48 two-fer-51 two-fer-52 two-fer-58 two-fer-59
      two-fer-60 two-fer-62 two-fer-72 two-fer-74 two-fer-75
      two-fer-76 two-fer-77 two-fer-79 two-fer-82 two-fer-87
      two-fer-88 two-fer-90 two-fer-91 two-fer-96 two-fer-104
      two-fer-108 two-fer-112 two-fer-117 two-fer-118 two-fer-138
      two-fer-141 two-fer-146 two-fer-147 two-fer-148 two-fer-155
      two-fer-158 two-fer-164 two-fer-165 two-fer-172 two-fer-185
      two-fer-186 two-fer-190 two-fer-192 two-fer-193 two-fer-194
      two-fer-202 two-fer-203 two-fer-204 two-fer-205 two-fer-219
      two-fer-222 two-fer-223 two-fer-225 two-fer-226 two-fer-235
      two-fer-236 two-fer-239 two-fer-240 two-fer-246 two-fer-251
      two-fer-255 two-fer-256 two-fer-262 two-fer-263 two-fer-273
      two-fer-275 two-fer-280 two-fer-281 two-fer-282 two-fer-284
      two-fer-291 two-fer-292 two-fer-297 two-fer-302 two-fer-306
      two-fer-312 two-fer-314 two-fer-317 two-fer-319 two-fer-321
      two-fer-327 two-fer-331 two-fer-342 two-fer-345 two-fer-352
      two-fer-353 two-fer-354 two-fer-358 two-fer-365 two-fer-370
      two-fer-380 two-fer-386 two-fer-390 two-fer-394 two-fer-400
      two-fer-401 two-fer-408 two-fer-423 two-fer-430 two-fer-435
      two-fer-439 two-fer-452 two-fer-464 two-fer-469 two-fer-475
      two-fer-478 two-fer-483 two-fer-486 two-fer-498
    ],
    %w[num val] => %w[
      armstrong-numbers-9 armstrong-numbers-37 armstrong-numbers-56 armstrong-numbers-128 armstrong-numbers-129
      armstrong-numbers-330 armstrong-numbers-339
    ],
    %w[count num] => %w[
      armstrong-numbers-29 armstrong-numbers-32 armstrong-numbers-109 armstrong-numbers-347 armstrong-numbers-411
      armstrong-numbers-419
    ],
    %w[num str] => %w[
      armstrong-numbers-68 armstrong-numbers-224 armstrong-numbers-295 armstrong-numbers-328 armstrong-numbers-486
    ],
    %w[ns num] => %w[
      armstrong-numbers-41 armstrong-numbers-53 armstrong-numbers-197 armstrong-numbers-300
    ],
    %w[num rest] => %w[
      armstrong-numbers-208 armstrong-numbers-488
    ],
    %w[chars num] => %w[
      armstrong-numbers-73
    ],
    %w[chars str] => %w[
      armstrong-numbers-154
    ],
    %w[count] => %w[
      armstrong-numbers-118
    ],
    %w[count nth num] => %w[
      armstrong-numbers-404
    ],
    %w[last num] => %w[
      armstrong-numbers-174
    ],
    %w[list num] => %w[
      armstrong-numbers-13
    ],
    %w[mod num] => %w[
      armstrong-numbers-3
    ],
    %w[next num] => %w[
      armstrong-numbers-177
    ],
    %w[nth num] => %w[
      armstrong-numbers-22
    ],
    %w[num seq] => %w[
      armstrong-numbers-94
    ]
  }.freeze

  upstream_tests ".clj", deviations: DEVIATIONS, renamed: RENAMED, renamed_why: RENAMED_WHY

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

  def test_ns_drops_its_docstring_and_imports
    plain = "(ns app (:require [clojure.string :as str] [clojure.set :refer [union difference]]) (:import (java.util List Map)))"
    assert_same_representation plain, "(ns app \"Docs.\" {:doc 1})"
    assert_same_representation "(ns app (:use [clojure.set :only [union]]))", "(ns app)"
    assert_same_representation "(ns app (:gen-class) (:require [a]))", "(ns app (:gen-class))"
    assert_same_representation "(ns app [:require [clojure.string :as str]])", "(ns app)"
    refute_same_representation "(ns app (:refer-clojure :exclude [map]))", "(ns app)"
  end

  def test_require_import_and_use_forms_are_dropped
    assert_same_representation "(ns a)\n(require '[clojure.string :as str])\n(defn f [x] (str/join x))",
      "(ns a)\n(defn f [x] (str/join x))"
    assert_same_representation "(ns a)\n(import java.util.Date)\n(use 'clojure.set)\n(def x 1)", "(ns a)\n(def x 1)"
    refute_same_representation "(ns a (:require [clojure.string :as str]))\n(defn f [x] (str/upper-case x))",
      "(ns a (:require [clojure.string :as str]))\n(defn f [x] (str/lower-case x))"
    refute_same_representation "(ns a)\n(defn f [x] (clojure.set/union x))", "(ns a)\n(defn f [x] (clojure.set/difference x))"
  end

  def test_numbers_are_their_values
    assert_same_representation "(def x 0.90)", "(def x 0.9)"
    assert_same_representation "(def x 0x1F)", "(def x 31)"
    refute_same_representation "(def x 1.0)", "(def x 1)"
    refute_same_representation "(def x 1N)", "(def x 1)"
    refute_same_representation "(def x 0.9)", "(def x 0.8)"
  end

  def test_sets_and_maps_of_literals_are_sorted
    assert_same_representation '(def x #{\\A \\C \\G \\T})', '(def x #{\\A \\T \\C \\G})'
    assert_same_representation '(def x {\\G \\C, \\A \\U})', '(def x {\\A \\U, \\G \\C})'
    refute_same_representation '(def x {\\G \\C, \\A \\U})', '(def x {\\G \\U, \\A \\C})'
    refute_same_representation "(def x [1 2])", "(def x [2 1])"
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

  def test_core_names_are_kept_if_the_solution_only_calls_them
    assert_same_representation "(defn f [name] (str name))", "(defn f [n] (str n))"
    refute_same_representation "(defn f [x] (count x))", "(defn f [x] (first x))"
    assert_same_representation "(defn count [x] x)", "(defn first [x] x)"
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
