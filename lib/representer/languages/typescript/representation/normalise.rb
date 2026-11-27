# REPRESENTER_DSL.md defines the verbs and helpers in this file.
# TypeScript's code normalises the same way as JavaScript's, so this stage
# runs JavaScript's Normalise.
class Representer::Languages::TypeScript::Representation
  class Normalise < Representer::Languages::JavaScript::Representation::Normalise
  end
end
