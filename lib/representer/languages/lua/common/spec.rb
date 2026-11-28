module Representer::Languages::Lua::Common
  class Spec < Representer::Engine::Language
    tracks "lua"
    grammar "lua"
    extensions ".lua"

    # Treat these as comments.
    comments_are :comment # local x = 1 «-- The answer»

    # Keep the text between the escapes of a string, which the grammar
    # leaves out of its tree.
    text_between_children :string_content # "«a»\n«b»"
  end
end
