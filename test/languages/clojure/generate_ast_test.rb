require_relative "stage_helper"

# Tests Clojure's GenerateAST stage. Each assert_same pair gets the same forms
# from Clojure's reader (`read-string`, ignoring metadata), and each
# refute_same pair gets different forms. The last test lists the pairs where
# this stage deliberately differs from the reader.
class ClojureGenerateASTTest < Minitest::Test
  include ClojureStages

  def test_drops_comments_and_layout
    assert_same "(defn f [x]\n  ;; note\n  #_(ignored)\n  (inc x))", "(defn f [x] (inc x))"
    assert_same "(f a, b)", "(f a b)"
  end

  def test_drops_metadata
    assert_same "(defn ^:private f [^long x] x)", "(defn f [x] x)"
    assert_same "(def ^{:doc \"A limit.\"} limit 5)", "(def limit 5)"
  end

  def test_numbers_are_their_values
    assert_same "(def x [0x1F 017 0.90 1e3])", "(def x [31 15 0.9 1000.0])"
    refute_same "(def x 1.0)", "(def x 1)"
    refute_same "(def x 1N)", "(def x 1)"
    refute_same "(def x 0.9)", "(def x 0.8)"
  end

  def test_strings_and_keywords
    refute_same '(def x "a")', '(def x "b")'
    refute_same "(def x :a)", "(def x ::a)"
    refute_same "(def x :a)", '(def x "a")'
  end

  def test_symbols
    assert_includes ast("(str/join x)"), "(qualified str join)"
    assert_includes ast("(.toUpperCase x)"), "(method toUpperCase)"
    assert_includes ast("(->Point 1 2)"), "(constructor -> Point)"
    assert_includes ast("(map->Point m)"), "(constructor map-> Point)"
    assert_includes ast("(Point. 1 2)"), "(constructor new Point)"
    refute_same "(str/join x)", "(str/split x)"
  end

  def test_quotes_derefs_and_vars_are_forms
    assert_same "(f 'x)", "(f (quote x))"
    assert_same "(f @x)", "(f (deref x))"
    assert_same "(f #'x)", "(f (var x))"
  end

  def test_anonymous_functions_are_fn_forms
    assert_same "(map #(+ % %2) x y)", "(map (fn* ([%1 %2] (+ %1 %2))) x y)"
    assert_same "(apply #(count %&) x)", "(apply (fn* ([& %&] (count %&))) x)"
    refute_same "(map #(inc %) x)", "(map #(dec %) x)"
  end

  # The reader gives an anonymous function one arity without a list around
  # it, and gives its parameters generated names, such as `p1__123#`. This
  # stage writes it with a list around the arity, as `fn` expands to, and
  # numbers the parameters, so the same code always gets the same names.
  #
  # The reader reads the escapes in a string, reduces a ratio and reads a
  # number in another base. This stage keeps their text.
  def test_where_this_stage_differs_from_the_reader
    assert_same "(map #(inc %) x)", "(map (fn* ([%1] (inc %1))) x)"
    refute_same '(def x "a\\nb")', "(def x \"a\nb\")"
    refute_same "(def x 2/4)", "(def x 1/2)"
    refute_same "(def x 2r101)", "(def x 5)"
  end

  private
  def ast(source) = write(generate_ast(source))
  def assert_same(first, second) = assert_equal(ast(first), ast(second))
  def refute_same(first, second) = refute_equal(ast(first), ast(second))
end
