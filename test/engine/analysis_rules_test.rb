require_relative "toy_language"

# Checks the verbs of an exercise's rules on the toy language, whose trees
# come straight from Ruby's grammar.
module ToyLanguage
  class Greeting < Representer::Engine::AnalysisRules
    missing("def greet({{...}})\n{{...}}\nend") { essential "toy.no_greet" }

    within "def greet({{name}})\n{{...}}\nend" do
      uses("puts {{name}}") { actionable "toy.puts_name", name: "{{name}}" }
      uses("puts {{...}}", more_than: 1) { informative "toy.puts_twice" }
      uses_all(["a = 1", "b = 2"]) { informative "toy.a_and_b" }

      first_of do
        uses("x = 1") { celebratory "toy.x" }
        uses("y = 1") { celebratory "toy.y" }
      end
    end

    uses("z = 1") do
      uses("w = 1") { informative "toy.z_and_w" }
    end

    uses(["q = 1", "u = 1"]) { informative "toy.q_or_r" }
    uses("if {{_}}\n{{...}}\nend", more_than: 1) { informative "toy.several_ifs" }
  end
end

class AnalysisRulesTest < Minitest::Test
  def test_missing_holds_when_nothing_matches
    assert_equal [{ comment: "toy.no_greet", type: "essential" }], analyse("x = 1")
  end

  def test_within_scopes_the_rules_and_shares_its_placeholders
    assert_equal ["toy.puts_name"], keys("def greet(who)\n  puts who\nend")
    assert_empty keys("def greet(who)\n  puts other\nend")
    assert_empty keys("def greet(who)\nend\nputs who")
  end

  def test_a_param_gives_the_code_of_its_placeholder
    assert_equal({ name: "who" }, analyse("def greet(who)\n  puts who\nend").first[:params])
  end

  def test_a_count_needs_more_matches_than_it_says
    assert_includes keys("def greet(a)\n  puts 1\n  puts 2\nend"), "toy.puts_twice"
    refute_includes keys("def greet(a)\n  puts 1\nend"), "toy.puts_twice"
  end

  def test_a_count_leaves_out_matches_inside_another_match
    refute_includes keys("if a\n  if b\n  end\nend"), "toy.several_ifs"
    assert_includes keys("if a\nend\nif b\nend"), "toy.several_ifs"
  end

  def test_uses_all_needs_every_code
    assert_includes keys("def greet(x)\n  a = 1\n  b = 2\nend"), "toy.a_and_b"
    refute_includes keys("def greet(x)\n  a = 1\nend"), "toy.a_and_b"
  end

  def test_first_of_runs_only_the_first_rule_that_holds
    assert_equal ["toy.x"], keys("def greet(n)\n  x = 1\n  y = 1\nend")
    assert_equal ["toy.y"], keys("def greet(n)\n  y = 1\nend")
  end

  def test_a_block_can_hold_rules_that_need_its_condition
    assert_includes keys("z = 1\nw = 1\ndef greet\nend"), "toy.z_and_w"
    refute_includes keys("w = 1\ndef greet\nend"), "toy.z_and_w"
  end

  def test_a_list_holds_if_any_code_matches
    assert_includes keys("u = 1\ndef greet\nend"), "toy.q_or_r"
  end

  def test_each_comment_comes_once
    assert_equal ["toy.q_or_r"], keys("q = 1\nu = 1\ndef greet\nend")
  end

  private
  def analyse(source)
    ToyLanguage::Greeting.(Representer::Engine::Grammar["ruby"].parse(source), source)
  end

  def keys(source) = analyse(source).map { |comment| comment[:comment] }
end
