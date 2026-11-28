module Inspector::Engine
  # Removes the anonymous tokens (keywords and punctuation) that the node
  # types already show (see GenerateAST.strip_tokens). It removes the
  # tokens in everywhere from every node, apart from the tokens kept_in
  # keeps in a node type, and the tokens only_in gives for a node type
  # from that type.
  class StripTokens
    include Mandate
    include TreeHelpers

    initialize_with :tree, :everywhere, only_in: {}, kept_in: {}

    def call = drop_tokens(tree, everywhere:, only_in:, kept_in:)
  end
end
