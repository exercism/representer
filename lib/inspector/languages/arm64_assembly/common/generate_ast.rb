# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, which gives one form to the spellings that the assembler
# reads as the same program.
module Inspector::Languages::Arm64Assembly::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the punctuation, because the node types and fields already show it.
    # ldp x0, x1, [sp], #16  ->  (instruction ldp x0 x1 (memory sp) 16)
    strip_tokens ",", ":", ";", "[", "]", "{", "}", "(", ")", "\\", "\"", "=", ".req", ".macro", ".endm"

    # Strip the keyword of `.equ` and `.set`, because the assembler reads
    # `.equ`, `.set` and `=` as the same definition. `.eqv` and `.equiv`
    # keep theirs, because they define a symbol differently.
    # .equ SIZE, 8  ->  (symbol_definition SIZE 8)
    # SIZE = 8  ->  (symbol_definition SIZE 8)
    strip_tokens ".equ", ".set", only_in: :symbol_definition

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Unwrap each immediate too, because the assembler reads an
    # operand with or without its `#` as the same value.
    # #(1 << 4)  ->  1 << 4
    # mov x0, #1  ->  mov x0, 1
    unwrap :parenthesized_expression, :immediate

    # Write each number as its value. The assembler reads a number that
    # starts with `0` as octal.
    # 0x1F  ->  31
    # 010  ->  8
    numbers_are integer: :number,
                decimal: :float,
                prefixes: { "0x" => 16, "0b" => 2, "0" => 8 }

    CASE_INSENSITIVE = ["mnemonic", "register", "shift_operator", "extend_operator", "arrangement"].freeze

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\\\\' => "\\",
      '\"' => '"'
    }.freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        write_each_char_with_its_closing_quote!
        write_each_macro_call_as_a_call!
        write_each_local_label_reference_as_its_label_and_direction!
        write_global_as_globl!
        write_mnemonics_registers_and_operators_in_lower_case!
      end
    end

    private
    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same.
    # "say \"hi\""  ->  say "hi"
    # "a\x41"  ->  (string "a" \x41)
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

    # Give each character its closing quote, because the assembler reads a
    # character with or without one as the same value.
    # 'a  ->  'a'
    def write_each_char_with_its_closing_quote!
      transform(tree, "(char) @char") do |match|
        leaf(:char, "'#{match.node.text[/\A'(\\.|.)/m, 1]}'")
      end
    end

    # Write each use of a macro defined in the file as a call, because the
    # grammar reads it as an instruction.
    # LOAD x3, bottles  ->  (macro_call LOAD x3 bottles)
    def write_each_macro_call_as_a_call!
      macros = captured(tree, "(macro_definition name: (identifier) @name)").map(&:text)
      transform(tree, "(instruction mnemonic: (mnemonic) @name) @instruction") do |match|
        next nil unless macros.include?(match[:name].text)

        build(:macro_call, { name: leaf(:identifier, match[:name].text) }, *match[:instruction].children[1..])
      end
    end

    # Split each reference to a local label, such as `1b`, into the label it
    # names and the way to look for it, so the label can be renamed. `b`
    # looks back for the label, and `f` looks forward.
    # b 1b  ->  (instruction b (local_label_reference 1 b))
    def write_each_local_label_reference_as_its_label_and_direction!
      transform(tree, "(local_label_reference) @reference") do |match|
        text = match.node.text
        build(:local_label_reference, leaf(:local_label, text[0..-2]), leaf(:direction, text[-1].downcase))
      end
    end

    # Write `.global` as `.globl`, because the assembler accepts both
    # spellings of the same directive.
    # .global main  ->  .globl main
    def write_global_as_globl!
      captured(tree, '(directive name: (directive_name ".global") @name)').each { |name| name.text = ".globl" }
    end

    # Write mnemonics, registers, shifts, extends and conditions in lower
    # case, because the assembler ignores their case.
    # MOV X0, #1  ->  mov x0, 1
    # csel x0, x1, x2, EQ  ->  csel x0, x1, x2, eq
    def write_mnemonics_registers_and_operators_in_lower_case!
      each_node(tree) do |node, _|
        node.text = node.text.downcase if CASE_INSENSITIVE.include?(node.type) && node.leaf?
        node.children = node.children.map { |child| token(child.text.downcase) } if node.type == "condition"
      end
    end
  end
end
