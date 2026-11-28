module Rosetta::Languages::Abap::Common
  class Spec < Rosetta::Engine::Language
    tracks "abap"
    grammar "abap"
    extensions ".abap"

    # Treat these as comments.
    comments_are :line_comment,       # «* The answer»
                 :multi_line_comment, # «* The* answer» on two lines
                 :inline_comment,     # x = 1. «" The answer»
                 :pseudo_comment,     # x = 1. «"#EC NEEDED»
                 :docstring           # «"! Says if a year is a leap year.»

    # Keep the text of each string template between its embedded
    # expressions, which the grammar leaves out of its tree.
    text_between_children :string_template # |«Hi »{ name }|
  end
end
