# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Gleam's own parser gives.
module Rosetta::Languages::Gleam::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # let assert [x] = xs  ->  (let_assert (list_pattern x) = xs)
    strip_tokens "fn", "let", "type", "const", "case", "assert"

    # Strip the brackets and commas, because they are layout.
    # f(a, b)  ->  (function_call f (arguments a b))
    strip_tokens "(", ")", "{", "}", "[", "]", ","

    # Write each number as its value.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    numbers_are integer: :integer,
                decimal: :float

    ESCAPES = {
      '\n' => "\n",
      '\r' => "\r",
      '\t' => "\t",
      '\f' => "\f",
      '\\\\' => "\\",
      '\"' => '"'
    }.freeze

    def call
      tree.tap do
        write_strings_as_values!
        write_label_shorthands_in_full!
        wrap_the_names_bound_by_patterns_in_variable_nodes!
      end
    end

    private
    # Turn each string into its value, and read its escapes. Keep any other
    # escape as it is written.
    #
    # "a\nb"  ->  a string with a line break
    # "\u{41}"  ->  "A"
    def write_strings_as_values!
      transform(tree, "(string) @string") do |match|
        literal(match.node.named_children.map { |part| part.type == "escape_sequence" ? escape_value(part.text) : part.text }.join)
      end
    end

    # Read a `\u{...}` escape as the character with that code.
    def escape_value(escape)
      code = escape[/\A\\u\{(\h{1,6})\}\z/, 1]&.to_i(16)
      return [code].pack("U") if code && !code.between?(0xD800, 0xDFFF) && code <= 0x10FFFF

      ESCAPES.fetch(escape, escape)
    end

    # Write a labelled argument without a value in full, because Gleam's
    # parser gives it the variable with the label's name as its value.
    #
    # f(age:)  ->  f(age: age)
    # let Circle(radius:) = c  ->  let Circle(radius: radius) = c
    def write_label_shorthands_in_full!
      find_all(tree, "(argument label: (label) @label !value)").each { |match| add_value!(match, "value") }
      find_all(tree, "(record_pattern_argument label: (label) @label !pattern)").each { |match| add_value!(match, "pattern") }
    end

    def add_value!(match, field)
      match.node.children << leaf(:identifier, match[:label].text).tap { |value| value.field = field }
    end

    # Wrap each variable bound by a pattern in a `variable` node, so that
    # representation/spec.rb can list it in names_are_defined_by. The patterns are
    # the left of `let`, `let assert` and `use`, and the patterns of a `case`.
    def wrap_the_names_bound_by_patterns_in_variable_nodes!
      each_node(tree) do |node, _|
        next unless node.named?

        case node.type
        when "let", "let_assert" then node.replace_child(node[:pattern], wrap_names_bound_by!(node[:pattern]))
        when "case_clause_patterns", "use_assignments" then wrap_names_bound_by!(node)
        end
      end
    end

    # Return the pattern with each name bound by it wrapped in a `variable`
    # node. The module of `option.Some(x)` binds nothing.
    def wrap_names_bound_by!(pattern)
      return build(:variable, pattern).tap { |node| node.field = pattern.field } if pattern.type == "identifier"
      return pattern if pattern.type == "remote_constructor_name"

      pattern.children.map! { |child| wrap_names_bound_by!(child) }
      pattern
    end
  end
end
