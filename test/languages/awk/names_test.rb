require_relative "stage_helper"

# Checks AWK's declarations of which nodes are names and which nodes define
# them (see awk/representation.rb), through the engine's renaming.
class AwkNamesTest < Minitest::Test
  include AwkStages

  def test_renames_functions_and_their_parameters
    source = "function area(width, height,    result) { result = width * height; return result }\n" \
             "{ print area($1, $2) }"
    assert_equal %w[area height result width], renamed(source)
  end

  def test_renames_the_variables_that_are_assigned_to_or_changed
    source = "BEGIN { total = 0 }\n{ count++; sum += $1; seen[$1] = 1 }\n" \
             "END { for (key in seen) print key; delete cache; while ((getline line < file) > 0) n++ }"
    assert_equal %w[cache count key line n seen sum total], renamed(source)
  end

  def test_renames_the_variables_that_builtins_fill
    source = '{ n = split($0, parts, ","); gsub(/a/, "b", word); match($0, /x/, groups); asort(parts, sorted) }'
    assert_equal %w[groups n parts sorted word], renamed(source)
  end

  def test_keeps_the_names_of_awks_own_variables
    source = <<~AWK
      BEGIN { FS = ":"; OFS = "-"; NR = 0 }
      { PROCINFO["sorted_in"] = "@ind_num_asc"; print NF, $NF }
    AWK
    assert_equal [], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "@load \"ordchr\"\n{ x = ord($1); print chr(x), name, toupper($1) }"
    assert_equal %w[x], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Awk::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Awk::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
