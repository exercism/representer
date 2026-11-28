module Inspector::Languages::Haskell::Common
  class Spec < Inspector::Engine::Language
    tracks "haskell"
    grammar "haskell"
    extensions ".hs"

    # Treat these as comments, including Haddock documentation.
    comments_are :comment,  # x = 1 «-- The answer»
                 :haddock   # «-- | Says hello.»

    # Read each operator as one leaf. The grammar gives some operators,
    # such as `*`, as a node that holds the operator's token.
    text_nodes :operator # a «*» b
  end
end
