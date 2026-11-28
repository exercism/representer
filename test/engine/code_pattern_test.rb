require "test_helper"

# Checks code patterns and the Normalise verbs built on them, with Ruby's
# grammar and GenerateAST stage.
class CodePatternTest < Minitest::Test
  CodePattern = Representer::Engine::CodePattern
  Ruby = Representer::Languages::Ruby

  # A language with Ruby's grammar, for stage classes of the tests' own.
  module Rubyish
    module Common
      class Spec < Representer::Engine::Language
        grammar "ruby"
      end

      GenerateAST = Representer::Languages::Ruby::Common::GenerateAST
    end

    module Representation
      class Spec < Representer::Engine::Representation
        names_are :identifier, :constant, :instance_variable
        names_are :simple_symbol, without_prefix: ":"
        pattern_contexts "{{pattern}}\nend", "begin\n{{pattern}}\nend", "f {{pattern}}"
        imports 'require "{{...}}"'
      end
    end

    # A Normalise stage that drops a class's own name before a method call.
    class Within < Representer::Engine::Normalise
      rewrite "{{type}}.{{name}}",
          as: "{{name}}",
      within: "class {{type}}\n{{...}}\nend"
    end

    class Normalise < Representer::Engine::Normalise
      drop_calls_to :puts
      drop "{{x}} if debug?"
      rewrite "{{list}}.length", as: "{{list}}.size"
      rewrite "f({{...args}})", as: "g({{...args}})"
      rewrite "h(1)", as: "k(1)"
    end
  end

  def test_a_pattern_matches_only_the_code_it_names
    pattern = CodePattern[Rubyish::Common::Spec, "f(1)"]
    assert pattern.match(statement("f(1)"))
    refute pattern.match(statement("f(1, 2)"))
    refute pattern.match(statement("f()"))
    refute pattern.match(statement("x.f(1)"))
    refute pattern.match(statement("f(1) { }"))
  end

  def test_a_placeholder_matches_one_item
    assert_equal ["1", "(call f\n  (argument_list 2 3))"], matched("x = {{value}}", "x = 1\nx = f(2, 3)", "value")
    pattern = CodePattern[Rubyish::Common::Spec, "f({{x}})"]
    assert_equal "1", pattern.match(statement("f(1)"))["x"].text
    refute pattern.match(statement("f(1, 2)"))
    refute pattern.match(statement("f()"))
  end

  def test_an_underscore_matches_one_item_and_binds_nothing
    pattern = CodePattern[Rubyish::Common::Spec, "f({{_}}, 2)"]
    assert_equal({}, pattern.match(statement("f(1, 2)")))
    refute pattern.match(statement("f(2)"))
    refute pattern.match(statement("f(0, 1, 2)"))
  end

  def test_a_list_placeholder_matches_any_number_of_items_and_binds_them
    source = "def f(a, b, c) = 1\ndef g(x) = 1\ndef h() = 1"
    assert_equal ["a b c", "x", ""], matched("def {{method}}({{...params}}) = 1", source, "params")
  end

  def test_an_anonymous_list_placeholder_matches_any_number_of_items
    pattern = CodePattern[Rubyish::Common::Spec, "f(1, {{...}})"]
    assert_equal [{}], pattern.matches(statement("f(1)"))
    assert pattern.match(statement("f(1, 2)"))
    assert pattern.match(statement("f(1, 2, 3)"))
    refute pattern.match(statement("f(2, 1)"))
  end

  def test_a_list_placeholder_matches_the_statements_of_a_body
    pattern = CodePattern[Rubyish::Common::Spec, "def f\n  x = 1\n  {{...rest}}\nend"]
    assert_equal 2, pattern.match(statement("def f\n  x = 1\n  y\n  z\nend"))["rest"].size
    refute pattern.match(statement("def f\n  y\n  x = 1\nend"))
  end

  def test_a_list_node_that_holds_only_list_placeholders_also_matches_no_node
    pattern = CodePattern[Rubyish::Common::Spec, "def f({{...}})\n  {{...}}\nend"]
    assert pattern.match(statement("def f\nend"))
    assert pattern.match(statement("def f(a, b)\n  a\nend"))
  end

  def test_a_token_and_the_empty_list_after_it_can_be_left_out
    haskell = Representer::Languages::Haskell::Common::Spec
    pattern = CodePattern[haskell, "import {{...}} as {{...}} ({{...}})"]
    assert pattern.match(generated(haskell, "import Data.List\nx = 1").children.first)
    assert pattern.match(generated(haskell, "import Data.Map as M (Map)\nx = 1").children.first)
  end

  def test_a_typed_list_placeholder_matches_leaves_of_its_kind
    purescript = Representer::Languages::PureScript::Common::Spec
    pattern = CodePattern[purescript, "import {{...}} ({{...}}) as {{...}}"]
    assert pattern.match(generated(purescript, "module M where\nimport Data.Map as M\nx = 1").children[1])
    assert pattern.match(generated(purescript, "module M where\nimport Prelude\nx = 1").children[1])
  end

  def test_a_placeholder_in_quotes_matches_a_string
    pattern = CodePattern[Rubyish::Common::Spec, 'require "{{file}}"']
    assert pattern.match(tree("require 'set'").children.first)
    refute pattern.match(tree("require name").children.first)
  end

  def test_nothing_labelled_comes_before_the_pattern
    pattern = CodePattern[Rubyish::Common::Spec, 'require "{{file}}"']
    refute pattern.match(tree("Kernel.require 'set'").children.first)
  end

  def test_code_that_does_not_parse_alone_goes_in_a_context
    assert_equal %w[a b], matched("{ |{{x}}| {{...}} }", "xs.each { |a| a }\nys.map do |b| b end", "x")
  end

  def test_a_keyword_read_as_a_name_moves_the_pattern_into_a_context
    assert_equal "rescue", CodePattern[Rubyish::Common::Spec, "rescue => {{x}}"].type
  end

  def test_an_inside_context_makes_the_pattern_match_anywhere
    assert_equal %w[a b], matched("*{{x}}", "def f(*a) = 1\nxs.each { |*b| b }", "x", inside: "def f({{pattern}}) end")
  end

  def test_placeholders_are_capitalised_when_the_code_needs_it
    assert_equal %w[A], matched("class {{x}}", "class A\nend", "x")
  end

  def test_an_anonymous_placeholder_matches_any_code
    assert_equal 1, CodePattern[Rubyish::Common::Spec, 'require "{{_}}"'].matches(tree("require 'set'").children.first).size
    assert_equal [{}], CodePattern[Rubyish::Common::Spec, "{{_}} + {{_}}"].matches(tree("a + b").children.first)
  end

  def test_an_anonymous_placeholder_ignores_bindings
    pattern = CodePattern[Rubyish::Common::Spec, "{{_}}.size"]
    assert pattern.match(tree("b.size").children.first, { "anything1" => tree("a").children.first })
  end

  def test_an_anonymous_placeholder_cannot_be_copied
    pattern = CodePattern[Rubyish::Common::Spec, "f({{_}})"]
    assert_raises(ArgumentError) { pattern.build(pattern.match(tree("f(1)").children.first)) }
  end

  def test_a_word_used_twice_matches_the_same_code
    pattern = CodePattern[Rubyish::Common::Spec, "{{x}} + {{x}}"]
    assert pattern.match(tree("a + a").children.first)
    refute pattern.match(tree("a + b").children.first)
  end

  def test_a_word_already_bound_must_match_the_same_code
    pattern = CodePattern[Rubyish::Common::Spec, "{{x}}.size"]
    assert pattern.match(tree("a.size").children.first, { "x" => tree("a").children.first })
    refute pattern.match(tree("b.size").children.first, { "x" => tree("a").children.first })
  end

  def test_a_list_placeholder_in_a_list_of_wrapped_items_matches_every_item
    pattern = CodePattern[PHP, "f({{...x}});"]
    assert_equal ["$a $b"], php_matched(pattern, "<?php f($a, $b);", "x")
    assert_equal ["$a"], php_matched(pattern, "<?php f($a);", "x")
    assert_equal [""], php_matched(pattern, "<?php f();", "x")
  end

  def test_a_list_placeholder_after_a_wrapped_item_matches_the_items_after_it
    assert_equal ["$b $c"], php_matched(CodePattern[PHP, "f($a, {{...x}});"], "<?php f($a, $b, $c);", "x")
  end

  def test_an_anonymous_placeholder_in_a_list_of_wrapped_items_binds_nothing
    assert_equal [{}], CodePattern[PHP, "f({{...}});"].matches(php_statement("<?php f($a, $b);"))
  end

  def test_a_list_placeholder_in_a_list_of_wrapped_items_builds_every_item
    bindings = CodePattern[PHP, "f({{...x}});"].match(php_statement("<?php f($a, b: $c);"))
    built = CodePattern[PHP, "g({{...x}});"].build(bindings)
    assert_equal write(php_statement("<?php g($a, b: $c);")), write(built)
  end

  def test_a_placeholder_in_a_list_of_wrapped_items_matches_one_item
    pattern = CodePattern[PHP, "f({{x}});"]
    assert_equal "$a", pattern.match(php_statement("<?php f($a);"))["x"].text
    refute pattern.match(php_statement("<?php f($a, $b);"))
    refute pattern.match(php_statement("<?php f();"))
  end

  def test_a_placeholder_can_be_wrapped_in_several_nodes
    d = Representer::Languages::D::Common::Spec
    pattern = CodePattern[d, "import {{...}};"]
    assert pattern.match(generated(d, "module m;\nimport std.algorithm, std.range;\nvoid f() {}").children[1])
  end

  def test_a_raw_pattern_matches_the_grammars_own_tree
    raw = CodePattern[Rubyish::Common::Spec, "x if {{_}}", raw: true]
    assert_equal "if_modifier", raw.type
    assert_equal "if", CodePattern[Rubyish::Common::Spec, "x if {{_}}"].type
  end

  def test_a_pattern_that_is_one_token_inside_a_node_is_that_token
    csharp = Representer::Languages::CSharp::Common::Spec
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
    assert_same CodePattern[Rubyish::Common::Spec, "@{{x}}"], CodePattern[Rubyish::Common::Spec, "@{{x}}"]
  end

  def test_code_that_never_parses_is_an_error
    assert_raises(ArgumentError) { CodePattern[Rubyish::Common::Spec, "def def def"] }
  end

  def test_normalise_drops_calls_and_matching_code
    assert_equal write(tree("x = 1")), write(normalise("puts 'hi'\nputs(x, y)\nlog if debug?\nx = 1"))
  end

  def test_normalise_rewrites_code
    assert_equal write(tree("n = xs.size\ng(1, 2)\nk(1)\nh(1, 2)")), write(normalise("n = xs.length\nf(1, 2)\nh(1)\nh(1, 2)"))
  end

  def test_code_of_several_top_level_items_drops_each_run_of_them
    pattern = CodePattern[Rubyish::Common::Spec, "a\n{{...}}\nb"]
    assert pattern.run?
    assert_equal "(program c)", write(helpers.drop(tree("a\n1\n2\nb\nc\na\nb"), pattern))
  end

  def test_a_placeholder_at_the_end_of_a_run_matches_one_child
    pattern = CodePattern[Rubyish::Common::Spec, "a\n{{_}}"]
    assert_equal "(program 2 3)", write(helpers.drop(tree("a\n1\n2\n3"), pattern))
  end

  def test_a_run_can_only_be_dropped
    assert_raises(ArgumentError) { CodePattern[Rubyish::Common::Spec, "a\nb"].match(tree("a\nb")) }
  end

  # A language with Ruby's grammar and a placeholder suffix of its own.
  module Suffixed
    module Common
      class Spec < Representer::Engine::Language
        grammar "ruby"
      end

      GenerateAST = Representer::Languages::Ruby::Common::GenerateAST
    end

    module Representation
      class Spec < Representer::Engine::Representation
        names_are :identifier
        placeholder_suffix "_ph"
      end
    end
  end

  def test_a_language_can_spell_its_placeholders_with_another_suffix
    pattern = CodePattern[Suffixed::Common::Spec, "x = {{value}}"]
    assert_equal "1", pattern.match(tree("x = 1").children.first)["value"].text
  end

  def test_a_language_can_use_one_of_the_grammars_keywords_as_a_name
    language = Representer::Languages::CommonLisp::Common::Spec
    pattern = CodePattern[language, ":cl"]
    file = Representer::Engine::PrepareFile.(language, "(f :cl)")
    found = []
    file.each_descendant { |node| found << node if pattern.match(node) }
    assert_equal 1, found.size
  end

  private
  def parse(source) = Representer::Engine::Grammar["ruby"].parse(source)
  def tree(source) = Ruby::Common::GenerateAST.(parse(source))
  def statement(source) = tree(source).children.first
  def normalise(source) = Rubyish::Normalise.(tree(source))
  def write(tree) = Representer::Engine::Serialize.(tree)
  def helpers = Object.new.extend(Representer::Engine::TreeHelpers)

  def generated(language, source)
    language.run_stage(:GenerateAST, Representer::Engine::Grammar[language.grammar].parse(source, **language.parse_options))
  end

  # PHP wraps each of a call's arguments in an `argument` node.
  PHP = Representer::Languages::PHP::Common::Spec

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
    pattern = CodePattern[Rubyish::Common::Spec, code, inside:]
    found = []
    tree(source).each_descendant do |node|
      pattern.matches(node).each do |bindings|
        found << Array(bindings[word]).map { |match| match.leaf? ? match.text : write(match) }.join(" ")
      end
    end
    found
  end
end
