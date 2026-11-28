module Representer::Languages::Mips::Representation
  class Spec < Representer::Engine::Representation
    version 6

    # Rename the names of labels, constants and macros, and the parameters
    # of macros, wherever they appear.
    names_are :symbol,                # j «loop»
              :macro_name,            # .macro «store»(%byte)
              :macro_parameter_name,  # .macro store(«%byte»)
              :macro_variable         # li $t9, «%byte»

    # Rename the names of labels and constants.
    names_are_defined_by :label,      # «loop»:
                         eqv: :name   # .eqv «LENGTH», 10

    # Rename the names of macros and their parameters.
    names_are_defined_by directive: :name,        # .macro «store»(%byte)
                         macro_parameter: :name   # .macro store(«%byte»)
  end
end
