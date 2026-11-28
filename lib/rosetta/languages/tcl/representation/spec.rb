module Rosetta::Languages::Tcl::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename names, variables and the words that call commands.
    names_are :simple_word, # «puts» $x
              :id           # puts $«x»

    # Rename the names that GenerateAST marks as defined.
    names_are_defined_by :definition # proc «area» {«w»} {}

    # Drop the packages that a solution loads, because a solution that passes
    # its tests has already loaded everything it needs.
    imports "package require {{...}}",  # «package require Tcl 8.6»
            "namespace import {{...}}"  # «namespace import ::tcl::mathop::*»
  end
end
