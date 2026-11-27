require_relative "snippet_rules"

class SkipLinesTest < Minitest::Test
  def skip(text) = Representer::Engine::SkipLines.(SnippetRules::LinesSnippet, text.lines).join

  def test_skips_the_lines_at_the_top_that_start_with_a_word
    assert_equal "x = 1\nimport b\n", skip("import a\n\nx = 1\nimport b\n")
  end

  def test_skips_the_lines_that_continue_a_skipped_line
    assert_equal "x = 1\n", skip("import a (\n  b,\n\n  c\n)\nx = 1\n")
  end

  def test_skips_a_block
    assert_equal "x = 1\n", skip("BEGIN\n  stuff\nEND\nx = 1\n")
  end

  def test_skips_lines_at_the_bottom
    assert_equal "x = 1\n", skip("x = 1\n\nend\n")
  end
end
