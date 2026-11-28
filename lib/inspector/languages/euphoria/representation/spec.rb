module Inspector::Languages::Euphoria::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename identifiers.
    names_are :identifier # «count»

    # Rename the routines and types that the solution defines, and the
    # namespace that it gives its file.
    names_are_defined_by function_definition: :name,  # function «area»(integer width) ... end function
                         procedure_definition: :name, # procedure «greet»() ... end procedure
                         type_definition: :name,      # type «positive»(integer x) ... end type
                         namespace_statement: :name   # namespace «scrabble_score»

    # Rename parameters, variables, constants, enum members and the
    # variables of loops.
    names_are_defined_by parameter: :name,           # function area(integer «width»)
                         variable_declarator: :name, # integer «total» = 0
                         constant_declarator: :name, # constant «LIMIT» = 10
                         enum_member: :name,         # enum «RED», «GREEN»
                         for_statement: :variable    # for «i» = 1 to 10 do

    # Drop these imports, because a solution that passes its tests has
    # already included every file it needs.
    imports "include {{_}}",                       # «include std/math.e»
            "include {{_}} as {{_}}",              # «include std/math.e as math»
            "public include {{_}}",                # «public include std/math.e»
            "public include {{_}} as {{_}}",       # «public include std/math.e as math»
            "export include {{_}}",                # «export include std/math.e»
            "export include {{_}} as {{_}}",       # «export include std/math.e as math»
            "global include {{_}}",                # «global include std/math.e»
            "global include {{_}} as {{_}}"        # «global include std/math.e as math»
  end
end
