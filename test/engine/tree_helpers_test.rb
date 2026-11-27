require "test_helper"

# Checks the tree operations that staged languages use.
class TreeHelpersTest < Minitest::Test
  include Representer::Engine::TreeHelpers

  Node = Representer::Engine::Node

  # A language with names, as names_in needs.
  module Names
    extend Representer::StagedLanguage

    names :identifier, :constant
  end

  def test_transform_works_from_the_leaves_up
    tree = build(:program, build(:pair, leaf(:a, "1"), build(:pair, leaf(:a, "2"), leaf(:a, "3"))))
    seen = []
    transform(tree, "(pair) @pair") { |match| seen << write(match.node) && nil }
    assert_equal ["(pair 2 3)", "(pair 1\n  (pair 2 3))"], seen
  end

  def test_transform_replaces_nodes_and_the_root
    tree = build(:program, build(:wrap, leaf(:a, "1")))
    assert_equal "(program 1)", write(transform(tree, "(wrap (_) @inner)") { |match| match[:inner] })
    assert_equal "(other)", write(transform(build(:program), "(program) @root", "(other)"))
  end

  def test_drop_and_drop_tokens
    tree = build(:program, build(:comment), token("("), build(:call, token("("), token(";")), token(";"))
    drop(tree, "(comment)")
    drop_tokens(tree, everywhere: ["("], only_in: { "program" => [";"] }, kept_in: { "call" => ["("] })
    assert_equal "(program\n  (call \"(\" ;))", write(tree)
  end

  def test_unwrap_only_takes_a_single_named_child
    tree = build(:program, build(:group, leaf(:a, "1")), build(:group, leaf(:a, "1"), leaf(:a, "2")))
    assert_equal "(program 1\n  (group 1 2))", write(unwrap(tree, "(group)"))
  end

  def test_names_in_reads_the_captured_names
    tree = build(:program, build(:def, leaf(:identifier, "f")), build(:def, leaf(:constant, "G")))
    assert_equal Set["f", "G"], names_in([tree], Names, "(def (_) @name)")
  end

  private
  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
