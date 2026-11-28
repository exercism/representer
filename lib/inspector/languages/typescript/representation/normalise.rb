# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# TypeScript's code normalises the same way as JavaScript's, so this stage
# runs JavaScript's Normalise.
module Inspector::Languages::TypeScript::Representation
  class Normalise < Inspector::Languages::JavaScript::Representation::Normalise
  end
end
