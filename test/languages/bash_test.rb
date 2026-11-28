require "test_helper"

class BashTest < InspectorTest
  track "bash"

  def test_comments_and_layout_are_ignored
    assert_same_representation "#!/usr/bin/env bash\n# Says hello.\nmain() {\n  # the greeting\n  echo \"hi\"\n}\n",
      "main() { echo 'hi'; }"
  end

  def test_sourced_files_are_dropped
    assert_same_representation "source ./utils.bash\necho hi\n", "echo hi"
    assert_same_representation ". ./utils.bash\necho hi\n", "echo hi"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "main() {\n  local total=$1\n  echo \"$total\"\n}\nmain \"$@\"",
      "run() {\n  local sum=$1\n  echo \"$sum\"\n}\nrun \"$@\""
  end

  def test_names_from_outside_are_kept
    refute_same_representation "echo \"$1\" | tr a-z A-Z", "echo \"$1\" | tr A-Z a-z"
    refute_same_representation "IFS=, read -r a", "OFS=, read -r a"
    refute_same_representation "echo $1", "echo $2"
  end

  def test_things_that_must_stay_apart
    refute_same_representation "(( x += 1 ))", "(( x -= 1 ))"
    refute_same_representation "(( x++ ))", "(( ++x ))"
    refute_same_representation "echo \"$@\"", "echo \"$*\""
    refute_same_representation "echo \"$x\"", "echo $x"
    refute_same_representation "a | b", "a || b"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "echo $(\n"
  end
end
