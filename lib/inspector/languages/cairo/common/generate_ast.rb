# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree with one form for each meaning.
module Inspector::Languages::Cairo::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if x { return y; }  ->  (if_expression x (block (return_expression y)))
    strip_tokens "fn", "let", "struct", "enum", "impl", "trait", "mod", "use", "type", "const", "pub",
                 "if", "else", "while", "loop", "match", "return", "break", "continue", "for", "in"

    # Strip the brackets, commas and semicolons, because they are layout. A
    # final expression and a statement stay apart, because they are
    # different nodes.
    # f(a, b);  ->  (expression_statement (call_expression f (arguments a b)))
    strip_tokens "(", ")", "{", "}", "[", "]", ",", ";"

    # Keep the `;` in a macro's arguments, because they have no syntax tree.
    # array![0; 5] and array![0, 5]
    keep_tokens ";", in: :token_tree

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b)  ->  a + b
    unwrap :parenthesized_expression

    # Write each number as its value.
    # 1_000  ->  1000
    # 0x1F  ->  31
    numbers_are integer: :numeric_literal

    PATTERNS = ["tuple_enum_pattern", "tuple_pattern", "slice_pattern", "match_pattern", "let_condition"].freeze

    def call
      tree.tap do
        write_integers_with_a_suffix_as_their_values!
        drop_empty_statements!
        mark_the_names_of_impls!
        write_capitalised_names_in_patterns_as_paths!
      end
    end

    private
    # Write each integer with a type suffix as its value too, and keep the
    # suffix.
    # 1_000_u32  ->  1000_u32
    # 0x1F_u8  ->  31_u8
    def write_integers_with_a_suffix_as_their_values!
      each_node(tree) do |node, _|
        next unless node.type == "numeric_literal"

        digits, suffix = node.text.match(/\A(.*)_([iu](?:8|16|32|64|128|256)|felt252|usize)\z/)&.captures
        value = digits && Inspector::Engine::Numbers.integer(digits)
        node.text = "#{value}_#{suffix}" if value
      end
    end

    # Drop each empty statement.
    # let a = 1;;  ->  let a = 1;
    def drop_empty_statements!
      drop(tree, "(empty_statement)")
    end

    # Mark the name of each impl as its name, so that representation/spec.rb can
    # list it with the other definitions, and leave the trait it implements
    # alone.
    # impl «PointShape» of Shape { ... }
    def mark_the_names_of_impls!
      captured(tree, "(impl_item (identifier) @name)").each { |name| name.field = "name" }
    end

    # Write each name in a pattern that starts with a capital letter as a
    # path. Cairo reads such a name as an enum variant or a struct, so it
    # binds nothing, and representation/spec.rb lists only the names that a
    # pattern binds.
    # Some(x) => x  ->  (match_pattern (tuple_enum_pattern (path Some) x)) x
    # None => 0  ->  (match_pattern (path None)) 0
    def write_capitalised_names_in_patterns_as_paths!
      each_node(tree) do |node, _|
        next unless PATTERNS.include?(node.type)

        node.children.each do |child|
          node.replace_child(child, build(:path, copy(child))) if child.type == "identifier" && child.text.match?(/\A[A-Z]/)
        end
      end
    end
  end
end
