# Clojure's transition

This file says how the Clojure outputs of this service differ from the tools they replace, and why.

## Representation

The representation replaces the old Clojure representer (`exercism/clojure-representer`), which ran `macroexpand-all` on the solution and printed the result, with every symbol that wasn't in clojure.core or the tests replaced by a placeholder.
This service never runs the solution's code, so it expands the macros that solutions use with rules of its own, which give the same forms.
It matches what the old representer did, apart from the decisions that apply to every language, which [docs/how-it-works.md](../../../../docs/how-it-works.md) describes, and these differences:

- Only these macros are expanded: `->`, `->>`, `as->`, `cond->`, `cond->>`, `some->`, `some->>`, `when`, `when-not`, `if-not`, `cond`, `and`, `or`, `if-let`, `when-let`, `for`, `fn`, `defn`, `defn-`, `defmacro`, and `let` when it destructures. Every other form stays as it is written, such as `doseq`, `case`, `condp` and a `loop` that destructures. The old representer expanded every macro.
- A macro defined by the solution is expanded only if its parameters are plain names and its body is one syntax-quoted template. A `~rest` of its rest parameter becomes `(list ...)` of the arguments.
- `for` becomes calls to `map`, `mapcat`, `filter` and `take-while`, which give the same sequence. The old representer printed the lazy-sequence code that `for` expands to.
- `ns` stays as one form, with its name and every clause other than `:require`, `:use` and `:import`, and without its docstring and attribute map. The old representer printed the code that `ns` expands to.
- A `comment` form at the top level is dropped. The old representer printed the `nil` that it expands to, which kept apart two solutions that only differ in a `comment` block.
- The names that an expansion makes up are numbered from `G__1` in each expansion, and the threading macros use `g`, so the same code always gets the same names. The old representer printed the names that Clojure numbers across the whole run, such as `p1__123#`.
- A string keeps its escapes as they are written, so `"a\nb"` and a string with a real line break stay apart. A ratio, a number in another base and a number with a suffix keep their text, so `2/4` and `1/2` stay apart. The old representer printed the values that the reader gave.
- The items of a set, and the entries of a map, are sorted if they are all strings, characters, numbers or keywords. Every other set and map keeps its order. The old representer printed every set in the order of its items' hashes, and kept the order of a map with up to eight entries.

## Spellings that share a representation

Clojure's reader reads each of these pairs as the same forms, and Clojure expands the macros in them to the same code, so the representer gives them the same representation:

- A reader macro and the form it stands for: `@x` → `(deref x)`, `'x` → `(quote x)` and `#'x` → `(var x)`.
- An anonymous function and `fn`: `#(inc %)` → `(fn [z] (inc z))`, and `%` → `%1`.
- `defn` and a `def` of a function: `(defn f [x] x)` → `(def f (fn [x] x))`, and `defn-` → `defn`.
- A top-level `comment` form and no form: `(comment (f 1))` → nothing.
- A core macro and the code it expands to: `(-> x inc (+ y))` → `(+ (inc x) y)`, `(->> x (map inc))` → `(map inc x)`, `(when x y)` → `(if x (do y))`, `(if-not x y)` → `(if (not x) y nil)` and `(cond x 1 :else 2)` → `(if x 1 (if :else 2 nil))`.
- Commas: `[1, 2]` → `[1 2]`.
- The order of a set's items and a map's entries, if they are all strings, characters, numbers or keywords: `#{2 1}` → `#{1 2}`, and `{:b 1 :a 2}` → `{:a 2 :b 1}`.
- Number spelling: `0x1F` → `31`, `017` → `15`, `0.90` → `0.9` and `1e3` → `1000.0`.

The representer also drops metadata and docstrings, which the reader keeps: `(defn ^:private f [^long x] x)` → `(defn f [x] x)`, `(defn f "Adds." [x] x)` → `(defn f [x] x)`, and `(ns app "Doc.")` → `(ns app)`.

## Analysis

This service doesn't make Clojure analyses yet, so there is nothing to compare with the old analyzer (`exercism/clojure-analyzer`).

## Snippet

The snippet replaces snippet-extractor (`exercism/snippet-extractor`).
Snippet-extractor found comments by the text at the start of each line.
This service reads the solution's syntax tree instead, so it removes every comment and `#_` form wherever they are, and skips the `ns` form at the top of the file.
It keeps the first 15 lines of the main file, where snippet-extractor kept 10.
