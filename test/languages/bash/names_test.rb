require_relative "stage_helper"

# Checks Bash's declarations of which nodes are names and which nodes define
# them (see bash/representation/spec.rb), through the engine's renaming.
class BashNamesTest < Minitest::Test
  include BashStages

  def test_renames_functions_and_the_commands_that_call_them
    source = "square() { echo $(( $1 * $1 )); }\nfunction main { square \"$1\"; }\nmain \"$@\""
    assert_equal %w[main square], renamed(source)
  end

  def test_renames_the_variables_that_are_assigned_to_or_declared
    source = <<~BASH
      total=0
      local count=1 seen
      declare -A letters
      letters[a]=1
      parts+=(x)
      for word in "$@"; do echo "$word"; done
    BASH
    assert_equal %w[count letters parts seen total word], renamed(source)
  end

  def test_renames_the_variables_that_are_assigned_to_in_arithmetic
    source = "(( sum += $1 )); (( n++ )); (( --m ))\nfor ((i = 0; i < 3; i++)); do echo ${chars[i]}; done"
    assert_equal %w[i m n sum], renamed(source)
  end

  def test_renames_the_variables_that_builtins_fill
    source = <<~BASH
      read -r -d , first second
      read -ra parts <<< "$1"
      mapfile -t lines < file
      printf -v padded "%03d" "$1"
      getopts "ab:" option
    BASH
    assert_equal %w[first lines option padded parts second], renamed(source)
  end

  def test_keeps_the_names_of_bashs_own_variables
    source = "IFS=, read -r a b <<< \"$1\"\nLC_ALL=C sort\necho \"${BASH_REMATCH[1]}\" $RANDOM $REPLY"
    assert_equal %w[a b], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "source ./utils.bash\ndie \"no\"\necho \"$name\" | tr a-z A-Z"
    assert_equal [], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Bash::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Bash::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
