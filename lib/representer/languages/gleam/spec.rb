module Representer::Languages::Gleam
  class Spec < Representer::Engine::Language
    tracks "gleam"
    grammar "gleam"
    extensions ".gleam"

    # Keep an import's path as one leaf with its whole text, because the
    # grammar gives only its slashes.
    text_nodes :module # import «gleam/list»

    # Treat these as comments.
    comments_are :comment,            # let x = 1 «// The answer»
                 :statement_comment,  # «/// Adds two numbers.»
                 :module_comment      # «//// Counts things.»
  end
end
