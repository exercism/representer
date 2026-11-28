module Rosetta::Languages::Tcl::Common
  class Spec < Rosetta::Engine::Language
    tracks "tcl"
    grammar "tcl"
    extensions ".tcl"

    # Treat these as comments.
    comments_are :comment # set x 1 «# The answer»

    # Keep each name as one leaf with its whole text, because the grammar
    # gives the `::` of a name such as `::count` as a child.
    text_nodes :id # puts $«::count»

    # Keep the text between the children of these nodes, because the grammar
    # leaves the text of strings, braced words and booleans out of the tree,
    # and gives the parts of a word such as `a$b` as separate children. The
    # spaces between the children show where each word ends.
    text_between_children :quoted_word,           # puts «"a $b"»
                          :braced_word_simple,    # set x «{a b}»
                          :variable_substitution, # puts «${a}»
                          :word_list,             # puts «a$b c»
                          :command,               # «$a$b» c
                          :array_index,           # puts $a«($i,$j)»
                          :set,                   # «set x a$b»
                          :procedure,             # «proc f {} {}»
                          :foreach,               # «foreach x $a$b {}»
                          :for,                   # «for {} {$i} {} {}»
                          :while,                 # «while {$i} {}»
                          :if,                    # «if {$i} {}»
                          :elseif,                # if {$i} {} «elseif {$j} {}»
                          :else,                  # if {$i} {} «else {}»
                          :try,                   # «try {} finally {}»
                          :on,                    # try {} «on error {e} {}»
                          :trap,                  # try {} «trap {A} {e} {}»
                          :finally,               # try {} «finally {}»
                          :catch,                 # «catch {} e»
                          :regexp,                # «regexp a $b»
                          :regsub,                # «regsub a $b c d»
                          :variable,              # «variable a b»
                          :global,                # «global a»
                          :expr,                  # if «{$a && true}» {}
                          :binop_expr,            # expr {«$a && true»}
                          :unary_expr,            # expr {«!true»}
                          :ternary_expr,          # expr {«$a ? true : false»}
                          :function_arguments     # expr {max(«$a, true»)}
  end
end
