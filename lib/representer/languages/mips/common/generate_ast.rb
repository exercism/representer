# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, which gives one form to the spellings that the assembler
# reads as the same program.
module Representer::Languages::Mips::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the brackets, the commas and the line breaks, because the node
    # types already show them. The assembler reads operands split by spaces
    # the same as operands split by commas.
    # lw $t0, 4($sp)  ->  (instruction lw (operands $t0 (parenthesized_expression 4 (operands $sp))))
    # add $t0 $t0 1  ->  (instruction add (operands $t0 $t0 1))
    strip_tokens "(", ")", ",", "\n", "\r", ";"

    # Write each number as its value. The assembler reads a number that
    # starts with `0` as octal.
    # 0x1F  ->  31
    # 010  ->  8
    numbers_are integer: [:decimal, :hexadecimal, :octal],
                decimal: :float,
                prefixes: { "0x" => 16, "0" => 8 }

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\\\\' => "\\",
      '\"' => '"'
    }.freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        write_each_label_as_its_name!
        give_each_eqv_a_node_of_its_own!
        write_each_macro_call_as_a_call!
      end
    end

    private
    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same.
    # "say \"hi\""  ->  say "hi"
    # "a\x41"  ->  (string "a" \x "41")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        pieces = match.node.text[1..-2].scan(/\\.|[^\\]+/m)
        next literal(string_value(pieces)) if pieces.all? { |piece| read?(piece) }

        runs = pieces.chunk_while { |a, b| read?(a) && read?(b) }
        build(:string, *runs.map { |run| read?(run.first) ? literal(string_value(run)) : leaf(:escape, run.first) })
      end
    end

    def read?(piece) = !piece.start_with?("\\") || ESCAPES.key?(piece)

    def string_value(pieces) = pieces.sum("") { |piece| ESCAPES.fetch(piece, piece) }

    # Write each label as a node that holds its name, without the colon,
    # because the grammar gives the name and the colon as one token.
    # next_byte :  ->  (label next_byte)
    def write_each_label_as_its_name!
      transform(tree, "(label) @label") do |match|
        build(:label, leaf(:symbol, match.node.text.delete_suffix(":").rstrip))
      end
    end

    # Give each `.eqv` a node of its own, with the name it defines in the
    # field `name`, because the assembler reads it as a definition.
    # .eqv LENGTH, 10  ->  (eqv name: LENGTH 10)
    def give_each_eqv_a_node_of_its_own!
      pattern = '(directive mnemonic: (control_mnemonic ".eqv") operands: (directive_operands) @operands)'
      transform(tree, pattern) do |match|
        name, *value = match[:operands].named_children
        build(:eqv, { name: }, *value)
      end
    end

    # Write each call to a macro defined in the file as a call, because the
    # assembler reads a macro's name, with or without a space before its
    # brackets, as a call to the macro. The grammar reads a call with a
    # space, or without brackets, as an instruction.
    # store ('A')  ->  (call_statement store (operands 'A'))
    # clear_registers  ->  (call_statement clear_registers)
    def write_each_macro_call_as_a_call!
      macros = captured(tree, "(directive name: (macro_name) @name)").map(&:text)
      transform(tree, "(instruction mnemonic: (instruction_mnemonic) @name operands: (operands)? @operands)") do |match|
        next nil unless macros.include?(match[:name].text)

        build(:call_statement, { name: leaf(:symbol, match[:name].text) }, { operands: arguments(match[:operands]) })
      end
    end

    # Return the operands inside the brackets of a macro call.
    def arguments(operands)
      children = operands&.named_children || []
      bracketed = children.first if children.one?
      return operands unless bracketed&.type == "parenthesized_expression" && bracketed[:head].nil?

      bracketed[:arguments]
    end
  end
end
