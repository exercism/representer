module Rosetta::Languages::Uiua::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename names. A name starts with a capital letter, so a primitive's
    # name, such as `reverse`, is never one.
    names_are :identifier # «Double»

    # Rename the names that bindings, modules and data definitions define,
    # including the fields of a data definition.
    names_are_defined_by :fields,               # ~ Point [«X» «Y»]
                         binding: :name,        # «Double» ← ×2
                         module: :name,         # ┌─╴«Character»
                         data_definition: :name # ~ «Point» [X Y]

    # Drop each import, because a solution that passes its tests has already
    # loaded everything it needs.
    imports '{{lib}} ~ "{{path}}"',                 # «Lib ~ "lib.ua"»
            '~ "{{path}}" ~ {{...items}}',          # «~ "lib.ua" ~ Double»
            '{{lib}} ~ "{{path}}" ~ {{...items}}'   # «Lib ~ "lib.ua" ~ Double»

    # Spell each placeholder in a code pattern as a name, such as `Lib‼`.
    # A name can't end in `__`, and a word in lower case is a primitive.
    placeholder_suffix "‼"
  end
end
