module Inspector::Languages::FSharp::Common
  class Spec < Inspector::Engine::Language
    tracks "fsharp"
    grammar "fsharp"
    extensions ".fs", ".fsx"

    # Keep the whole text of these, because the grammar only gives their
    # quotes and marks.
    text_nodes :float,                 # «1.5»
               :verbatim_string,       # «@"a\b"»
               :triple_quoted_string,  # «"""a"""»
               :bytearray              # «"ab"B»

    # Keep the text between the children of these, because the grammar
    # leaves out the text of a string.
    text_between_children :string,        # "«a»"
                          :format_string  # $"«a»{x}«b»"

    # Treat these as comments, including XML documentation.
    comments_are :line_comment,   # let x = 1 «// The answer»
                 :block_comment,  # «(* The answer *)»
                 :xml_doc         # «/// Says hello.»
  end
end
