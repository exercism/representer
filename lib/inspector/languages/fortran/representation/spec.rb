module Inspector::Languages::Fortran::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename identifiers, and the names of programs, modules, types, type
    # components, type-bound procedures and labelled constructs.
    names_are :identifier,          # «count»
              :name,                # function «count»(x)
              :type_name,           # type(«point») :: p
              :type_member,         # p%«x»
              :method_name,         # procedure :: area => «circle_area»
              :block_label,         # exit «outer»
              :procedure_interface  # procedure(«compare») :: f

    # Rename the names of programs, modules, interfaces, types, functions and
    # subroutines, and their parameters and results.
    names_are_defined_by :program_statement,          # program «main»
                         :module_statement,           # module «bob»
                         :interface_statement,        # interface «norm»
                         :derived_type_statement,     # type :: «point»
                         :parameters,                 # function area(«width», «height»)
                         :function_result,            # function area(w) result(«a»)
                         function_statement: :name,   # function «area»(width)
                         subroutine_statement: :name  # subroutine «draw»(width)

    # Rename variables, constants and type components, and the variables
    # assigned to without a declaration.
    names_are_defined_by :sized_declarator,                  # integer :: «counts»(10)
                         variable_declaration: :declarator,  # integer :: «count»
                         init_declarator: :left,             # integer :: «count» = 0
                         pointer_init_declarator: :left,     # integer, pointer :: «p» => null()
                         assignment_statement: :left         # «count» = 0

    # Rename type-bound procedures, the names given by `associate`, and the
    # labels of constructs.
    names_are_defined_by :binding_name,                     # procedure :: «area» => circle_area
                         :block_label_start_expression,     # «outer»: do i = 1, n
                         procedure_statement: :declarator,  # procedure :: «area»
                         association: :name                 # associate («r» => c%radius)

    # Drop the uses of modules, because a solution that passes its tests has
    # already made every module it needs available.
    imports "use {{_}}",                                 # «use iso_fortran_env»
            "use {{_}}, only: {{...}}",                  # «use iso_fortran_env, only: int64»
            "use {{_}}, {{...}} => {{...}}",             # «use iso_fortran_env, i8 => int8, i16 => int16»
            "use, intrinsic :: {{_}}",                   # «use, intrinsic :: iso_fortran_env»
            "use, intrinsic :: {{_}}, only: {{...}}",    # «use, intrinsic :: iso_fortran_env, only: int64»
            "use, non_intrinsic :: {{_}}",               # «use, non_intrinsic :: shapes»
            "use, non_intrinsic :: {{_}}, only: {{...}}" # «use, non_intrinsic :: shapes, only: area»

    # Put a pattern that can only stand inside a module there, such as a
    # `use` statement.
    pattern_contexts "module m\n{{pattern}}\nend module"
  end
end
