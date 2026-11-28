module Representer::Languages::Idris::Common
  class Spec < Representer::Engine::Language
    tracks "idris"
    grammar "idris"
    extensions ".idr"

    # Treat these as comments, including `|||` documentation.
    comments_are :comment # x = 1 «-- The answer»

    # Read each of these nodes as one leaf, because the grammar leaves
    # their text out of the tree.
    text_nodes :data_name,       # data «Shape» = Circle | Square
               :tuple_operator,  # (a«,» b)
               :ticked_operator, # a «`div`» b
               :quantity         # («0» n : Nat) -> Nat

    # Keep the text of a string between its children, because the grammar
    # leaves it out of the tree.
    text_between_children :string,              # "«One for »\{name}«, one for me.»"
                          :triple_quote_string, # """«a»"""
                          :pat_string           # f "«a»" = 1
  end
end
