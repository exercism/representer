module Inspector::Languages::Ballerina::Representation
  class Spec < Inspector::Engine::Representation
    version 4

    # Rename identifiers.
    names_are :identifier # «count»

    # Rename the names of functions, types, variables and parameters.
    names_are_defined_by :function_name, # function «add»(int x) returns int { ... }
                         :type_name,     # type «Point» record {| int x; |};
                         :variable       # int «total» = 0;

    # Drop each import, because a solution that passes its tests has already
    # imported every module it needs.
    imports "import {{...}};" # «import ballerina/io;»
  end
end
