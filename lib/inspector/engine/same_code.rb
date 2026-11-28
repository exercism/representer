module Inspector::Engine
  # Says whether two trees hold the same code: the same types, texts and
  # children, in the same order. Either side can be a list of nodes, as a
  # placeholder in a list matches one, and a list of one node is the same
  # code as that node. Field names and places in the source don't count. A
  # code pattern uses this to check that a word used twice matches the same
  # code each time (see CodePattern).
  #
  # def f({{...x}}) = {{x}}.size matches def f(a) = a.size, although the first
  # {{x}} matches a list of parameters and the second matches one node.
  class SameCode
    include Mandate

    initialize_with :one, :other

    def call = same?(one, other)

    private
    def same?(first, second)
      first, second = [first, second].map { |side| side.is_a?(Array) && side.one? ? side.first : side }
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
