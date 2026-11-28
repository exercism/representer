# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# TypeScript is JavaScript with types, and its own parser (typescript-estree)
# gives JavaScript's tree for the code that the two share. So this stage runs
# JavaScript's GenerateAST, and only adds what TypeScript's grammar writes
# differently.
module Inspector::Languages::TypeScript::Common
  class GenerateAST < Inspector::Languages::JavaScript::Common::GenerateAST
    private
    # Treat an arrow function's single parameter as a name when it has no
    # type, so `(x) => x` and `x => x` get the same tree.
    # (x) => x  ->  x => x
    def lone_parameter(parameters)
      parameter = parameters.first
      return unless parameters.one? && parameter.type == "required_parameter" && parameter.children.one?

      parameter["pattern"] if parameter["pattern"]&.type == "identifier"
    end
  end
end
