# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that JavaScript's own parser (ESTree, as typescript-estree
# gives it) gives.
module Representer::Languages::JavaScript::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if (x) { return y; }  ->  (if_statement x (statement_block (return_statement y)))
    strip_tokens "return", "function", "class", "if", "else", "while", "for", "do", "new", "export", "break",
                 "continue", "throw", "try", "catch", "finally", "switch", "case", "yield", "debugger"

    # Strip the brackets, commas, quotes and other punctuation, because they
    # are layout.
    # f(a, b);  ->  (call_expression f (arguments a b))
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", ".", ":", "=>", "${", '"', "'", "`"

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value. JavaScript stores every number the same
    # way, so an integer and a decimal with the same value are the same. A
    # BigInt keeps its text.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1e3  ->  1000
    # 1.50  ->  1.5
    # 10n  ->  10n
    numbers_are number: :number

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\b' => "\b",
      '\f' => "\f",
      '\v' => "\v",
      '\0' => "\0",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'",
      '\`' => "`",
      '\$' => "$",
      "\\\n" => ""
    }.freeze

    def call
      tree.tap do
        drop_hash_bang_line!
        write_strings_as_their_values!
        write_a_lone_arrow_parameter_without_brackets!
        mark_properties_set_on_this!
      end
    end

    private
    # Drop the `#!` line, because it only says how to run the file as a
    # script, and the parser leaves it out of the program.
    def drop_hash_bang_line!
      drop(tree, "(hash_bang_line)")
    end

    ### Values ###

    # Turn each string into its value, however it is quoted, and read its
    # escapes. Keep any other escape as a node of its own, so it can't make
    # two different strings the same. A template with substitutions keeps
    # them, with the text between them as values.
    #
    # 'a'  ->  "a"
    # `a`  ->  "a"
    # "\x41A"  ->  "AA"
    # `a ${n}`  ->  (template_string "a " (template_substitution n))
    def write_strings_as_their_values!
      transform(tree, "[(string) @string (template_string) @string]") do |match|
        string_node(match.node.type, match.node.named_children.map { |part| string_piece(part) })
      end
    end

    # Return a string part's text, or its node if it isn't text, such as a
    # substitution.
    def string_piece(part)
      case part.type
      when "string_fragment" then part.text
      when "escape_sequence" then escape(part)
      else part
      end
    end

    # Return the text that an escape stands for, or the escape's node if it
    # stands for no single character, such as half of a surrogate pair.
    def escape(node)
      code = node.text[1..]
      return ESCAPES.fetch(node.text, node) unless code.match?(/\A(u\h{4}|u\{\h+\}|x\h{2})\z/)

      value = code[/\h+(?=\}?\z)/].to_i(16)
      value.between?(0xD800, 0xDFFF) ? node : [value].pack("U")
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and other nodes. Join neighbouring text.
    def string_node(type, pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(type, *parts)
    end

    ### Names ###

    # Give an arrow function's single bracketed parameter the shape of one
    # without brackets, as the parser does.
    # (x) => x  ->  x => x
    def write_a_lone_arrow_parameter_without_brackets!
      transform(tree, "(arrow_function parameters: (formal_parameters) @parameters)") do |match|
        parameter = lone_parameter(match[:parameters].named_children)
        next nil unless parameter

        match.node.replace_child(match[:parameters], parameter)
        parameter.field = "parameter"
        match.node
      end
    end

    # Return the name of an arrow function's single parameter, if the
    # parameter is only a name.
    def lone_parameter(parameters)
      parameters.first if parameters.one? && parameters.first.type == "identifier"
    end

    # Mark each property that an assignment sets on `this`, so that
    # representation/spec.rb can list it with the other definitions.
    # this.count = 0  ->  (assignment_expression (this_property this count) 0)
    def mark_properties_set_on_this!
      captured(tree, "(assignment_expression left: (member_expression object: (this)) @name)").each do |member|
        member.type = "this_property"
      end
    end
  end
end
