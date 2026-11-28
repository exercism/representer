# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, which gives one form to the spellings that NASM reads as the
# same program.
module Rosetta::Languages::X8664Assembly::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the punctuation, because the node types and fields already show it.
    # mov rax, [rbx]  ->  (instruction mov (register rax) (memory_operand (register rbx)))
    strip_tokens ",", ":", "[", "]", "(", ")"

    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. NASM reads `segment` as `section`, so both are
    # stripped.
    # section .text  ->  (section_directive .text)
    # times 3 nop  ->  (instruction (times 3) nop)
    strip_tokens "section", "segment", "equ", "times", "bits", "cpu", "default", "struc", "endstruc",
                 "%define", "%assign", "%undef", "%include", "%macro", "%endmacro", "%elif", "%else", "%endif",
                 "%rep", "%endrep"

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping.
    # (1 + 2) * 3  ->  1 + 2 * 3
    unwrap :parenthesized_expression

    # Write each number with a base prefix as its value. NASM reads a number
    # that starts with `0` as decimal.
    # 0x1F  ->  31
    # 0b1010_1010  ->  170
    # $1F  ->  31
    # 010  ->  10
    numbers_are integer: :number,
                decimal: :number,
                prefixes: { "0x" => 16, "0h" => 16, "$" => 16, "0b" => 2, "0y" => 2, "0o" => 8, "0q" => 8,
                            "0d" => 10, "0t" => 10 }

    SUFFIX_BASES = { "h" => 16, "x" => 16, "b" => 2, "y" => 2, "o" => 8, "q" => 8, "d" => 10, "t" => 10 }.freeze

    def call
      tree.tap do
        write_numbers_with_a_base_suffix_as_their_values!
        write_strings_as_their_values!
        write_each_label_before_a_definition_as_its_name!
        write_each_macro_use_as_a_call!
        write_mnemonics_in_lower_case!
        drop_layout_from_preprocessor_arguments!
      end
    end

    private
    # Write each number with a base suffix as its value.
    # 0Ah  ->  10
    # 101b  ->  5
    def write_numbers_with_a_base_suffix_as_their_values!
      captured(tree, "(number) @name").each do |number|
        base = SUFFIX_BASES[number.text[-1].downcase]
        digits = number.text[0..-2].delete("_")
        number.text = digits.to_i(base).to_s if base && digits.match?(Rosetta::Engine::Numbers::DIGITS.fetch(base))
      end
    end

    # Turn each string into its value. NASM reads no escapes in a string in
    # single or double quotes, so `'a'` and `"a"` are the same. A string in
    # backquotes keeps each escape as a leaf of its own, so it can't make two
    # different strings the same.
    # 'hi'  ->  "hi"
    # `a\n`  ->  (string "a" \n)
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        text = match.node.text
        body = text[1..-2]
        next literal(body) unless text.start_with?("`") && body.include?("\\")

        pieces = body.scan(/\\.|[^\\]+/m)
        build(:string, *pieces.map { |piece| piece.start_with?("\\") ? leaf(:escape, piece) : literal(piece) })
      end
    end

    # Give a label to the data or constant definition after it, because NASM
    # reads a label before a definition, with or without its colon, as the
    # definition's name.
    # msg: db "hi"  ->  msg db "hi"
    # SIZE: equ 8  ->  SIZE equ 8
    def write_each_label_before_a_definition_as_its_name!
      each_node(tree) do |node, _|
        node.children = node.children.each_with_object([]) do |child, children|
          if ["data_definition", "equ_definition"].include?(child.type) && !child[:name] && children.last&.type == "label"
            child.children = [children.pop[:name], *child.children]
          end
          children << child
        end
      end
    end

    # Write each use of a macro defined in the file as a call, because the
    # grammar reads it as an instruction.
    # PUSHALL rax  ->  (macro_call PUSHALL (register rax))
    def write_each_macro_use_as_a_call!
      macros = captured(tree, "(macro_definition name: (identifier) @name)").map(&:text)
      transform(tree, "(instruction mnemonic: (mnemonic) @name) @instruction") do |match|
        next nil unless macros.include?(match[:name].text)

        children = match[:instruction].children.map do |child|
          child.equal?(match[:name]) ? leaf(:identifier, child.text, field: :name) : child
        end
        build(:macro_call, *children)
      end
    end

    # Write mnemonics in lower case, because NASM ignores their case.
    # MOV rax, 1  ->  mov rax, 1
    def write_mnemonics_in_lower_case!
      captured(tree, "(mnemonic) @name").each { |mnemonic| mnemonic.text = mnemonic.text.downcase }
    end

    # Write each preprocessor argument with one space between its words and
    # none around its commas, because NASM's preprocessor reads the argument
    # as tokens. An argument with quotes keeps its text, because the spaces
    # inside a string matter.
    # %ifidn  __OUTPUT_FORMAT__, elf64  ->  %ifidn __OUTPUT_FORMAT__,elf64
    def drop_layout_from_preprocessor_arguments!
      captured(tree, "(preproc_arg) @name").each do |argument|
        next if argument.text.match?(/['"`]/)

        argument.text = argument.text.strip.gsub(/\s*,\s*/, ",").gsub(/\s+/, " ")
      end
    end
  end
end
