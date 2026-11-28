require "test_helper"

class AwkTest < RosettaTest
  track "awk"

  def test_comments_and_layout_are_ignored
    assert_same_representation "#!/usr/bin/awk -f\n# Says hello.\nEND {\n  # the greeting\n  print \"hi\"\n}\n",
      'END { print "hi" }'
  end

  def test_imports_are_dropped
    assert_same_representation "@include \"array-utils.awk\"\n@load \"ordchr\"\n{ print $1 }\n", "{ print $1 }"
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation "function divisible(year, n) { return year % n == 0 }\n{ print divisible($1, 4) }",
      "function div(y, k) { return y % k == 0 }\n{ print div($1, 4) }"
    assert_same_representation "BEGIN { name = \"you\" }\nNF { name = $0 }\nEND { print name }",
      "BEGIN { who = \"you\" }\nNF { who = $0 }\nEND { print who }"
  end

  def test_names_from_outside_are_kept
    refute_same_representation "{ print toupper($1) }", "{ print tolower($1) }"
    refute_same_representation 'BEGIN { FS = "," }', 'BEGIN { OFS = "," }'
  end

  def test_things_that_must_stay_apart
    refute_same_representation "{ x = x + 1 }", "{ x = x - 1 }"
    refute_same_representation "{ print $1 }", "{ print $2 }"
    refute_same_representation "{ print a, b }", "{ print a b }"
    refute_same_representation "/x/", "/x/ {}"
    refute_same_representation "{ x++ }", "{ ++x }"
  end

  def test_a_shell_script_gets_basics_representation
    script = "awk '{ print $1 }' ./passwd\n"
    basic = Rosetta::Languages::Basic.(track, { "basics.sh" => script })
    assert_equal Rosetta::RepresentSolution::BASIC_PREFIX + basic.representation,
      represent(script, filename: "basics.sh").representation
  end

  def test_a_solution_that_does_not_parse_gets_basics_representation
    assert_basic_representation "{ x = (\n"
  end
end
