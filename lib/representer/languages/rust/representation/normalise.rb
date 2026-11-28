# REPRESENTER_DSL.md defines the verbs and helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here gives one form to spellings that Rust reads the same way.
module Representer::Languages::Rust::Representation
  class Normalise < Representer::Engine::Normalise
    # Move each attribute into the item after it, so the two move together
    # when Reorder sorts the items.
    # #[derive(Debug)] struct A;  ->  (struct_item A (attribute_item derive(Debug)))
    attach_to_next "#[{{...}}]"

    def call
      super.tap do |root|
        drop_the_semicolon_after_assignments!(root)
        write_empty_match_arm_blocks_as_units!(root)
        unwrap_match_arm_blocks_that_hold_one_expression!(root)
        write_shorthand_fields_in_full!(root)
      end
    end

    private
    ### Statements ###

    # Drop the `;` after an assignment, because an assignment's value is
    # always `()`.
    # x = y;  ->  x = y
    # x += 1;  ->  x += 1
    def drop_the_semicolon_after_assignments!(root)
      transform(root, "(expression_statement [(assignment_expression) (compound_assignment_expr)] @assignment)",
        "@assignment")
    end

    ### Match arms ###

    # Write an empty block in a match arm as `()`.
    # x => {}  ->  x => ()
    def write_empty_match_arm_blocks_as_units!(root)
      find_all(root, "(match_arm value: (block) @block)").each do |match|
        match.node.replace_child(match[:block], build(:unit_expression)) if match[:block].children.empty?
      end
    end

    # Write a block in a match arm that holds only an expression as the
    # expression.
    # x => { y }  ->  x => y
    # x => { y = 1; }  ->  x => y = 1
    def unwrap_match_arm_blocks_that_hold_one_expression!(root)
      find_all(root, "(match_arm value: (block) @block)").each do |match|
        inner = match[:block].children
        next unless inner.one? && inner.first.named?

        inner = inner.first
        inner = inner.named_children.first if inner.type == "expression_statement" && inner.named_children.one?
        match.node.replace_child(match[:block], inner)
      end
    end

    ### Fields ###

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
