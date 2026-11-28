require_relative "stage_helper"

# Checks OCaml's declarations of which nodes are names and which nodes
# define them (see ocaml/representation.rb), through the engine's
# renaming.
class OCamlNamesTest < Minitest::Test
  include OCamlStages

  def test_renames_functions_values_and_parameters
    source = "let limit = 4\nlet rec is_leap year = year mod limit = 0\nlet ( +! ) a b = a + b"
    assert_equal ["+!", "a", "b", "is_leap", "limit", "year"], renamed(source)
  end

  def test_renames_the_variables_in_patterns_and_loops
    source = "let (a, b) = pair\nlet f = function\n  | Some (x :: xs) when x > 0 -> xs\n  | Some ([] as e) -> e\n  | None -> []\n" \
             "let g { width; height = h } = for i = 0 to h do ignore (width, i) done\nlet k = fun p -> let q = p in q"
    assert_equal %w[a b e f g h i k p q width x xs], renamed(source)
  end

  def test_renames_labels
    source = "let area ~width ?(height = 1) ~depth:d () = width * height * d\nlet x = area ~width:2 ~depth:3 ()"
    assert_equal %w[area d depth height width x], renamed(source)
  end

  def test_renames_types_constructors_fields_and_type_variables
    source = "type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree\ntype point = { x : int; mutable y : int }\n" \
             "exception Oops of string\nlet first (xs : 'b list) = List.hd xs"
    assert_equal ["'a", "'b", "Leaf", "Node", "Oops", "first", "point", "tree", "x", "xs", "y"], renamed(source)
  end

  def test_renames_modules_and_module_types
    source = "module type Shape = sig val area : int -> int end\nmodule Make (S : Shape) = struct let v = S.area 1 end"
    assert_equal %w[Make S Shape area v], renamed(source)
  end

  def test_renames_classes_methods_and_instance_variables
    source = "class counter = object val mutable count = 0 method incr = count <- count + 1 end"
    assert_equal %w[count counter incr], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "open Base\nlet f (s : string) = List.map ~f:String.uppercase [s] |> List.rev"
    assert_equal %w[f s], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], OCaml::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if OCaml::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
