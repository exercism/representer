module Inspector::Languages::Lfe::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename symbols. LFE names its modules, functions, variables and
    # records with symbols.
    names_are :symbol # «count»

    # Rename the names that GenerateAST marks as defined: the module, the
    # functions, macros and records, and every variable in a pattern.
    names_are_defined_by :definition # (defun «area» («width») ...)

    # Drop these imports, because a solution that passes its tests has
    # already loaded every module and file it needs.
    imports "(import {{...}})",       # (defmodule leap «(import (from lists (map 2)))»)
            "(module-alias {{...}})", # (defmodule leap «(module-alias (lists l))»)
            "(include-lib {{...}})",  # «(include-lib "lfe/include/clj.lfe")»
            "(include-file {{...}})"  # «(include-file "leap.lfe")»

    # Let code patterns use these words as names, because the grammar reads
    # them as keywords only inside `defmodule`, and LFE's reader reads them
    # as symbols.
    keywords_used_as_names "import",      # («import» {{...}})
                           "module-alias" # («module-alias» {{...}})
  end
end
