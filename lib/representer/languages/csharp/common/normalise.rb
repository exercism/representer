# docs/representation.md defines the verbs in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. These rules
# give one form to spellings that every output treats as the same.
module Representer::Languages::CSharp::Common
  class Normalise < Representer::Engine::Normalise
    # Drop `this.` before a name. A parameter or local with the same name
    # gets the same placeholder as the member anyway, because the engine
    # renames by name.
    # this.count  ->  count
    rewrite "this.{{name}}", as: "{{name}}"

    def call
      super.tap do |root|
        drop_the_types_own_name_before_its_members!(root)
      end
    end

    private
    # Drop the type's own name before one of its members. A code pattern
    # can't stand for any class, because C# reads no placeholder in place of
    # a class's modifiers or members, so this step finds the types with a
    # tree pattern.
    # class Counter { ... Counter.Start() ... }  ->  class Counter { ... Start() ... }
    def drop_the_types_own_name_before_its_members!(root)
      Representer::Engine::RewriteCode.(root, code_pattern("{{type}}.{{name}}", nil), code_pattern("{{name}}", nil),
        scopes: ["(class_declaration name: (_) @type)",
                 "(struct_declaration name: (_) @type)",
                 "(record_declaration name: (_) @type)"])
    end
  end
end
