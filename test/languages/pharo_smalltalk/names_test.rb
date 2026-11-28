require_relative "stage_helper"

# Checks which names Pharo Smalltalk's GenerateAST marks as defined (see
# pharo_smalltalk/representation/spec.rb), through the engine's renaming.
class PharoSmalltalkNamesTest < Minitest::Test
  include PharoSmalltalkStages

  def test_renames_the_class_and_the_variables_in_its_header
    source = <<~ST
      Class {
        #name : #Robot,
        #superclass : #Object,
        #instVars : [ 'position', 'facing' ],
        #classVars : [ 'Directions' ],
        #category : #'Exercise@Robot'
      }
    ST
    assert_equal %w[Directions Robot facing position], renamed(source)
  end

  def test_renames_methods_with_their_whole_selectors_and_parameters
    source = "Robot >> move [ ^ self at: 1 put: 2 ]\nRobot class >> at: index put: value [ ^ index ]"
    assert_equal %w[at:put: index move value], renamed(source)
  end

  def test_renames_temporaries_block_parameters_and_symbols_of_defined_selectors
    source = "Robot >> move [ | sum | sum := #(1 2) inject: 0 into: [ :a :b | a + b ]. ^ self perform: #move ]"
    assert_equal %w[#move a b move sum], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = <<~ST
      Extension { #name : #Collection }
      Collection >> total [ ^ self inject: 0 into: [ :a :b | a + b ] ]
      Integer >> + other [ ^ self ]
    ST
    assert_equal %w[a b other total], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], PharoSmalltalk::Representation::Spec)
    leaves = []
    tree.each_descendant do |node|
      leaves << node.text if PharoSmalltalk::Representation::Spec.name?(node) && node.renamed
    end
    leaves.uniq.sort
  end
end
