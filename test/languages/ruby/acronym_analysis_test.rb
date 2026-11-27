require_relative "stage_helper"

class RubyAcronymAnalysisTest < Minitest::Test
  include RubyAnalysis

  def test_a_block_that_only_calls_chr
    assert_equal ["ruby.acronym.block_syntax.shorthand"], analyse('phrase.tr("-", " ").split.map { |word| word.chr }.join.upcase')
    assert_equal ["ruby.acronym.block_syntax.shorthand"], analyse('phrase.tr("-", " ").split(" ").map { |w| w.chr }.join.upcase')
  end

  def test_other_chains_get_no_comment
    assert_empty analyse('phrase.tr("-", " ").split.map(&:chr).join.upcase')
    assert_empty analyse("phrase.scan(/\\b\\w/).join.upcase")
    assert_empty analyse('phrase.tr("-", " ").split.map { |word| word[0] }.join.upcase')
  end

  private
  def analyse(body) = comments("acronym", "module Acronym\n  def self.abbreviate(phrase)\n    #{body}\n  end\nend\n")
end
