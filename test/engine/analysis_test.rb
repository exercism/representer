require "test_helper"

# Checks the analysis output with Ruby's, which has rules for some exercises.
class AnalysisTest < Minitest::Test
  Ruby = Inspector::Languages::Ruby

  def test_belongs_to_the_spec_beside_it
    assert_equal Ruby::Common::Spec, Ruby::Analysis::Spec.language
    assert_equal Ruby::Analysis::Spec, Ruby::Common::Spec.analysis
  end

  def test_finds_the_rules_for_an_exercise_by_its_slug
    assert_equal Ruby::Analysis::TwoFer, Ruby::Analysis::Spec.rules_for("two-fer")
    assert_equal Ruby::Analysis::HighScores, Ruby::Analysis::Spec.rules_for("high-scores")
    assert_nil Ruby::Analysis::Spec.rules_for("bob")
    assert_nil Ruby::Analysis::Spec.rules_for("normalise")
  end

  def test_rejects_a_version_out_of_range
    assert_raises(ArgumentError) { Ruby::Analysis::Spec.version(0) }
  end
end
