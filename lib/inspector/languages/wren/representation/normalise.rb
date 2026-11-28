# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here gives one form to statements that Wren reads the same way.
module Inspector::Languages::Wren::Representation
  class Normalise < Inspector::Engine::Normalise
    # Put braces around the body of each `if`, `else`, `while` and `for`,
    # including an `else if`. The grammar reads empty braces as an empty
    # map, so the rule gives the block's type.
    #
    # if (a) b()  ->  if (a) { b() }
    # if (a) b() else if (c) d()  ->  if (a) { b() } else { if (c) { d() } }
    # for (i in xs) f(i)  ->  for (i in xs) { f(i) }
    add_braces_to "if ({{...}}) {{body}}",
                  "if ({{...}}) { } else {{body}}",
                  "while ({{...}}) {{body}}",
                  "for ({{...}} in {{...}}) {{body}}",
        block: :block
  end
end
