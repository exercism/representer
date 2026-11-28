require_relative "stage_helper"

# Checks Arturo's declarations of which nodes are names and which nodes
# define them (see arturo/representation/spec.rb), through the engine's
# renaming.
class ArturoNamesTest < Minitest::Test
  include ArturoStages

  def test_renames_labels_parameters_and_destructured_names
    source = "area: function [width :integer height][\n  total: width * height\n  [a b]: @[total 1]\n  a + b\n]\n"
    assert_equal %w[a area b height total width], renamed(source)
  end

  def test_renames_the_names_that_iterators_give_their_items
    source = "loop xs 'x [print x]\nmap ys [a b] -> a + b\nselect zs 'z -> odd? z\nloop [1 2] [n] [print n]\n"
    assert_equal %w[a b n x z], renamed(source)
  end

  def test_renames_a_type_that_the_solution_defines
    source = "define :robot [\n  init: constructor [x :integer]\n]\nr: to :robot [1]\n"
    assert_equal %w[init r robot x], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "f: function [s][\n  loop [a b] 'c [print c]\n  map s => [upper &]\n  if s [print] [exit]\n  to :string size s\n]\n"
    assert_equal %w[c f s], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    leaves = []
    prepare_and_rename(source).each_descendant do |node|
      leaves << Arturo::Representation::Spec.name_text(node) if Arturo::Representation::Spec.name?(node) && node.renamed
    end
    leaves.uniq.sort
  end

  def prepare_and_rename(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Arturo::Representation::Spec)
    tree
  end
end
