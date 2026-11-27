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
    assert_equal Representer::Languages::Ruby::Spec.version, output[:version]
    refute_nil output[:representation]
  end

  def test_a_solution_that_cant_be_represented_gets_an_error_with_the_version
    output = generate(%i[representation], { "a.rb" => "def x(" })[:representation]
    assert_equal({ error: "parse_error", message: "The code has a syntax error",
                   version: Representer::Languages::Ruby::Spec.version }, output)
  end

  def test_exercise_files_over_their_limit_make_the_representation_too_large
    tests = { "t.rb" => "x" * (Representer::MAX_EXERCISE_BYTES + 1) }
    assert_equal "too_large", generate(%i[representation], exercise_files: tests)[:representation][:error]
  end

  def test_analysis_is_not_supported_yet
    assert_equal "not_supported", generate(%i[analysis])[:analysis][:error]
  end

  def test_unknown_outputs_raise
    assert_raises(ArgumentError) { generate(%i[summary]) }
  end

  def test_outputs_are_required
    assert_raises(ArgumentError) { Representer::Generate.("ruby", { "a.rb" => "x = 1" }) }
  end
end
