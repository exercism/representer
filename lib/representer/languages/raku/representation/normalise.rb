# docs/representation.md defines the verbs in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here gives one form to code that works the same way.
module Representer::Languages::Raku::Representation
  class Normalise < Representer::Engine::Normalise
    # Write each statement with a modifier as a block.
    # say $x if $y;  ->  if $y { say $x }
    # say $x unless $y;  ->  unless $y { say $x }
    # .say for @xs;  ->  for @xs { .say }
    rewrite "{{body}} if {{condition}}",     as: "if {{condition}} { {{body}} }"
    rewrite "{{body}} unless {{condition}}", as: "unless {{condition}} { {{body}} }"
    rewrite "{{body}} for {{list}}",         as: "for {{list}} { {{body}} }"
  end
end
