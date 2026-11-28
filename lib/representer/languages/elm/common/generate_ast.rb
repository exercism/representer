# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that the Elm compiler's parser gives.
module Representer::Languages::Elm::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the brackets, commas and keywords that sit in a fixed place,
    # because the node types already show them.
    # f [ a, b ]  ->  (function_call_expr f (list_expr a b))
    # if a then b else c  ->  (if_else_expr a b c)
    strip_tokens "(", ")", "[", "]", "{", "}", ",", "let", "in", "if", "then", "else"

    ESCAPES = {
      '\n' => "\n",
      '\r' => "\r",
      '\t' => "\t",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'"
    }.freeze

    def call
      tree.tap do
        write_numbers_as_values!
        write_strings_as_their_values!
        unwrap_brackets_that_only_group!
        mark_the_module_name!
        mark_the_type_variables!
      end
    end

    private
    ### Values ###

    # Write each number as its value. Elm reads `1` as any number and `1.0`
    # as a Float, so the two stay apart.
    # 0x1F  ->  31
    # 1.50  ->  1.5
    def write_numbers_as_values!
      each_node(tree) do |node, _|
        node.text = number(node.text) || node.text if node.type == "number_literal"
      end
    end

    def number(text)
      value = Representer::Engine::Numbers.integer(text, prefixes: { "0x" => 16 })
      return value.to_s if value

      Representer::Engine::Numbers.decimal(text)&.then { |decimal| Representer::Engine::Numbers.write_decimal(decimal) }
    end

    # Turn each string into its value, however it is quoted, and read its
    # escapes. Keep any other escape as it is written, so it can't make two
    # different strings the same. The grammar calls `\u{41}` an invalid
    # escape, though Elm accepts it.
    #
    # "a\u{41}"  ->  "aA"
    # """a"""  ->  "a"
    def write_strings_as_their_values!
      transform(tree, "(string_constant_expr) @string") do |match|
        parts = match.node.named_children.reject { |part| ["open_quote", "close_quote"].include?(part.type) }
        literal(parts.map { |part| part.type == "regular_string_part" ? part.text : escape(part.text) }.join)
      end
    end

    # Return the text that an escape stands for, or the escape itself if it
    # stands for no single character, such as half of a surrogate pair.
    def escape(text)
      code = text[/\A\\u\{(\h{1,6})\}\z/, 1]&.to_i(16)
      return ESCAPES.fetch(text, text) unless code

      code.between?(0xD800, 0xDFFF) || code > 0x10FFFF ? text : [code].pack("U")
    end

    ### Brackets ###

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Keep the brackets around an operator expression inside
    # another one, because the grammar writes `a + b * c` as one flat list
    # of operands and operators, so only the brackets show the grouping.
    #
    # (x)  ->  x
    # f (g x)  ->  (function_call_expr f (function_call_expr g x))
    # (a + b) * c keeps its brackets
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
      return false unless child.type == "parenthesized_expr" && child.named_children.one?

      !(parent.type == "bin_op_expr" && child.named_children.first.type == "bin_op_expr")
    end

    ### Names ###

    # Mark the name of the module as a `module_name`, so that
    # representation/spec.rb can list it.
    # module «Leap» exposing (isLeapYear)
    def mark_the_module_name!
      captured(tree, "(module_declaration name: (upper_case_qid) @name)").each { |name| name.type = "module_name" }
    end

    # Mark the `a` of `{ a | name : String }` as a type variable, as it is
    # in `List a`. Then mark the name of each constrained type variable,
    # such as `number` or `comparable2`, as a `constrained_type_variable`,
    # so that it keeps its name. Elm reads these names as constraints, so
    # `number -> number` differs from `a -> a`.
    #
    # { a | name : String }  ->  (record_type (type_variable a) ...)
    def mark_the_type_variables!
      captured(tree, "(record_type baseRecord: (record_base_identifier) @name)").each { |name| name.type = "type_variable" }
      captured(tree, "[(type_variable (lower_case_identifier) @name) (lower_type_name (lower_case_identifier) @name)]").each do |name|
        name.type = "constrained_type_variable" if name.text.match?(/\A(number|comparable|appendable|compappend)/)
      end
    end
  end
end
