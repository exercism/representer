require "test_helper"

class JqTest < RosettaTest
  track "jq"

  def test_comments_and_layout_are_ignored
    commented = <<~JQ
      # Says whether the year is a leap year.
      .year
      | . % 4 == 0 # divides by 4
        and (. % 100 != 0 or . % 400 == 0)
    JQ
    plain = ".year | . % 4 == 0 and (. % 100 != 0 or . % 400 == 0)\n"
    assert_same_representation commented, plain
  end

  def test_imports_are_dropped
    assert_same_representation "include \"lib\";\nimport \"util\" as util;\ndef f: .;\nf\n", "def f: .;\nf\n"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "def double: . * 2;\n. as $n | $n | double\n", "def twice: . * 2;\n. as $x | $x | twice\n"
  end

  def test_a_variable_in_an_object_keeps_its_key
    refute_same_representation ". as $name | {$name}\n", ". as $person | {$person}\n"
  end

  def test_names_from_outside_are_kept
    refute_same_representation ".a | length\n", ".a | keys\n"
    refute_same_representation ".a\n", ".b\n"
  end

  def test_things_that_must_stay_apart
    refute_same_representation ". + 1\n", ". - 1\n"
    refute_same_representation "\"a\"\n", "\"b\"\n"
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation ".a | (\n"
  end
end
