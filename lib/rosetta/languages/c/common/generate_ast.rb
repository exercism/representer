# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, which gives one form to the spellings that a C compiler
# reads as one.
module Rosetta::Languages::C::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if (x) { return y; }  ->  (if_statement x (compound_statement (return_statement y)))
    strip_tokens "return", "if", "else", "while", "for", "do", "switch", "struct", "enum", "union", "typedef",
                 "break", "continue", "goto", "sizeof", "#define", "#if", "#elif", "#else", "#endif"

    # Strip the brackets, commas and other punctuation, because they are layout.
    # f(a, b);  ->  (call_expression f (argument_list a b))
    strip_tokens "(", ")", "{", "}", "[", "]", ";", ",", "\n"

    # Keep the `;` in a `for`, because it is the only thing that tells
    # these apart.
    # for (;; i++) and for (i++;;)
    keep_tokens ";", in: :for_statement

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping.
    # (a % 4 == 0) && b  ->  a % 4 == 0 && b
    # if ((a = b))  ->  if (a = b)
    unwrap :parenthesized_expression, :preproc_parenthesized_expression

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\a' => "\a",
      '\b' => "\b",
      '\f' => "\f",
      '\v' => "\v",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'",
      '\?' => "?"
    }.freeze

    INT = (0...(2**31))

    def call
      tree.tap do
        write_numbers_as_their_values!
        write_strings_as_their_values!
        put_the_else_branch_in_the_if!
      end
    end

    private
    ### Values ###

    # Write each number as its value. A leading 0 means octal. An integer
    # only changes if it fits in an int, because the type of a larger one
    # depends on how it is written: 0xFFFFFFFF is an unsigned int, and
    # 4294967295 is a long. A number with a suffix keeps its text.
    #
    # 0x1F  ->  31
    # 017  ->  15
    # 1.50  ->  1.5
    def write_numbers_as_their_values!
      each_node(tree) do |node, _|
        next unless node.type == "number_literal"

        value = number(node.text.delete("'"))
        node.text = value if value
      end
    end

    def number(text)
      text = "0o#{text[1..]}" if text.match?(/\A0\d/)
      value = Rosetta::Engine::Numbers.integer(text, separator: "")
      return INT.cover?(value) ? value.to_s : nil if value
      return nil if text.match?(/\A0[xb]/i)

      value = Rosetta::Engine::Numbers.decimal(text, separator: "")
      value && Rosetta::Engine::Numbers.write_decimal(value)
    end

    # Turn each plain string into its value, and read its escapes. Join
    # strings written next to each other, as the compiler does. A string
    # with a prefix, such as L"a", keeps its text, and so does an escape
    # that isn't listed, so two different strings can never get the same
    # value.
    #
    # "a\x41"  ->  "aA"
    # "a" "b"  ->  "ab"
    def write_strings_as_their_values!
      transform(tree, '(string_literal "\"") @string') do |match|
        next nil unless plain_string?(match.node)

        literal(match.node.named_children.map { |part| part.type == "escape_sequence" ? decode(part.text) : part.text }.join)
      end
      transform(tree, "(concatenated_string) @string") do |match|
        literal(match.node.children.map(&:text).join) if match.node.children.all? { |part| part.type == "literal" }
      end
    end

    def plain_string?(node)
      node.children.all? { |child| ['"', "string_content", "escape_sequence"].include?(child.type) }
    end

    # Return the text that an escape stands for, or the escape itself if it
    # stands for no single character, such as half of a surrogate pair.
    def decode(escape)
      code = escape[1..]
      case code
      when /\Au(\h{4})\z/, /\AU(\h{8})\z/
        value = Regexp.last_match(1).to_i(16)
        value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
      when /\A[0-7]{1,3}\z/ then code.to_i(8) > 127 ? escape : code.to_i(8).chr
      when /\Ax([0-7]\h?)\z/ then Regexp.last_match(1).to_i(16).chr
      else ESCAPES.fetch(escape, escape)
      end
    end

    ### Statements ###

    # Put the statement after an `else` straight into its `if`, as the
    # compiler does.
    # if (a) { } else { }  ->  (if_statement a (compound_statement) (compound_statement))
    def put_the_else_branch_in_the_if!
      captured(tree, "(if_statement alternative: (else_clause) @name)").each do |clause|
        branch = clause.named_children.first
        clause.type = branch.type
        clause.children = branch.children
      end
    end
  end
end
