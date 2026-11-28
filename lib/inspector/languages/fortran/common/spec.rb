module Inspector::Languages::Fortran::Common
  class Spec < Inspector::Engine::Language
    tracks "fortran"
    grammar "fortran"
    extensions ".f90"

    # Treat these as comments.
    comments_are :comment # x = 1 «! The answer»

    # Keep the whole text of these names. The grammar gives a name that is
    # also a keyword, such as `len` or `kind`, as a node that holds the
    # keyword's token.
    text_nodes :identifier,          # «kind»(1.0)
               :name,                # function «count»(x)
               :type_name,           # type :: «point»
               :method_name,         # procedure :: «area»
               :type_member,         # p%«len»
               :block_label,         # exit «outer»
               :procedure_interface  # procedure(«compare») :: f

    # Keep the digits of a number with a kind, which the grammar leaves out
    # of its tree.
    text_between_children :number_literal,   # «1.5»_dp
                          :character_length  # character :: s*«10»
  end
end
