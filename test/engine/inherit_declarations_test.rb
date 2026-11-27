require "test_helper"

# A stage or an output that subclasses another starts with its parent's
# declarations, adds its own to them, and leaves its parent's alone.
class InheritDeclarationsTest < Minitest::Test
  module Parent
    class Spec < Representer::Engine::Language
      grammar "ruby"
    end

    class Representation < Representer::Engine::Representation
      version 2
      names_are :identifier
      names_are_defined_by :def
      imports 'require "{{...}}"'
      pattern_contexts "{{pattern}}\nend"
    end

    class GenerateAST < Representer::Engine::GenerateAST
      strip_tokens "def"
      strip_tokens "|", only_in: :block_parameters
      keep_tokens ";", in: :block_parameters
      unwrap :parenthesized_statements
      numbers_are integer: :integer
    end

    class Normalise < Representer::Engine::Normalise
      drop "puts 1"
    end

    class Reorder < Representer::Engine::Reorder
      sort :hash
    end

    class Snippet < Representer::Engine::Snippet
      version 2
      remove :comments
      skip_at_top :require
    end
  end

  module Child
    class Spec < Representer::Engine::Language
      grammar "ruby"
    end

    class Representation < Parent::Representation
      version 3
      names_are :constant
      names_are_defined_by assignment: :left
      imports 'require_relative "{{...}}"'
    end

    class GenerateAST < Parent::GenerateAST
      strip_tokens "end"
      strip_tokens "&", only_in: :block_parameters
      unwrap :parenthesized_expression
    end

    class Normalise < Parent::Normalise
      drop "puts 2"
    end

    class Reorder < Parent::Reorder
      sort :class_body
    end

    class Snippet < Parent::Snippet
      skip_at_top :load
    end
  end

  def test_a_generate_ast_adds_to_its_parents_declarations
    assert_equal %w[def end], Child::GenerateAST.stripped_tokens
    assert_equal({ "block_parameters" => ["|", "&"] }, Child::GenerateAST.stripped_tokens_in)
    assert_equal({ "block_parameters" => [";"] }, Child::GenerateAST.kept_tokens_in)
    assert_equal %w[parenthesized_statements parenthesized_expression], Child::GenerateAST.unwrapped_types
    assert_equal ["integer"], Child::GenerateAST.numbers[:integer]
  end

  def test_a_generate_ast_leaves_its_parents_declarations_alone
    assert_equal ["def"], Parent::GenerateAST.stripped_tokens
    assert_equal({ "block_parameters" => ["|"] }, Parent::GenerateAST.stripped_tokens_in)
    assert_equal ["parenthesized_statements"], Parent::GenerateAST.unwrapped_types
  end

  def test_a_later_numbers_are_replaces_the_parents
    child = Class.new(Parent::GenerateAST) { numbers_are decimal: :float }
    assert_empty child.numbers[:integer]
    assert_equal ["float"], child.numbers[:decimal]
  end

  def test_a_normalise_runs_its_parents_rules_before_its_own
    assert_equal([["puts 1"], ["puts 2"]], Child::Normalise.rules.map { |rule| rule[1] })
    assert_equal([["puts 1"]], Parent::Normalise.rules.map { |rule| rule[1] })

    tree = Representer::Engine::Grammar["ruby"].parse("puts 1\nputs 2\nputs 3\n")
    calls = Child::Normalise.(tree).named_children
    assert_equal(["3"], calls.map { |call| call["arguments"].named_children.first.text })
  end

  def test_a_reorder_adds_to_its_parents_types
    assert_equal %i[hash class_body], Child::Reorder.sorted_types
    assert_equal [:hash], Parent::Reorder.sorted_types
  end

  def test_a_representation_adds_to_its_parents_declarations
    assert_equal 3, Child::Representation.version
    assert_equal({ "identifier" => "", "constant" => "" }, Child::Representation.names)
    assert_equal 2, Child::Representation.imports.size
    assert_equal ["{{pattern}}\nend"], Child::Representation.pattern_contexts
    assert_equal 2, Parent::Representation.version
    assert_equal({ "identifier" => "" }, Parent::Representation.names)
    assert_equal 1, Parent::Representation.imports.size
  end

  def test_a_representation_inherits_the_names_its_parent_defines
    definition = Representer::Engine::Node.new(:def, [Representer::Engine::Node.leaf(:identifier, "area")])
    assert_equal ["area"], Child::Representation.names_defined_by(definition).map(&:text)
  end

  def test_a_snippet_adds_to_its_parents_declarations
    assert_equal 2, Child::Snippet.version
    assert_equal [:comments], Child::Snippet.removed
    assert_equal %w[require load], Child::Snippet.skipped_words
    assert_equal ["require"], Parent::Snippet.skipped_words
  end
end
