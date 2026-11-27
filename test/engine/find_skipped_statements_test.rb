require_relative "snippet_rules"

class FindSkippedStatementsTest < Minitest::Test
  def skipped(source, rules = SnippetRules::RubySnippet)
    ranges = Representer::Engine::FindSkippedStatements.(rules, SnippetRules.parse(source), source)
    ranges.map { |range| source.byteslice(range) }
  end

  def test_skips_the_statements_at_the_top_that_start_with_a_word
    assert_equal ["require 'set'", "require 'json'"], skipped("require 'set'\nrequire 'json'\nx = 1\n")
  end

  def test_stops_at_the_first_other_statement
    assert_equal ["require 'set'"], skipped("require 'set'\nx = 1\nrequire 'json'\n")
  end

  def test_skips_the_comments_between_them
    assert_equal ["require 'set'", "# Sets", "require 'json'"], skipped("require 'set'\n# Sets\nrequire 'json'\nx = 1\n")
  end

  def test_matches_whole_words_only
    assert_empty skipped("requirement = 1\n")
  end
end
