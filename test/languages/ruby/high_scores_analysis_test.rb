require_relative "stage_helper"

class RubyHighScoresAnalysisTest < Minitest::Test
  include RubyAnalysis

  METHODS = <<~RUBY.freeze
    def initialize(scores)
      @scores = scores
    end

    def latest
      scores.last
    end

    def personal_best
      scores.max
    end

    def personal_top_three
      scores.max(3)
    end

    def latest_is_personal_best?
      latest == personal_best
    end
  RUBY

  def test_the_exemplar_gets_no_comment
    assert_empty analyse("attr_reader :scores\n\n#{METHODS}")
  end

  def test_a_hand_written_reader
    assert_equal ["ruby.high-scores.attr_reader"], analyse("#{METHODS}\ndef scores\n  @scores\nend")
  end

  def test_indentation
    assert_equal ["ruby.general.incorrect_indentation"], analyse("attr_reader :scores\n\n#{METHODS}", indent: "   ")
  end

  def test_another_member_leaves_the_class_to_a_mentor
    assert_empty analyse("#{METHODS}\ndef scores\n  @scores\nend\n\ndef extra = 1")
  end

  private
  def analyse(body, indent: "  ") = comments("high-scores", "class HighScores\n#{body.gsub(/^(?=.)/, indent)}\nend\n")
end
