# REPRESENTER_DSL.md defines the verbs in this file.
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

    # Drop the type's own name before one of its members.
    # class Counter { ... Counter.Start() ... }  ->  class Counter { ... Start() ... }
    rewrite "{{type}}.{{name}}",
        as: "{{name}}",
        within: ["class {{type}} {}", "struct {{type}} {}", "record {{type}} {}"]
  end
end
