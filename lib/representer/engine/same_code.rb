module Representer::Engine
  # Says whether two trees hold the same code: the same types, texts and
  # children, in the same order. Either side can be a list of nodes, as a
  # placeholder in a list matches one. Field names and places in the
  # source don't count. A code pattern uses this to check that a word used
  # twice matches the same code each time (see CodePattern).
  class SameCode
    include Mandate

    initialize_with :one, :other

    def call = same?(one, other)

    private
    def same?(first, second)
      if first.is_a?(Array) || second.is_a?(Array)
        return first.is_a?(Array) && second.is_a?(Array) && first.size == second.size &&
               first.zip(second).all? { |pair| same?(*pair) }
      end
      return false unless first.type == second.type && first.named? == second.named? && first.leaf? == second.leaf?
      return first.text == second.text if first.leaf?

      same?(first.children, second.children)
    end
  end
end
