module Rosetta::Languages::Sqlite::Common
  class Spec < Rosetta::Engine::Language
    tracks "sqlite"
    grammar "sql"
    extensions ".sql"

    # Treat these as comments.
    comments_are :comment,   # x = 1 «-- The answer»
                 :marginalia # «/* The answer */»

    # Read each literal and each name as its whole text, because the grammar
    # leaves the digits of `-1` and the name inside `` `a` `` out of the tree.
    text_nodes :literal, :identifier
  end
end
