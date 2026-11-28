require "test_helper"

# A small language for the engine's tests, with Ruby's grammar and
# no stages of its own. Its names are identifiers, constants and symbols.
# A `def` and an assignment define names, and `sum` is its one library
# name.
module ToyLanguage
  module Common
    class Spec < Inspector::Engine::Language
      grammar "ruby"
      extensions ".rb"
    end
  end

  module Representation
    class Spec < Inspector::Engine::Representation
      version 2
      names_are :identifier, :constant
      names_are :simple_symbol, without_prefix: ":"
      names_are_defined_by :def, assignment: :left
      imports 'require "{{...}}"'

      def self.library = Set["sum"]
    end
  end

  # Helpers for building trees by hand.
  module Trees
    Node = Inspector::Engine::Node

    def node(type, *children) = Node.new(type, children)
    def leaf(text, type = :identifier) = Node.leaf(type, text)
    def assignment(left, right) = node(:assignment, left.tap { left.field = "left" }, right)
  end
end
