require_relative "stage_helper"

class RubyLeapAnalysisTest < Minitest::Test
  include RubyAnalysis

  def test_the_standard_library_check
    ["Date.leap?(year)", "Date.gregorian_leap?(year)", "Date.julian_leap? year"].each do |call|
      assert_equal ["ruby.leap.std_lib"], analyse(call), call
    end
  end

  def test_other_code_gets_no_comment
    assert_empty analyse("Date.new(year).leap?")
    assert_empty analyse("(year % 4).zero? && (year % 100 != 0 || (year % 400).zero?)")
    assert_empty comments("leap", "class Other\n  def self.leap?(year) = Date.leap?(year)\nend\n")
  end

  private
  def analyse(body) = comments("leap", "class Year\n  def self.leap?(year)\n    #{body}\n  end\nend\n")
end
