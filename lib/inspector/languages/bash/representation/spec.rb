module Inspector::Languages::Bash::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename variables, functions and the commands that call them. Bash's own
    # variables, such as `IFS`, have a type of their own, so they keep their
    # names, and so do the commands that the solution doesn't define.
    names_are :variable_name, # «count»
              :function_name, # «main»() { ... }
              :command_name   # «main» "$@"

    # Rename the names of functions.
    names_are_defined_by function_definition: :name # «main»() { ... }

    # Rename the variables that are assigned to, declared, looped over or
    # filled by a builtin.
    names_are_defined_by :declaration_command,          # local «total» «count»=0
                         variable_assignment: :name,    # «total»=0
                         subscript: :assigned,          # «seen»[$word]=1
                         binary_expression: :assigned,  # (( «total» += n ))
                         postfix_expression: :assigned, # (( «count»++ ))
                         unary_expression: :assigned,   # (( ++«count» ))
                         for_statement: :variable,      # for «word» in "$@"; do
                         command: :filled               # read -r «line»

    # Drop the files that the solution sources, because a solution that
    # passes its tests has already loaded everything it needs.
    imports "source {{_}}", # «source ./utils.bash»
            ". {{_}}"       # «. ./utils.bash»
  end
end
