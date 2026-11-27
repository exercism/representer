require "test_helper"

class GenerateTest < Minitest::Test
  def generate(outputs, solution_files = { "a.rb" => "x = 1" }, **options)
    Representer::Generate.("ruby", solution_files, outputs:, **options)
  end

  def test_returns_the_outputs_asked_for_in_order
    assert_equal %i[snippet representation], generate(%i[snippet representation]).keys
    assert_equal %i[representation], generate(%i[representation representation]).keys
  end

  def test_the_representation_has_its_mapping_and_version
    output = generate(%i[representation], { "a.rb" => "def f(x) = x" })[:representation]
    assert_equal({ "PLACEHOLDER_1" => "f", "PLACEHOLDER_2" => "x" }, output[:mapping])
    assert_equal Representer::Languages::Ruby::Representation.version, output[:version]
    refute_nil output[:representation]
  end

  def test_a_solution_that_cant_be_represented_gets_an_error_with_the_version
    output = generate(%i[representation], { "a.rb" => "def x(" })[:representation]
    assert_equal({ error: "parse_error", message: "The code has a syntax error",
                   version: Representer::Languages::Ruby::Representation.version }, output)
  end

  def test_the_exercise_files_make_no_difference_to_the_representation
    solution = { "two_fer.rb" => "class TwoFer\n  def self.two_fer(who) = who\nend" }
    tests = { "two_fer_test.rb" => "class TwoFerTest\n  def test_x = assert_equal('x', TwoFer.two_fer('x'))\nend" }
    assert_equal generate(%i[representation], solution), generate(%i[representation], solution, exercise_files: tests)
  end

  def test_exercise_files_over_their_limit_make_the_representation_too_large
    tests = { "t.rb" => "x" * (Representer::MAX_EXERCISE_BYTES + 1) }
    assert_equal "too_large", generate(%i[representation], exercise_files: tests)[:representation][:error]
  end

  def test_the_analysis_has_the_exercises_comments_and_its_version
    solution = { "leap.rb" => "class Year\n  def self.leap?(year) = Date.leap?(year)\nend\n" }
    assert_equal({ comments: [{ comment: "ruby.leap.std_lib", type: "actionable" }],
                   version: Representer::Languages::Ruby::Analysis.version },
      generate(%i[analysis], solution, exercise_slug: "leap")[:analysis])
  end

  def test_an_analysis_that_cant_parse_its_main_file_gets_an_error_with_the_version
    output = generate(%i[analysis], { "leap.rb" => "def x(" }, exercise_slug: "leap")[:analysis]
    assert_equal({ error: "parse_error", message: "The code has a syntax error",
                   version: Representer::Languages::Ruby::Analysis.version }, output)
  end

  def test_the_analysis_and_representation_each_get_their_own_tree
    solution = { "leap.rb" => "class Year\n  def self.leap?(year) = Date.leap?(year)\nend\n" }
    outputs = generate(%i[representation analysis], solution, exercise_slug: "leap")
    assert_equal(["ruby.leap.std_lib"], outputs[:analysis][:comments].map { |comment| comment[:comment] })
    refute_nil outputs[:representation][:representation]
  end

  def test_a_track_without_analysis_rules_gets_not_supported
    output = Representer::Generate.("python", { "a.py" => "x = 1" }, outputs: %i[analysis])[:analysis]
    assert_equal "not_supported", output[:error]
  end

  def test_unknown_outputs_raise
    assert_raises(ArgumentError) { generate(%i[summary]) }
  end

  def test_outputs_are_required
    assert_raises(ArgumentError) { Representer::Generate.("ruby", { "a.rb" => "x = 1" }) }
  end
end
