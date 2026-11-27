module Representer::Languages::Cairo
  class Spec < Representer::Engine::Language
    tracks "cairo"
    grammar "cairo"
    extensions ".cairo"

    # Treat these as comments, including doc comments.
    comments_are :line_comment # let x = 1; «// The answer», «/// Says hello.»

    # Keep each string and short string as a leaf with its whole text,
    # because the grammar leaves their text out of the tree.
    # "abc"  ->  (string_literal "abc")
    # 'abc'  ->  (shortstring_literal 'abc')
    text_nodes :string_literal, :shortstring_literal
  end
end
