require "test_helper"

class AnalyseTest < Minitest::Test
  Analysis = Representer::Languages::Ruby::Analysis::Spec

  def test_runs_the_exercises_rules_on_the_main_file
    files = { "a_helper.rb" => "x = 1", "leap.rb" => "class Year\n  def self.leap?(y) = Date.leap?(y)\nend\n" }
    config = { ".meta/config.json" => '{"files": {"solution": ["leap.rb"]}}' }
    assert_equal(["ruby.leap.std_lib"], analyse("leap", files, config).map { |comment| comment[:comment] })
  end

  def test_runs_the_analysis_normalise_stage_first
    files = { "leap.rb" => "class Year\n  class << self\n    def leap?(y) = Date.leap?(y)\n  end\nend\n" }
    assert_equal(["ruby.leap.std_lib"], analyse("leap", files).map { |comment| comment[:comment] })
  end

  def test_an_exercise_without_rules_gets_no_comments
    assert_empty analyse("bob", { "bob.rb" => "def x(" })
  end

  def test_a_main_file_that_does_not_parse_cannot_be_analysed
    error = assert_raises(Representer::CannotRepresent) { analyse("leap", { "leap.rb" => "def x(" }) }
    assert_equal "parse_error", error.reason
  end

  private
  def analyse(slug, files, exercise_files = {}) = Representer::Engine::Analyse.(Analysis, slug, files, exercise_files)
end
