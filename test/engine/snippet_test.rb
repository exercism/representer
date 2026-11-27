require "test_helper"

class SnippetTest < Minitest::Test
  # A Ruby snippet, unless a track is given.
  def snippet(solution_files, exercise_files = {}, track: "ruby")
    solution_files = { "solution" => solution_files } if solution_files.is_a?(String)
    Representer::Generate.(track, solution_files, outputs: [:snippet], exercise_files:)[:snippet][:snippet]
  end

  def config(*solution) = { ".meta/config.json" => { files: { solution: } }.to_json }

  ### The main file ###

  def test_uses_the_first_solution_file_in_the_config_that_the_student_submitted
    files = { "a.rb" => "a = 1\n", "b.rb" => "b = 1\n", "c.rb" => "c = 1\n" }
    assert_equal "c = 1\n", snippet(files, config("missing.rb", "c.rb", "b.rb"))
  end

  def test_uses_the_first_solution_file_if_the_config_names_none_of_them
    files = { "b.rb" => "b = 1\n", "a.rb" => "a = 1\n" }
    assert_equal "a = 1\n", snippet(files)
    assert_equal "a = 1\n", snippet(files, config("missing.rb"))
    assert_equal "a = 1\n", snippet(files, { ".meta/config.json" => "not json" })
    assert_equal "a = 1\n", snippet(files, { ".meta/config.json" => '{"files": ["b.rb"]}' })
  end

  ### What is removed ###

  def test_removes_comments_everywhere
    code = <<~RUBY
      # frozen_string_literal: true

      =begin
      Write your code for the 'Leap' exercise in this file.
      =end
      class Year # A year
        # Is it a leap year?
        def self.leap?(year) = (year % 4).zero? # Every fourth year
      end
    RUBY
    expected = <<~RUBY
      class Year
        def self.leap?(year) = (year % 4).zero?
      end
    RUBY
    assert_equal expected, snippet(code)
  end

  def test_skips_requires_only_at_the_top
    code = <<~RUBY
      require 'set'
      # The other file
      require_relative "helpers"

      requirement = 1
      require 'json'
    RUBY
    assert_equal "requirement = 1\nrequire 'json'\n", snippet(code)
  end

  def test_skips_a_require_that_spans_lines
    assert_equal "x = 1\n", snippet("require(\n  'set'\n)\nx = 1\n")
  end

  ### Lines ###

  def test_drops_blank_lines_at_the_top_and_collapses_runs_of_blank_lines
    code = "\n\n\na = 1\n\n\n\nb = 2\n# A comment\n\nc = 3\n\n\n"
    assert_equal "a = 1\n\nb = 2\n\nc = 3\n", snippet(code)
  end

  def test_drops_lines_left_empty_by_a_removal
    assert_equal "a = 1\nb = 2\n", snippet("a = 1\n  # A comment\nb = 2\n")
  end

  def test_keeps_the_first_15_lines
    code = (1..20).map { |n| "x#{n} = #{n}\n" }.join
    assert_equal (1..15).map { |n| "x#{n} = #{n}\n" }.join, snippet(code)
  end

  def test_cuts_lines_after_200_characters
    assert_equal "#{'a' * 200}\n", snippet("#{'a' * 250}\n")
    assert_equal "a" * 200, snippet("a" * 250)
    assert_equal "#{'a' * 200}\n", snippet("#{'a' * 200}\n")
  end

  def test_counts_characters_when_it_cuts_a_line
    line = "x = \"#{'é' * 300}\""
    result = snippet("#{line}\n")
    assert_equal "#{line[0, 200]}\n", result
    assert_equal "é", result[199]
    assert_predicate result, :valid_encoding?
  end

  ### Fallbacks ###

  def test_a_file_that_does_not_parse_loses_the_comments_found_by_the_lexer
    code = "# A comment\nrequire 'set'\n\ndef x( # Oops\n#{"y\n" * 20}"
    assert_equal "def x(\n#{"y\n" * 14}", snippet(code)
  end

  def test_a_file_that_nests_too_deeply_loses_the_comments_found_by_the_lexer
    code = "# A comment\n#{'[' * 2_000}#{']' * 2_000}\n"
    assert_equal "#{'[' * 200}\n", snippet(code)
  end

  def test_a_file_that_is_too_large_gets_its_first_lines
    code = "# A comment\n#{"x = 1\n" * 40_000}"
    assert_equal "# A comment\n#{"x = 1\n" * 14}", snippet(code)
  end

  def test_a_file_that_does_not_parse_still_has_its_lines_cut
    assert_equal "def x(#{'a' * 194}\n", snippet("def x(#{'a' * 300}\n")
  end

  ### Other languages ###

  def test_every_language_with_a_representation_has_a_snippet
    languages = Representer::Languages.registry.values.uniq - [Representer::Languages::Basic]
    languages.each do |language|
      refute_equal Representer::Languages::Basic::Snippet, Representer::Languages.snippet_for(language.tracks.first), language.name
    end
  end

  def test_every_track_gets_a_snippet
    %w[ruby python cobol kotlin odin].each do |track|
      assert_equal "x\n", snippet("x\n", track:), track
    end
  end

  def test_removes_docstrings
    code = <<~PYTHON
      """The module's docstring."""
      import os

      def f():
          """The function's docstring."""
          x = "A string that is used"
          return x
    PYTHON
    expected = <<~PYTHON
      def f():
          x = "A string that is used"
          return x
    PYTHON
    assert_equal expected, snippet(code, track: "python")
  end

  def test_removes_elixir_docs
    code = <<~ELIXIR
      defmodule Leap do
        @moduledoc """
        Leap years.
        """

        @doc "Is it a leap year?"
        @spec leap_year?(integer) :: boolean
        def leap_year?(year), do: rem(year, 4) == 0
      end
    ELIXIR
    expected = <<~ELIXIR
      defmodule Leap do

        @spec leap_year?(integer) :: boolean
        def leap_year?(year), do: rem(year, 4) == 0
      end
    ELIXIR
    assert_equal expected, snippet(code, track: "elixir")
  end

  def test_skips_only_the_header_of_a_container
    code = "module Leap\n\nopen System\n\n// The answer\nlet leapYear year = true\n"
    assert_equal "let leapYear year = true\n", snippet(code, track: "fsharp")
  end

  def test_skips_a_namespace_header_and_its_closing_brace
    code = "#include <string>\n\nnamespace leap {\n\nusing namespace std;\n\n" \
           "bool is_leap(int y) { return y % 4 == 0; }\n\n}  // namespace leap\n"
    assert_equal "bool is_leap(int y) { return y % 4 == 0; }\n", snippet(code, track: "cpp")
  end

  def test_keeps_the_containers_if_skipping_leaves_nothing
    code = "#include \"list_ops.h\"\n\nnamespace list_ops {\n\n}  // namespace list_ops\n"
    assert_equal "namespace list_ops {\n\n}\n", snippet(code, track: "cpp")
  end

  def test_skips_the_punctuation_between_skipped_statements
    assert_equal "sub f { }\n", snippet("unit module Leap;\nuse Test;\n\nsub f { }\n", track: "raku")
  end

  def test_keeps_a_keyword_token_at_the_top
    assert_equal "pub fn f() void {}\n", snippet("const std = @import(\"std\");\n\npub fn f() void {}\n", track: "zig")
  end

  ### Tracks with no language of their own ###

  def test_removes_the_comments_found_by_the_lexer
    code = "// A comment\n#include <stdio.h>\n\nint main() { return 0; } /* The end */\n#include <math.h>\n"
    assert_equal "int main() { return 0; }\n#include <math.h>\n", snippet(code, track: "c")
  end

  def test_skips_the_lines_that_continue_a_skipped_line
    code = "module Zipper (\n    BinTree(..),\n\n    fromTree\n) where\n\nimport Data.List\n  (sort)\n\nzipper = 1\n  where x = 2\n"
    assert_equal "zipper = 1\n  where x = 2\n", snippet(code, track: "haskell")
  end

  def test_skips_a_block_at_the_top
    code = "CLASS zcl_leap DEFINITION PUBLIC.\n  PUBLIC SECTION.\nENDCLASS.\n\n" \
           "CLASS zcl_leap IMPLEMENTATION.\n  METHOD leap.\n  ENDMETHOD.\n"
    assert_equal "  METHOD leap.\n  ENDMETHOD.\n", snippet(code, track: "abap")
  end

  def test_removes_lines_that_start_with_a_word_wherever_they_are
    code = ".globl recite\n\n.data\nlyrics: .asciiz \"x\"\n\n.text\nrecite:\n        jr $ra\n"
    assert_equal "lyrics: .asciiz \"x\"\n\nrecite:\n        jr $ra\n", snippet(code, track: "mips")
  end

  def test_skips_lines_at_the_bottom
    assert_equal "def x := 1\n", snippet("import Std\nnamespace Leap\n\ndef x := 1\n\nend Leap\n", track: "lean")
  end

  def test_finds_comments_by_their_markers_for_a_track_with_no_lexer
    code = <<~ODIN
      package leap

      // A comment
      /*
        A block
      */
      is_leap :: proc(year: int) -> bool { // Is it?
        return "a // b" == "a" // Never
      }
    ODIN
    expected = <<~ODIN
      is_leap :: proc(year: int) -> bool {
        return "a // b" == "a"
      }
    ODIN
    assert_equal expected, snippet(code, track: "odin")
  end

  def test_keeps_a_marker_that_might_be_in_a_string
    assert_equal "x = \"a // b\n", snippet("x = \"a // b\n", track: "odin")
  end

  def test_a_track_with_no_lexer_and_no_rules_gets_its_first_lines_with_blank_lines_tidied
    assert_equal "# A comment\n\nx\n", snippet("\n# A comment\n\n\nx\n", track: "05ab1e")
  end

  ### Rules ###

  def test_rejects_unknown_rules
    assert_raises(ArgumentError) { Class.new(Representer::Engine::Snippet).remove(:strings) }
  end

  def test_the_main_file_is_parsed_once_for_the_snippet_and_the_representation
    source = "# A comment\nx = 1\n"
    parses = 0
    counting = Module.new do
      define_method(:parse) do |code, **options|
        parses += 1 if code == source
        super(code, **options)
      end
    end
    Representer::Engine::Grammar["ruby"].singleton_class.prepend(counting)
    output = Representer::Generate.("ruby", { "a.rb" => source }, outputs: %i[representation snippet])
    assert_equal 1, parses
    assert_equal "x = 1\n", output[:snippet][:snippet]
    assert_equal Representer::Generate.("ruby", { "a.rb" => "x = 1\n" }, outputs: %i[representation]), output.slice(:representation)
  ensure
    counting&.send(:remove_method, :parse)
  end

  def test_a_bug_in_a_rule_gives_the_snippet_an_error
    Representer::Languages.register_snippet("broken", Class.new(Representer::Engine::Snippet) { def call = raise("Oops") })
    output = nil
    _, log = capture_io { output = Representer::Generate.("broken", { "a" => "x" }, outputs: %i[snippet]) }
    assert_equal({ error: "internal_error", message: "One of the snippet's rules raised an error" }, output[:snippet])
    assert_includes log, "broken"
  ensure
    Representer::Languages.snippets.delete("broken")
  end

  def test_the_snippet_has_its_own_version
    output = Representer::Generate.("ruby", { "a.rb" => "x" }, outputs: %i[snippet])
    assert_equal Representer::Languages::Ruby::Snippet.version, output[:snippet][:version]
  end

  def test_a_language_reads_its_comments_and_docstrings_from_its_spec
    fsharp = "module Leap\n/// Says whether the year is a leap year.\nlet leap year = true\n"
    assert_equal "let leap year = true\n", snippet({ "Leap.fs" => fsharp }, track: "fsharp")
    elixir = "defmodule Leap do\n  @doc false\n  def leap?(year), do: true\nend\n"
    assert_equal "defmodule Leap do\n  def leap?(year), do: true\nend\n", snippet({ "leap.ex" => elixir }, track: "elixir")
  end
end
