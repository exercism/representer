require "test_helper"

# Checks code patterns and the Normalise verbs built on them, with Ruby's
# grammar and GenerateAST stage.
class CodePatternTest < Minitest::Test
  CodePattern = Representer::Engine::CodePattern
  Ruby = Representer::Languages::Ruby

  # A language with Ruby's grammar, for stage classes of the tests' own.
  module Rubyish
    class Spec < Representer::Engine::Language
      grammar "ruby"
    end

    class Representation < Representer::Engine::Representation
      names_are :identifier, :constant, :instance_variable
      names_are :simple_symbol, without_prefix: ":"
      pattern_contexts "{{pattern}}\nend", "begin\n{{pattern}}\nend", "f {{pattern}}"
      imports 'require "{{...}}"'
    end

    module Common
      GenerateAST = Representer::Languages::Ruby::Common::GenerateAST
    end

    # A Normalise stage that drops a class's own name before a method call.
    class Within < Representer::Engine::Normalise
      rewrite "{{type}}.{{name}}",
          as: "{{name}}",
      within: "class {{type}}\nend"
    end

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
    pattern = CodePattern[Rubyish::Spec, 'require "{{file}}"']
    assert pattern.match(tree("require 'set'").children.first)
    refute pattern.match(tree("require name").children.first)
  end

  def test_nothing_labelled_comes_before_the_pattern
    pattern = CodePattern[Rubyish::Spec, 'require "{{file}}"']
    refute pattern.match(tree("Kernel.require 'set'").children.first)
  end

  def test_code_that_does_not_parse_alone_goes_in_a_context
    assert_equal %w[a b], matched("{ |{{x}}| }", "xs.each { |a| a }\nys.map do |b| b end", "x")
  end

  def test_a_keyword_read_as_a_name_moves_the_pattern_into_a_context
    assert_equal "rescue", CodePattern[Rubyish::Spec, "rescue => {{x}}"].type
  end

  def test_an_inside_context_makes_the_pattern_match_anywhere
    assert_equal %w[a b], matched("*{{x}}", "def f(*a) = 1\nxs.each { |*b| b }", "x", inside: "def f({{pattern}}) end")
  end

  def test_placeholders_are_capitalised_when_the_code_needs_it
    assert_equal %w[A], matched("class {{x}}", "class A\nend", "x")
  end

  def test_an_anonymous_placeholder_matches_any_code
    assert_equal 1, CodePattern[Rubyish::Spec, 'require "{{...}}"'].matches(tree("require 'set'").children.first).size
    assert_equal [{}], CodePattern[Rubyish::Spec, "{{...}} + {{...}}"].matches(tree("a + b").children.first)
  end

  def test_an_anonymous_placeholder_ignores_bindings
    pattern = CodePattern[Rubyish::Spec, "{{...}}.size"]
    assert pattern.match(tree("b.size").children.first, { "anything1" => tree("a").children.first })
  end

  def test_an_anonymous_placeholder_cannot_be_copied
    pattern = CodePattern[Rubyish::Spec, "f({{...}})"]
    assert_raises(ArgumentError) { pattern.build(pattern.match(tree("f(1)").children.first)) }
  end

  def test_a_word_used_twice_matches_the_same_code
    pattern = CodePattern[Rubyish::Spec, "{{x}} + {{x}}"]
    assert pattern.match(tree("a + a").children.first)
    refute pattern.match(tree("a + b").children.first)
  end

  def test_a_word_already_bound_must_match_the_same_code
    pattern = CodePattern[Rubyish::Spec, "{{x}}.size"]
    assert pattern.match(tree("a.size").children.first, { "x" => tree("a").children.first })
    refute pattern.match(tree("b.size").children.first, { "x" => tree("a").children.first })
  end

  def test_an_exact_pattern_matches_lists_with_nothing_extra
    pattern = CodePattern[Rubyish::Spec, "f({{x}}, 2)", exactly: true]
    assert pattern.match(tree("f(1, 2)").children.first)
    refute pattern.match(tree("f(1, 2, 3)").children.first)
    refute pattern.match(tree("f(0, 1, 2)").children.first)
  end

  def test_a_placeholder_in_an_exact_list_matches_one_item
    pattern = CodePattern[Rubyish::Spec, "def f({{x}}) end", exactly: true]
    assert_equal "a", pattern.match(tree("def f(a) = a + 1").children.first)["x"].text
    refute pattern.match(tree("def f(a, b) = a").children.first)
    refute pattern.match(tree("def f = 1").children.first)
  end

  def test_a_placeholder_in_a_list_of_wrapped_items_matches_every_item
    pattern = CodePattern[PHP, "f({{x}});"]
    assert_equal ["$a $b"], php_matched(pattern, "<?php f($a, $b);", "x")
    assert_equal ["$a"], php_matched(pattern, "<?php f($a);", "x")
    assert_empty php_matched(pattern, "<?php f();", "x")
  end

  def test_a_placeholder_after_a_wrapped_item_matches_the_items_after_it
    assert_equal ["$b $c"], php_matched(CodePattern[PHP, "f($a, {{x}});"], "<?php f($a, $b, $c);", "x")
  end

  def test_an_anonymous_placeholder_in_a_list_of_wrapped_items_binds_nothing
    assert_equal [{}], CodePattern[PHP, "f({{...}});"].matches(php_statement("<?php f($a, $b);"))
  end

  def test_a_placeholder_in_a_list_of_wrapped_items_builds_every_item
    bindings = CodePattern[PHP, "f({{x}});"].match(php_statement("<?php f($a, b: $c);"))
    built = CodePattern[PHP, "g({{x}});"].build(bindings)
    assert_equal write(php_statement("<?php g($a, b: $c);")), write(built)
  end

  def test_a_placeholder_in_an_exact_list_of_wrapped_items_matches_one_item
    pattern = CodePattern[PHP, "f({{x}});", exactly: true]
    assert_equal "$a", pattern.match(php_statement("<?php f($a);"))["x"].text
    refute pattern.match(php_statement("<?php f($a, $b);"))
  end

  def test_an_exact_pattern_leaves_out_parts_that_can_be_anything
    pattern = CodePattern[Rubyish::Spec, "x.max", exactly: true]
    assert pattern.match(tree("x.max(3)").children.first)
    refute CodePattern[Rubyish::Spec, "x.max(3)", exactly: true].match(tree("x.max(3, 4)").children.first)
  end

  def test_a_raw_pattern_matches_the_grammars_own_tree
    raw = CodePattern[Rubyish::Spec, "x if {{...}}", raw: true]
    assert_equal "if_modifier", raw.type
    assert_equal "if", CodePattern[Rubyish::Spec, "x if {{...}}"].type
  end

  def test_a_pattern_that_is_one_token_inside_a_node_is_that_token
    csharp = Representer::Languages::CSharp::Spec
    pattern = CodePattern[csharp, "readonly", inside: "class A { ref {{pattern}} int F() => x; }"]
    assert_equal "readonly", pattern.type
    assert_equal "modifier", CodePattern[csharp, "readonly", inside: "class A { {{pattern}} int x; }"].type
  end

  def test_normalise_rewrites_only_within_a_matching_scope
    tree = tree("class A\n  x = A.b\n  y = C.b\nend")
    Rubyish::Within.(tree)
    assert_equal write(tree("class A\n  x = b\n  y = C.b\nend")), write(tree)
  end

  def test_patterns_are_cached
    assert_same CodePattern[Rubyish::Spec, "@{{x}}"], CodePattern[Rubyish::Spec, "@{{x}}"]
  end

  def test_code_that_never_parses_is_an_error
    assert_raises(ArgumentError) { CodePattern[Rubyish::Spec, "def def def"] }
  end

  def test_normalise_drops_calls_and_matching_code
    assert_equal write(tree("x = 1")), write(normalise("puts 'hi'\nputs(x, y)\nlog if debug?\nx = 1"))
  end

  def test_normalise_rewrites_code
    assert_equal write(tree("n = xs.size\ng(1, 2)")), write(normalise("n = xs.length\nf(1, 2)"))
  end

  private
  def parse(source) = Representer::Engine::Grammar["ruby"].parse(source)
  def tree(source) = Ruby::Common::GenerateAST.(parse(source))
  def normalise(source) = Rubyish::Normalise.(tree(source))
  def write(tree) = Representer::Engine::Serialize.(tree)

  # PHP wraps each of a call's arguments in an `argument` node.
  PHP = Representer::Languages::PHP::Spec

  def php_statement(source) = Representer::Engine::PrepareFile.(PHP, source).children.first

  def php_matched(pattern, source, word)
    found = []
    php_statement(source).each_descendant do |node|
      pattern.matches(node).each { |bindings| found << bindings[word].map(&:text).join(" ") }
    end
    found
  end

  # The code that the placeholder matches, written out, in each match in
  # the source. A match of a list is written as its items, joined.
  def matched(code, source, word, inside: nil)
    pattern = CodePattern[Rubyish::Spec, code, inside:]
    found = []
    tree(source).each_descendant do |node|
      pattern.matches(node).each do |bindings|
        found << Array(bindings[word]).map { |match| match.leaf? ? match.text : write(match) }.join(" ")
      end
    end
    found
  end
end
