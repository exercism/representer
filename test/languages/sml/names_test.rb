require_relative "stage_helper"

# Checks Standard ML's declarations of which nodes are names and which nodes
# define them (see sml/representation.rb), through the engine's renaming.
class SmlNamesTest < Minitest::Test
  include SmlStages

  def test_renames_functions_values_and_parameters
    source = "val limit = 4\nfun isLeap year = year mod limit = 0\nfun a ++ b = a + b\nval op& = Word.andb"
    assert_equal ["&", "++", "a", "b", "isLeap", "limit", "year"], renamed(source)
  end

  def test_renames_the_variables_in_patterns
    source = "val (a, b) = pair\nfun f (SOME (x :: xs)) = xs\n  | f NONE = []\n" \
             "val g = fn {width, height = h} => width + h\nval k = case p of q as r => q\nfun m {depth : int} = depth"
    assert_equal %w[a b depth f g h height k m q r width x xs], renamed(source)
  end

  def test_keeps_the_constructors_of_the_basis_library
    source = "fun f true = SOME 1\n  | f false = NONE\nfun g LESS = 0 | g _ = raise Fail \"no\""
    assert_equal %w[f g], renamed(source)
  end

  def test_renames_types_constructors_exceptions_labels_and_type_variables
    source = "datatype 'a tree = Leaf | Node of 'a tree * 'a * 'a tree\ntype point = {x : int, y : int}\n" \
             "exception Oops of string\nfun first (xs : 'b list) = hd xs\nval p = {x = 1, y = 2}"
    assert_equal ["'a", "'b", "Leaf", "Node", "Oops", "first", "p", "point", "tree", "x", "xs", "y"], renamed(source)
  end

  def test_renames_structures_signatures_and_functors
    source = "signature SHAPE = sig val area : int -> int end\n" \
             "structure Square :> SHAPE = struct fun area n = n * n end\n" \
             "functor Make (S : SHAPE) = struct val v = S.area 1 end"
    assert_equal %w[Make S SHAPE Square area n v], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "open List\nfun f (s : string) = map Char.toUpper (String.explode s)"
    assert_equal %w[f s], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Sml::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Sml::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
