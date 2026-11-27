# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that TypeScript's own parser (typescript-estree) gives.
module Representer::Languages::Typescript::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if (x) { return y }  ->  (if_statement x (statement_block (return_statement y)))
    strip_tokens "return", "function", "class", "if", "else", "while", "for", "do", "new", "export", "break",
                 "continue", "throw", "try", "catch", "finally", "switch", "case", "yield", "debugger"

    # Strip the brackets, commas and other punctuation, because they are
    # layout. Strip the quotes too, because a string's value doesn't depend
    # on them.
    # f(a, b);  ->  (call_expression f (arguments a b))
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", ".", ":", "=>", "${", '"', "'", "`"

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    unwrap :parenthesized_expression

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
        drop_hash_bang_lines!
        write_numbers_as_their_values!
        write_strings_as_their_values!
        drop_brackets_around_a_single_arrow_parameter!
      end
    end

    private
    # Drop the `#!` line, because it only says how to run the file as a script.
    # #!/usr/bin/env node  ->  (nothing)
    def drop_hash_bang_lines!
      drop(tree, "(hash_bang_line)")
    end

    ### Values ###

    # Write each number as its value. JavaScript has one number type, so
    # `1_000`, `1000.0` and `1e3` are the same number. Keep the text of a
    # BigInt and of a number with a leading zero, which is octal.
    #
    # 1_000  ->  1000
    # 1e3  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    def write_numbers_as_their_values!
      each_node(tree) do |node, _|
        next unless node.named? && node.type == "number" && !node.text.match?(/\A0\d|n\z/)

        value = Representer::Engine::Numbers.integer(node.text) || Representer::Engine::Numbers.decimal(node.text)
        node.text = Representer::Engine::Numbers.write_number(value.to_r) if value
      end
    end

    # Turn each string into its value, and read its escapes. Keep a template
    # string's substitutions, and any escape not read here as a node of its
    # own, so it can't make two different strings the same.
    #
    # 'a' and "a"  ->  "a"
    # "\x41"  ->  "A"
    # `a${b}\n`  ->  (template_string "a" (template_substitution b) "\n")
    def write_strings_as_their_values!
      transform(tree, "[(string) @string (template_string) @string]") do |match|
        pieces = string_pieces(match.node)
        next literal(pieces.first || "") if pieces.size <= 1 && !pieces.first.is_a?(Representer::Engine::Node)

        build(:template_string, *pieces.map { |piece| piece.is_a?(String) ? literal(piece) : piece })
      end
    end

    # Return a string's text, joined, and its other parts as they are.
    def string_pieces(string)
      string.named_children.each_with_object([]) do |part, pieces|
        text = part.type == "template_substitution" ? nil : part_text(part)
        next pieces << part unless text

        pieces.last.is_a?(String) ? pieces.last << text : pieces << text.dup
      end
    end

    # Return the text of a part of a string, or nil for an escape that this
    # stage doesn't read, or that stands for no single character, such as
    # half of a surrogate pair.
    def part_text(part)
      return part.text unless part.type == "escape_sequence"

      case part.text
      when /\A\\u\{(\h+)\}\z/, /\A\\u(\h{4})\z/
        value = Regexp.last_match(1).to_i(16)
        [value].pack("U") unless value.between?(0xD800, 0xDFFF) || value > 0x10FFFF
      when /\A\\x([0-7]\h)\z/ then Regexp.last_match(1).to_i(16).chr(Encoding::UTF_8)
      else ESCAPES[part.text]
      end
    end

    ### Parameters ###

    # Drop the brackets around an arrow function's single parameter without a
    # type, as TypeScript's parser does.
    # (x) => x  ->  x => x
    def drop_brackets_around_a_single_arrow_parameter!
      pattern = "(arrow_function parameters: (formal_parameters " \
                "(required_parameter pattern: (identifier) @parameter) @required) @parameters)"
      find_all(tree, pattern).each do |match|
        next unless match[:parameters].named_children.one? && match[:required].children.one?

        match.node.replace_child(match[:parameters], match[:parameter])
        match[:parameter].field = "parameter"
      end
    end
  end
end
