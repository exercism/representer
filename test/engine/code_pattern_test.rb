require "test_helper"

# Checks code patterns and the stage verbs built on them, with Ruby's
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
    imports 'require "$file"'

    GenerateAST = Representer::Languages::Ruby::GenerateAST

    class Normalise
      extend Representer::Engine::NormaliseStage

      drop_calls_to :puts
      drop "$x if debug?"
      rewrite "$list.length", as: "$list.size"
      rewrite "f($args)", as: "g($args)"
    end

    class Rename
      extend Representer::Engine::RenameStage

      rename_locals "$name = $value", "{ |$name| }"
      rename_members "def $name"
      rename_member_uses "$object.$name"
      keep "$name:", inside: "def f(...) end"
    end
  end

  def test_name_matches_a_name_of_the_kind_written
    assert_equal %w[@a], names("@$name", "@a = b\nc = @a")
    assert_equal %w[c], names("$name = $value", "@a = b\nc = @a")
  end

  def test_other_placeholders_match_any_code
    assert_equal %w[x y], names("$name = $value", "x = 1\ny = f(2, 3)")
  end

  def test_a_placeholder_in_a_list_matches_any_number_of_items
    assert_equal %w[a b c], names("def $method($name)", "def f(a, b, c) = 1")
    assert_equal %w[a b c], names("$name, $more", "a, b, c = 1", inside: "... = 1")
  end

  def test_a_placeholder_in_quotes_matches_a_string
    pattern = CodePattern[Rubyish, 'require "$file"']
    assert pattern.match(tree("require 'set'").children.first)
    refute pattern.match(tree("require name").children.first)
  end

  def test_nothing_labelled_comes_before_the_pattern
    pattern = CodePattern[Rubyish, 'require "$file"']
    refute pattern.match(tree("Kernel.require 'set'").children.first)
  end

  def test_code_that_does_not_parse_alone_goes_in_a_context
    assert_equal %w[a b], names("{ |$name| }", "xs.each { |a| a }\nys.map do |b| b end")
    assert_equal %w[a], names("def $method($name)", "def f(a)\n  a\nend")
  end

  def test_a_keyword_read_as_a_name_moves_the_pattern_into_a_context
    assert_equal "rescue", CodePattern[Rubyish, "rescue => $name"].type
  end

  def test_an_inside_context_makes_the_pattern_match_anywhere
    assert_equal %w[a b], names("*$name", "def f(*a) = 1\nxs.each { |*b| b }", inside: "def f(...) end")
  end

  def test_placeholders_are_capitalised_when_the_code_needs_it
    assert_equal %w[A], names("class $name", "class A\nend")
  end

  def test_patterns_are_cached
    assert_same CodePattern[Rubyish, "@$name"], CodePattern[Rubyish, "@$name"]
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

  def test_the_engine_drops_imports
    assert_equal write(tree("x = 1")), write(Rubyish.prepare(parse("require 'set'\nx = 1")))
  end

  def test_rename_marks_locals_members_and_their_uses
    trees = [Rubyish.prepare(parse("def go(k:) = k\nx = 1\nxs.each { |y| y.go }\nz.size"))]
    assert_equal Set["go"], Rubyish::Rename.(trees, Set.new)
    marked = []
    Representer::Engine::Names.each_name(Rubyish, trees.first) { |leaf, name| marked << name if leaf.renamed }
    assert_equal %w[go x y y go], marked
  end

  private
  def parse(source) = Representer::Engine::Grammar["ruby"].parse(source)
  def tree(source) = Ruby::GenerateAST.(parse(source))
  def normalise(source) = Rubyish::Normalise.(tree(source))
  def write(tree) = Representer::Engine::Serialize.(tree, nil)

  # The names that the pattern's $name matches in the source, sorted.
  def names(code, source, inside: nil)
    pattern = CodePattern[Rubyish, code, inside:]
    names = []
    tree(source).each_descendant do |node|
      pattern.matches(node).each { |bindings| names << bindings["name"].text }
    end
    names.uniq.sort
  end
end
