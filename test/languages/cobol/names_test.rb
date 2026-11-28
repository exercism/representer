require_relative "stage_helper"

# Checks which names COBOL's GenerateAST marks as defined (see
# cobol/representation/spec.rb), through the engine's renaming.
class CobolNamesTest < Minitest::Test
  include CobolStages

  def test_renames_the_program_its_data_items_and_its_condition_names
    source = program("MOVE 1 TO WS-X.", data: "01 WS-X PIC 9.\n  88 WS-ONE VALUE 1.\n01 FILLER PIC X.")
    assert_equal %w[p ws-one ws-x], renamed(source)
  end

  def test_renames_paragraphs_sections_and_index_names
    source = program("MAIN SECTION.\nSTART-HERE.\nPERFORM START-HERE.\nSET IDX TO 1.",
                     data: "01 WS-TABLE.\n  05 WS-ITEM PIC 9 OCCURS 3 TIMES INDEXED BY IDX.")
    assert_equal %w[idx main p start-here ws-item ws-table], renamed(source)
  end

  def test_renames_names_whatever_their_case
    source = program("MOVE 1 TO Ws-X.", data: "01 ws-x PIC 9.")
    assert_equal %w[p ws-x], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = program("MOVE FUNCTION UPPER-CASE(WS-X) TO WS-X.\nDISPLAY FUNCTION TRIM(WS-X).", data: "01 WS-X PIC X.")
    assert_equal %w[p ws-x], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Cobol::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Cobol::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
