module Representer
  module Engine
    # Hands out placeholders for a staged language (see StagedLanguage). Its
    # Rename stage marks each leaf that holds a name the student chose
    # (Node#renamed), and Serialize asks this class what to write for each
    # leaf. The placeholders are numbered in the order the names first
    # appear in the output.
    #
    # A name gets the same placeholder everywhere, unless the Rename stage
    # gave its leaf a scope (Node#scope). A name in a scope gets a
    # placeholder of its own there.
    class Placeholders
      attr_reader :mapping

      def initialize(language)
        @language = language
        @placeholders = {}
        @mapping = {}
      end

      # The text to write for a leaf: a placeholder, or nil to keep its own
      # text. A placeholder loses the leaf's own text, which may have said
      # what kind of name it was (`@x` or `X` in Ruby). So a placeholder for
      # any type of name except the language's first is written with its
      # type: (instance_variable PLACEHOLDER_1).
      #
      # With blank: true, a renamed name is written as `_`, and gets no
      # placeholder.
      def text_for(leaf, blank: false)
        return nil unless leaf.renamed

        prefix = @language.names.fetch(leaf.type, "")
        name = leaf.text.delete_prefix(prefix)
        text = "#{prefix}#{blank ? '_' : placeholder(name, leaf.scope)}"
        leaf.type == @language.names.keys.first ? text : "(#{leaf.type} #{text})"
      end

      private
      def placeholder(name, scope)
        @placeholders[[name, scope&.object_id]] ||=
          "PLACEHOLDER_#{@placeholders.size + 1}".tap { |placeholder| @mapping[placeholder] = name }
      end
    end
  end
end
