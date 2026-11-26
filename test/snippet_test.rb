require "test_helper"

class SnippetTest < Minitest::Test
  def snippet(track_slug, solution_files, exercise_files = {})
    solution_files = { "solution" => solution_files } if solution_files.is_a?(String)
    Representer::Snippet.(track_slug, solution_files, exercise_files)
  end

  def config(*solution) = { ".meta/config.json" => { files: { solution: } }.to_json }

  ### The main file ###

  def test_uses_the_first_solution_file_in_the_config_that_the_student_submitted
    files = { "a.rb" => "a = 1\n", "b.rb" => "b = 1\n", "c.rb" => "c = 1\n" }
    assert_equal "c = 1\n", snippet("ruby", files, config("missing.rb", "c.rb", "b.rb"))
  end

  def test_uses_the_first_solution_file_if_the_config_names_none_of_them
    files = { "b.rb" => "b = 1\n", "a.rb" => "a = 1\n" }
    assert_equal "a = 1\n", snippet("ruby", files)
    assert_equal "a = 1\n", snippet("ruby", files, config("missing.rb"))
    assert_equal "a = 1\n", snippet("ruby", files, { ".meta/config.json" => "not json" })
    assert_equal "a = 1\n", snippet("ruby", files, { ".meta/config.json" => '{"files": ["b.rb"]}' })
  end

  ### What is removed ###

  def test_removes_comments_everywhere
    code = <<~JS
      /* The header */
      const a = 1; // one
      const b = /* two */ 2;
      /*
       * Three
       */
      function f() {
        // Add them
        return a + b; /* sum */
      }
    JS
    expected = <<~JS
      const a = 1;
      const b =  2;
      function f() {
        return a + b;
      }
    JS
    assert_equal expected, snippet("javascript", code)
  end

  def test_skips_boilerplate_only_at_the_top
    code = <<~PYTHON
      #!/usr/bin/env python
      """The module's docstring."""

      import os
      from re import match

      x = 1
      import sys

      def f():
          """The function's docstring."""
          import json
    PYTHON
    expected = <<~PYTHON
      x = 1
      import sys

      def f():
          """The function's docstring."""
          import json
    PYTHON
    assert_equal expected, snippet("python", code)
  end

  def test_skips_boilerplate_inside_a_container
    code = "module Leap\n\nopen System\n\n// The answer\nlet leapYear year = true\n"
    assert_equal "let leapYear year = true\n", snippet("fsharp", code)
  end

  ### Lines ###

  def test_drops_blank_lines_at_the_top_and_collapses_runs_of_blank_lines
    code = "\n\n\na = 1\n\n\n\nb = 2\n# A comment\n\nc = 3\n\n\n"
    assert_equal "a = 1\n\nb = 2\n\nc = 3\n", snippet("ruby", code)
  end

  def test_drops_lines_left_empty_by_a_removal
    assert_equal "a = 1\nb = 2\n", snippet("ruby", "a = 1\n  # A comment\nb = 2\n")
  end

  def test_keeps_the_first_15_lines
    code = (1..20).map { |n| "x#{n} = #{n}\n" }.join
    assert_equal (1..15).map { |n| "x#{n} = #{n}\n" }.join, snippet("ruby", code)
  end

  def test_cuts_lines_after_200_characters
    assert_equal "#{'a' * 200}\n", snippet("ruby", "#{'a' * 250}\n")
    assert_equal "a" * 200, snippet("ruby", "a" * 250)
    assert_equal "#{'a' * 200}\n", snippet("ruby", "#{'a' * 200}\n")
  end

  def test_counts_characters_when_it_cuts_a_line
    line = "x = \"#{'é' * 300}\""
    result = snippet("ruby", "#{line}\n")
    assert_equal "#{line[0, 200]}\n", result
    assert_predicate result, :valid_encoding?
  end

  ### Fallbacks ###

  def test_removes_nothing_from_a_file_that_does_not_parse
    assert_equal "# A comment\ndef x(\n", snippet("ruby", "\n# A comment\ndef x(\n")
  end

  def test_removes_nothing_from_a_file_that_nests_too_deeply
    code = "# A comment\n#{'[' * 2_000}#{']' * 2_000}\n"
    assert_equal "# A comment\n#{'[' * 200}\n", snippet("ruby", code)
  end

  def test_removes_nothing_from_a_file_that_is_too_large
    code = "# A comment\n#{"x = 1\n" * 40_000}"
    assert_equal "# A comment\n#{"x = 1\n" * 14}", snippet("ruby", code)
  end

  def test_basic_removes_the_comments_found_by_the_lexer
    code = "// A comment\n#include <stdio.h>\n\nint main() { return 0; } /* The end */\n"
    assert_equal "#include <stdio.h>\n\nint main() { return 0; }\n", snippet("c", code)
  end

  def test_basic_removes_nothing_for_a_track_with_no_lexer
    assert_equal "# A comment\n.a\n", snippet("jq", "# A comment\n.a\n")
  end
end
