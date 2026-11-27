require "test_helper"

# A small staged language for the engine's tests, with Ruby's grammar and
# no stages of its own. Its names are identifiers, constants and symbols.
# A `def` and an assignment define names, and `sum` is its one library
# name.
module ToyLanguage
  extend Representer::StagedLanguage

  grammar "ruby"
  names_are :identifier, :constant, simple_symbol: ":"
  names_are_defined_by :def, assignment: :left
  imports 'require "{{file}}"'

  def self.library = Set["sum"]

  # Helpers for building trees by hand.
  module Trees
    Node = Representer::Engine::Node

    def node(type, *children) = Node.new(type, children)
    def leaf(text, type = :identifier) = Node.leaf(type, text)
    def assignment(left, right) = node(:assignment, left.tap { left.field = "left" }, right)
  end
end
