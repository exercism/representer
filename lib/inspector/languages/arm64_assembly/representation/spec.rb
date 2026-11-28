module Inspector::Languages::Arm64Assembly::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename the names of labels, constants, register aliases and macros,
    # and the parameters of macros, wherever they appear.
    names_are :identifier,  # b «loop»
              :local_label  # b «1»b

    # Rename the names of labels, constants and register aliases.
    names_are_defined_by label: :name,              # «loop»:
                         symbol_definition: :name,  # .equ «SIZE», 8
                         register_alias: :name      # «count» .req x0

    # Rename the names of macros and their parameters.
    names_are_defined_by macro_definition: :name,  # .macro «push» reg
                         parameter: :name          # .macro push «reg»
  end
end
