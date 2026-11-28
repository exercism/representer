# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that the Roc compiler's parser gives.
module Representer::Languages::Roc::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the brackets, separators and keywords that sit in a fixed place,
    # because the node types already show them.
    # f(a, b)  ->  (function_call_pnc_expr (variable_expr f) (variable_expr a) (variable_expr b))
    # if a b else c  ->  (if_expr a (then b) (else c))
    strip_tokens "(", ")", "[", "]", "{", "}", ".{", ".(", "${", ",", ":", "=", ".", "..", "|", "&", "::",
                 "if", "else", "var", "for", "in", "while", "crash", "return", "dbg", "expect", "as",
                 "module", "import", "exposing"
    strip_tokens "->", only_in: :arrow
    strip_tokens "else if", only_in: :else_if

    # Write each number as its value. Roc reads `1` as any number and `1.0`
    # as a fraction, so the two stay apart. A number with a type, such as
    # `5.U8`, keeps its text.
    #
    # 0x1F  ->  31
    # 1_000  ->  1000
    # 1.50  ->  1.5
    numbers_are integer: [:int, :xint],
                decimal: :float,
                suffixes: ["f32", "f64"]

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'",
      '\${' => "${"
    }.freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        write_bracketed_negative_numbers_as_numbers!
        unwrap_the_wrappers_of_expressions!
        unwrap_brackets_that_only_group!
        mark_the_code_that_defines_names!
      end
    end

    private
    ### Values ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same. An interpolation keeps its code, with the text around it as
    # values. A multiline string keeps its own type, with its lines joined
    # by line breaks.
    #
    # "say \"hi\""  ->  say "hi"
    # "a ${b}"  ->  (string "a " (interpolation_char b))
    # \\a  ->  (multiline_string "a")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") { |match| string_value(:string, pieces(match.node.children)) }
      transform(tree, "(multiline_string) @string") { |match| string_value(:multiline_string, multiline_pieces(match.node)) }
    end

    # The pieces of a string: its text, its escapes and its interpolations.
    def pieces(children)
      children.filter_map do |child|
        case child.type
        when "fragment" then child.text
        when "escape_char" then escape(child.text)
        when "interpolation_char" then child
        end
      end
    end

    # The pieces of a multiline string. Each line starts with `\\` and runs
    # to the end of its line.
    def multiline_pieces(node)
      lines = node.children.slice_before { |child| child.type == "\\\\" }.map do |line|
        pieces(line).tap { |parts| parts[-1] = parts.last.sub(/\r?\n[ \t]*\z/, "") if parts.last.is_a?(String) }
      end
      lines.each_with_index.flat_map { |line, index| index.zero? ? line : ["\n", *line] }
    end

    # Return the text that an escape stands for, or a leaf that keeps the
    # escape as it is written.
    def escape(text)
      return ESCAPES[text] if ESCAPES.key?(text)

      code = text[/\A\\u\((\h{1,8})\)\z/, 1]&.to_i(16)
      return leaf(:escape, text) unless code && !code.between?(0xD800, 0xDFFF) && code <= 0x10FFFF

      [code].pack("U")
    end

    # Build a string from its pieces: a literal if it is all text, or a
    # string of literals and other nodes. Join neighbouring text.
    def string_value(type, pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return parts.first if type == :string && parts.one? && parts.first.quoted
      return literal("") if type == :string && parts.empty?

      build(type, *parts)
    end

    # Write a negative number in brackets as the number, because Roc reads
    # `-5` as one number wherever it is. The grammar reads it as a negation
    # only straight after a bracket.
    # (-5)  ->  -5
    def write_bracketed_negative_numbers_as_numbers!
      transform(tree, "(prefixed_expression operator: (operator_identifier)) @negation") do |match|
        number = match.node.named_children.last
        leaf(number.type, "-#{number.text}")
      end
    end

    ### Brackets ###

    # Unwrap the nodes that only hold one expression, because the Roc
    # compiler's parser has no node for them.
    # (expr_body (const 1))  ->  1
    def unwrap_the_wrappers_of_expressions!
      unwrap(tree, "[(expr_body) (const) (negative_number)]")
    end

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Keep the brackets around an operator expression or a
    # negation inside an operator expression, because the grammar writes
    # `a + b * c` as one flat list of operands and operators, so only the
    # brackets show the grouping.
    #
    # f((x))  ->  (function_call_pnc_expr f x)
    # (a + b) * c keeps its brackets
    # (-x) ^ 2 keeps its brackets
    def unwrap_brackets_that_only_group!
      each_node(tree) do |node, _|
        node.children.dup.each do |child|
          inner = child
          inner = inner.named_children.first while only_groups?(node, inner)
          node.replace_child(child, inner) unless inner.equal?(child)
        end
      end
    end

    def only_groups?(parent, child)
      return false unless ["parenthesized_expr", "paren_pattern", "parenthesized_type"].include?(child.type)
      return false unless child.named_children.one?

      !(parent.type == "bin_op_expr" && ["bin_op_expr", "prefixed_expression"].include?(child.named_children.first.type))
    end

    ### Names ###

    # Give the code that defines a name a shape of its own, so that
    # representation/spec.rb can list it in names_are_defined_by.
    def mark_the_code_that_defines_names!
      mark_the_names_of_types!
      mark_the_names_of_tags!
      mark_the_type_variables!
    end

    # Mark the name of each type definition as a `type_name`.
    # «Color» := [Red, Green]
    # «Tree»(a) : [Leaf, Node(Tree(a), a, Tree(a))]
    def mark_the_names_of_types!
      each_node(tree) do |node, _|
        next unless ["alias_type_def", "opaque_type_def", "nominal_type_def"].include?(node.type)

        node.named_children.first.type = "type_name"
      end
    end

    # Write the name of each tag in a tag union type as a `tag_name` leaf.
    # The grammar keeps the name as text when the tag has arguments, and
    # keeps the spaces between the arguments too, so drop the spaces.
    # [Red, Green(U8)]  ->  (tags_type (tag_type (tag_name Red)) (tag_type (tag_name Green) U8))
    def mark_the_names_of_tags!
      each_node(tree) do |node, _|
        next unless node.type == "tag_type"

        if node.leaf?
          node.children = [leaf(:tag_name, node.text)]
          node.text = nil
        else
          name, *spaces = node.children.select { |child| child.type == "fragment" }
          node.replace_child(name, leaf(:tag_name, name.text))
          node.children -= spaces
        end
      end
    end

    # Wrap each type variable in a `type_variable` node, as the grammar does
    # in `..a`.
    # List(a)  ->  (apply_type List (type_variable a))
    def mark_the_type_variables!
      each_node(tree) do |node, _|
        next if node.type == "type_variable"

        node.children.dup.each do |child|
          node.replace_child(child, build(:type_variable, child)) if child.type == "bound_variable"
        end
      end
    end
  end
end
