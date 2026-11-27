# REPRESENTER_DSL.md defines the verbs and helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here gives one form to spellings that Cairo reads the same way.
class Representer::Languages::Cairo::Representation
  class Normalise < Representer::Engine::Normalise
    def call
      super.tap do |root|
        write_shorthand_fields_in_full!(root)
      end
    end

    private
    # Write each shorthand field in full, in values and in patterns.
    # Point { x }  ->  Point { x: x }
    # let Point { x } = p;  ->  let Point { x: x } = p;
    def write_shorthand_fields_in_full!(root)
      transform(root, "(shorthand_field_initializer (identifier) @name)") do |match|
        build(:field_initializer, { field: leaf(:field_identifier, match[:name].text) }, token(":"), { value: match[:name] })
      end
      transform(root, "(field_pattern name: (shorthand_field_identifier) @name)") do |match|
        next nil unless match.node.children.one?

        build(:field_pattern, { name: leaf(:field_identifier, match[:name].text) }, token(":"),
          { pattern: leaf(:identifier, match[:name].text) })
      end
    end
  end
end
