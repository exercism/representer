require "test_helper"

# Checks code patterns and the Normalise verbs built on them, with Ruby's
# grammar and GenerateAST stage.
class CodePatternTest < Minitest::Test
  CodePattern = Representer::Engine::CodePattern
  Ruby = Representer::Languages::Ruby

  # A language with Ruby's grammar, for stage classes of the tests' own.
  module Rubyish
    extend Representer::StagedLanguage

    grammar "ruby"
    names :identifier, :constant, :instance_variable, simple_symbol: ":"
    pattern_contexts "...\nend", "begin\n...\nend", "f ..."
    imports 'require "{{file}}"'

    GenerateAST = Representer::Languages::Ruby::GenerateAST

    class Normalise < Representer::Engine::Normalise
      drop_calls_to :puts
      drop "{{x}} if debug?"
      rewrite "{{list}}.length", as: "{{list}}.size"
      rewrite "f({{args}})", as: "g({{args}})"
    end
  end

  def test_a_placeholder_matches_any_code
    assert_equal ["1", "(call f\n  (argument_list 2 3))"], matched("x = {{value}}", "x = 1\nx = f(2, 3)", "value")
  end

  def test_a_placeholder_in_a_list_matches_any_number_of_items
    assert_equal ["a b c", "x"], matched("def {{method}}({{params}})", "def f(a, b, c) = 1\ndef g(x) = 1", "params")
  end

  def test_a_placeholder_in_quotes_matches_a_string
    pattern = CodePattern[Rubyish, 'require "{{file}}"']
    assert pattern.match(tree("require 'set'").children.first)
    refute pattern.match(tree("require name").children.first)
  end

  def test_nothing_labelled_comes_before_the_pattern
    pattern = CodePattern[Rubyish, 'require "{{file}}"']
    refute pattern.match(tree("Kernel.require 'set'").children.first)
  end

  def test_code_that_does_not_parse_alone_goes_in_a_context
    assert_equal %w[a b], matched("{ |{{x}}| }", "xs.each { |a| a }\nys.map do |b| b end", "x")
  end

  def test_a_keyword_read_as_a_name_moves_the_pattern_into_a_context
    assert_equal "rescue", CodePattern[Rubyish, "rescue => {{x}}"].type
  end

  def test_an_inside_context_makes_the_pattern_match_anywhere
    assert_equal %w[a b], matched("*{{x}}", "def f(*a) = 1\nxs.each { |*b| b }", "x", inside: "def f(...) end")
  end

  def test_placeholders_are_capitalised_when_the_code_needs_it
    assert_equal %w[A], matched("class {{x}}", "class A\nend", "x")
  end

  def test_patterns_are_cached
    assert_same CodePattern[Rubyish, "@{{x}}"], CodePattern[Rubyish, "@{{x}}"]
  end

  def test_code_that_never_parses_is_an_error
    assert_raises(ArgumentError) { CodePattern[Rubyish, "def def def"] }
  end

  def test_normalise_drops_calls_and_matching_code
    assert_equal write(tree("x = 1")), write(normalise("puts 'hi'\nputs(x, y)\nlog if debug?\nx = 1"))
  end

  def test_normalise_rewrites_code
    assert_equal write(tree("n = xs.size\ng(1, 2)")), write(normalise("n = xs.length\nf(1, 2)"))
  end

  private
  def parse(source) = Representer::Engine::Grammar["ruby"].parse(source)
  def tree(source) = Ruby::GenerateAST.(parse(source))
  def normalise(source) = Rubyish::Normalise.(tree(source))
  def write(tree) = Representer::Engine::Serialize.(tree, nil)

  # The code that the placeholder matches, written out, in each match in
  # the source. A match of a list is written as its items, joined.
  def matched(code, source, word, inside: nil)
    pattern = CodePattern[Rubyish, code, inside:]
    found = []
    tree(source).each_descendant do |node|
      pattern.matches(node).each do |bindings|
        found << Array(bindings[word]).map { |match| match.leaf? ? match.text : write(match) }.join(" ")
      end
    end
    found
  end
end
