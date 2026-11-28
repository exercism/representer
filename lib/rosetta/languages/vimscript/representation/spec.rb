module Rosetta::Languages::Vimscript::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename identifiers. Vim's own variables, such as `v:val`, have a type
    # of their own, so they keep their names.
    names_are :identifier # «count»

    # Rename functions, the variables that are assigned to or looped over,
    # and the members of a dictionary that are assigned to (GenerateAST gives
    # each of these names the field `name`).
    names_are_defined_by function_declaration: :name, # function! «Response»(remark) abort
                         let_statement: :name,        # let «total» = 0
                         const_statement: :name,      # const «limit» = 10
                         for_loop: :name,             # for «word» in words
                         list_assignment: :name,      # let [«first»; «rest»] = list
                         scoped_identifier: :name,    # let s:«count» = 0
                         field_expression: :name      # let self.«count» = 0

    # Rename parameters, including those of lambdas and those with a default.
    names_are_defined_by :parameters,               # function! F(«first», «second»)
                         lambda_expression: :name,  # {«acc», «val» -> acc + val}
                         default_parameter: :name   # function! F(«count» = 1)

    # Drop the files that the solution loads, because a solution that passes
    # its tests has already loaded everything it needs.
    imports "source {{_}}", # «source helpers.vim»
            "runtime {{_}}" # «runtime plugin/helpers.vim»
  end
end
