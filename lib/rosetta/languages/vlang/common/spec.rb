module Rosetta::Languages::Vlang::Common
  class Spec < Rosetta::Engine::Language
    tracks "vlang"
    grammar "v"
    extensions ".v"

    # Treat these as comments.
    comments_are :line_comment,  # x := 1 «// The answer»
                 :block_comment  # x := «/* The answer */» 1

    # Keep the whole text of a format in a string. The grammar leaves its
    # letter out of the tree.
    text_nodes :format_specifier # '${x«:5.2f»}'

    # Keep the text of a string, which the grammar leaves out of the tree.
    text_between_children :interpreted_string_literal,  # '«Hello, »${name}«!»'
                          :c_string_literal,            # c'«Hello»'
                          :raw_string_literal           # r'«C:\temp»'
  end
end
