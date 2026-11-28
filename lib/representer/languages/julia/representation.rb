module Representer::Languages::Julia
  class Representation < Representer::Engine::Representation
    version 6

    # Rename identifiers, including the names of macros and symbols.
    names_are :identifier # «count», @«assert», :«count»

    # Rename the names of functions, macros and modules. GenerateAST puts each
    # name that a definition defines in the field `name`.
    names_are_defined_by call_expression: :name,   # function «area»(width) ... end, «area»(width) = width * 2
                         module_definition: :name  # module «Leap» ... end

    # Rename the names of types, their type parameters and the fields of
    # structs.
    names_are_defined_by type_head: :name,                     # struct «Point» end, abstract type «Shape» end
                         parametrized_type_expression: :name,  # struct «Box»{T} end
                         curly_expression: :name,              # struct Box{«T»} end, f(x::T) where {«T»}
                         binary_expression: :name,             # struct «Circle» <: Shape end, where {«T» <: Real}
                         where_expression: :name,              # f(x::T) where «T» = x
                         block: :name                          # struct Point «x»; «y» end

    # Rename parameters, including those of anonymous functions and `do`
    # blocks.
    names_are_defined_by argument_list: :name,             # function area(«width», «height») ... end
                         keyword_argument: :name,          # function greet(«name» = "you") ... end
                         arrow_function_expression: :name, # «x» -> x * 2
                         do_clause: :name                  # map(xs) do «x» ... end

    # Rename variables, including those of loops, `let`, `catch` and the
    # left of each assignment.
    names_are_defined_by assignment: :name,                     # «total» = price * 2
                         compound_assignment_expression: :name, # «total» += 1
                         typed_expression: :name,               # «count»::Int = 0, f(«x»::Int)
                         splat_expression: :name,               # «first», «rest»... = items
                         open_tuple: :name,                     # «first», «second» = pair
                         tuple_expression: :name,               # («first», «second») = pair
                         for_binding: :name,                    # for «item» in items
                         let_statement: :name,                  # let «total»
                         local_statement: :name,                # local «total»
                         global_statement: :name,               # global «total»
                         catch_clause: :name                    # catch «error»

    # Drop these imports, because a solution that passes its tests has already
    # loaded everything it needs.
    imports "using {{...}}",   # «using Dates»
            "import {{...}}",  # «import Base: show»
            'include("{{_}}")' # «include("helpers.jl")»
  end
end
