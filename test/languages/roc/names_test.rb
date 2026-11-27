require_relative "stage_helper"

# Checks Roc's declarations of which nodes are names and which nodes define
# them (see roc/representation.rb), through the engine's renaming.
class RocNamesTest < Minitest::Test
  include RocStages

  def test_renames_values_functions_parameters_and_pattern_variables
    source = <<~ROC
      Leap :: {}.{
          is_leap_year : U64 -> Bool
          is_leap_year = |year| {
              divisible = |n| year % n == 0
              match [year] {
                  [first, ..rest] => divisible(first)
                  [_, .. as others] => others.is_empty()
                  ([] as empty) => empty.is_empty()
              }
          }
      }
    ROC
    assert_equal %w[Leap divisible empty first is_leap_year n others rest year], renamed(source)
  end

  def test_renames_mutable_variables
    source = <<~ROC
      total = |list| {
          var $sum = 0
          for item in list {
              $sum = $sum + item
          }
          $sum
      }
    ROC
    assert_equal %w[$sum item list total], renamed(source)
  end

  def test_renames_types_fields_tags_and_type_variables
    source = <<~ROC
      Clock := { hours : U8, minutes : U8 }.{
          create : U8, U8 -> Clock
          create = |hours, minutes| { hours, minutes: minutes }
      }
      Tree(elem) : [Leaf, Node(Tree(elem), elem, Tree(elem))]
      Error : [InvalidInput]
      read = |{ hours: h }| h
    ROC
    assert_equal %w[Clock Error InvalidInput Leaf Node Tree create elem h hours minutes read], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = <<~ROC
      import Helpers exposing [shout]
      f = |s| Str.concat(s, "!").trim().to_utf8().len() |> Ok
    ROC
    assert_equal %w[f s], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Roc::Representation)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Roc::Representation.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
