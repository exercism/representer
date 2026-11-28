module Rosetta::Languages::X8664Assembly::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Treat these as imports.
    imports '%include "{{_}}"' # «%include "debug.mac"»

    # Rename the names of labels, constants, defines, macros and strucs,
    # wherever they appear.
    names_are :identifier,        # jmp «done»
              :local_label,       # jmp «.loop»
              :macro_local_label  # jmp «%%skip»

    # Rename the names of labels, data and constants.
    names_are_defined_by label: :name,            # «done»:
                         data_definition: :name,  # «msg» db "hi"
                         equ_definition: :name    # «SIZE» equ 8

    # Rename the names of defines, macros and strucs, and the parameters of
    # defines.
    names_are_defined_by :preproc_parameters,      # %define max(«a», «b») a
                         preproc_define: :name,    # %define «SIZE» 8
                         preproc_assign: :name,    # %assign «count» 0
                         macro_definition: :name,  # %macro «push_all» 0
                         struc_definition: :name   # struc «point»
  end
end
