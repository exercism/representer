require_relative "stage_helper"

# Checks Elm's declarations of which nodes are names and which nodes define
# them (see elm/representation.rb), through the engine's renaming.
class ElmNamesTest < Minitest::Test
  include ElmStages

  def test_renames_the_module_functions_parameters_and_pattern_variables
    source = "module Leap exposing (f)\n\nf a (b, c) =\n    case a of\n        x :: xs ->\n            " \
             "let\n                g { d } = d\n            in\n            (\\e -> e) x\n"
    assert_equal %w[Leap a b c d e f g x xs], renamed(source)
  end

  def test_renames_types_constructors_fields_and_type_variables
    source = "module M exposing (..)\n\ntype Tree a\n    = Leaf\n    | Node a\n\ntype alias Point =\n    " \
             "{ x : Int }\n\norigin : { r | y : b } -> b\norigin p =\n    { x = 1 }\n"
    assert_equal %w[Leaf M Node Point Tree a b origin p r x y], renamed(source)
  end

  def test_renames_ports
    assert_equal %w[M msg send], renamed("port module M exposing (..)\n\nport send : String -> Cmd msg\n")
  end

  def test_renames_defined_names_wherever_they_appear
    source = "module M exposing (..)\n\nmap xs =\n    List.map .name xs\n\nname =\n    1\n"
    assert_equal %w[M map name xs], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "module M exposing (..)\n\nf xs =\n    List.map toFloat xs |> Maybe.withDefault []\n"
    assert_equal %w[M f xs], renamed(source)
  end

  def test_keeps_constrained_type_variables
    source = "module M exposing (..)\n\nf : number -> comparable -> a\nf number comparable =\n    number\n"
    assert_equal %w[M a comparable f number], renamed(source)
    assert_equal %w[comparable number], kept_type_variables(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    names = []
    rename(source).each_descendant { |node| names << Elm::Representation::Spec.name_text(node) if node.renamed }
    names.uniq.sort
  end

  def kept_type_variables(source)
    names = []
    rename(source).each_descendant { |node| names << node.text if node.type == "constrained_type_variable" && !node.renamed }
    names.sort
  end

  def rename(source)
    prepare(source).tap { |tree| Rosetta::Engine::RenameUserDefinedNodes.([tree], Elm::Representation::Spec) }
  end
end
