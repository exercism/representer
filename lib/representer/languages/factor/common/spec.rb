module Representer::Languages::Factor::Common
  class Spec < Representer::Engine::Language
    tracks "factor"
    grammar "factor"
    extensions ".factor"

    # Treat a `!` or `#!` word and the rest of its line as a comment, because
    # the grammar reads it as words. A string comes first, so a `!` inside
    # one stays.
    # : f ( -- n ) 1 ; «! The answer»
    comment_text(/(?<!\S)#?!(?=\s|\z)[^\n]*/,
                 outside: /"(?:\\.|[^"\\])*"/m)
  end
end
