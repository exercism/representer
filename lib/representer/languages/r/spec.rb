module Representer::Languages::R
  class Spec < Representer::Engine::Language
    tracks "r"
    grammar "r"
    extensions ".R", ".r"

    # Treat these as comments.
    comments_are :comment # x <- 1 «# The answer»

    # Keep the text of integers and complex numbers, and the text between
    # the escapes of a string, which the grammar leaves out of its tree.
    text_nodes :integer, # «10L»
               :complex  # «2i»
    text_between_children :string_content # "«a»\n«b»"
  end
end
