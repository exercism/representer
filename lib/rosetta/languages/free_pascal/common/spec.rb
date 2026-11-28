module Rosetta::Languages::FreePascal::Common
  class Spec < Rosetta::Engine::Language
    tracks "free-pascal"
    grammar "pascal"
    extensions ".pas"

    # Treat these as comments. A solution that passes its tests already
    # compiles with its compiler directives, so they go too.
    comments_are :comment, # x := 1; «// The answer»
                 :pp       # «{$mode ObjFPC}»

    # Keep the whole text of each string. The grammar leaves the digits of a
    # character code such as `#10` out of its tree.
    text_nodes :literalString # «'a'#10'b'»
  end
end
