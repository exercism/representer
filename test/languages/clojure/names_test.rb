require_relative "stage_helper"

# Checks Clojure's declarations of which nodes are names and which nodes
# define them (see clojure/representation.rb), through the engine's renaming.
class ClojureNamesTest < Minitest::Test
  include ClojureStages

  def test_renames_vars_functions_and_their_parameters
    source = "(def a 1) (defonce b 2) (declare c d) (defn e [f & g] f) (defn- h ([i] i) ([i j] j)) (defmacro k [l] l)"
    assert_equal %w[a b c d e f g h i j k l], renamed(source)
  end

  def test_renames_the_names_of_anonymous_functions_and_their_parameters
    assert_equal ["%1", "%2", "a", "b"], renamed("(map (fn a [b] b) #(+ % %2))")
  end

  def test_renames_locals
    source = "(let [a 1] (loop [b a] (for [c b :let [d c]] (doseq [e d] (dotimes [f e] f)))))"
    assert_equal %w[a b c d e f], renamed(source)
  end

  def test_renames_destructured_names
    assert_equal %w[a all b c d m], renamed("(let [[a [b] :as all] x {:keys [c] d :d :as m} y] a)")
    assert_equal %w[a b], renamed("(doseq [{:keys [a] :or {b 1}} xs] a)")
  end

  def test_renames_letfn_catch_and_defmethod_names
    assert_equal %w[a b], renamed("(letfn [(a [b] (inc b))] (a 1))")
    assert_equal ["e"], renamed("(try (f) (catch Exception e e))")
    assert_equal %w[area side], renamed("(defmulti area :shape) (defmethod area :square [{:keys [side]}] side)")
  end

  def test_renames_records_protocols_and_their_methods
    source = "(defprotocol Shape (area [this])) (defrecord Square [side] Shape (area [self] side))"
    assert_equal %w[Shape Square area self side this], renamed(source)
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("(defrecord Point [x y]) (defn count [p] (->Point (.area p) (count p)))")
    assert(marks.select { |text, _| %w[Point count].include?(text) }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[g x], renamed("(defn g [x] (str/join (.toUpperCase x) (map inc [x])))")
  end

  def test_renames_underscore_and_keeps_the_rest_marker
    assert_equal %w[_ more], renamed("(fn [_ & more] more)")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Clojure::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Clojure::Representation::Spec.name?(node) }
    leaves
  end
end
