# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, which gives one form to the spellings that WebAssembly's
# text format reads as the same module.
module Rosetta::Languages::Wasm::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the brackets, the keywords of `if` and the `offset` of a
    # segment, because the node types already show them. The grammar gives
    # `(if c (then ...) (else ...))`, `if ... else ... end` and `(if c t e)`
    # the same node types, and they differ only in these tokens.
    # (i32.const 1)  ->  (plain_instr i32.const 1)
    # (offset (i32.const 0))  ->  (offset (plain_instr i32.const 0))
    strip_tokens "(", ")", "then", "else", "end", "offset"

    # Write each number as its value.
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    numbers_are integer: [:integer, :uinteger],
                decimal: :float,
                prefixes: { "0x" => 16 }

    INSTRUCTIONS = ["plain_instr", "block_block", "block_loop", "block_if", "block_try_table"].freeze
    GROUPS = ["param", "result", "local"].freeze
    EXPORTED_KINDS = ["func", "memory", "global", "table"].freeze
    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\\\\' => "\\",
      "\\'" => "'",
      '\"' => '"'
    }.freeze

    def call
      tree.tap do
        write_folded_instructions_as_plain_instructions!
        give_every_if_a_then_branch!
        give_each_type_in_a_group_its_own_group!
        move_each_export_into_its_definition!
        drop_function_types_without_a_name!
        write_strings_as_their_bytes!
        drop_underscores_from_memory_offsets!
        write_each_constant_as_its_value_in_its_type!
        drop_the_module_around_a_whole_file!
      end
    end

    private
    ### Instructions ###

    # Write each folded instruction as the plain instructions it stands for:
    # its operands first, then the instruction.
    # (i32.add (local.get $a) (i32.const 1))  ->  local.get $a  i32.const 1  i32.add
    def write_folded_instructions_as_plain_instructions!
      nodes = []
      each_node(tree) { |node, _| nodes << node }
      nodes.reverse_each do |node|
        next if node.children.none? { |child| operands(child).any? }

        node.children = node.children.flat_map { |child| [*take_operands(child), child] }
      end
    end

    # Return a folded instruction's operands: its instruction children, which
    # for an `if` are its condition.
    def operands(node)
      return [] unless ["plain_instr", "block_if"].include?(node.type)

      node.children.select { |child| INSTRUCTIONS.include?(child.type) }
    end

    def take_operands(node)
      operands(node).tap { |found| node.children.reject! { |child| found.any? { |operand| operand.equal?(child) } } }
    end

    # Give every `if` a "then" branch, and drop an empty "else" branch. A flat
    # `if` has no "then" branch if that has no instructions, and the folded
    # `(then)` and `(else)` may be empty.
    # if else nop end  ->  (block_if (block_if_then) (block_if_else nop))
    # (if (then nop) (else))  ->  (block_if (block_if_then nop))
    def give_every_if_a_then_branch!
      each_node(tree) do |node, _|
        next unless node.type == "block_if"

        node.children.reject! { |child| child.type == "block_if_else" && child.named_children.empty? }
        next if node.children.any? { |child| child.type == "block_if_then" }

        position = node.children.index { |child| child.type == "block_if_else" } || node.children.size
        node.children.insert(position, build(:block_if_then))
      end
    end

    ### Groups ###

    # Give each type in a group of parameters, results or locals a group of
    # its own.
    # (param i32 i64)  ->  (param i32) (param i64)
    def give_each_type_in_a_group_its_own_group!
      each_node(tree) do |node, _|
        next if node.children.none? { |child| several_types?(child) }

        node.children = node.children.flat_map { |child| several_types?(child) ? split(child) : [child] }
      end
    end

    def several_types?(node) = GROUPS.include?(node.type) && types_in(node).size > 1

    def types_in(group) = group.children.select { |part| part.named? && part.type != "identifier" }

    def split(group)
      types = types_in(group)
      keywords = group.children.reject { |part| types.include?(part) }
      types.map { |type| build(group.type, *keywords.map { |part| copy(part) }, copy(type)) }
    end

    ### Exports ###

    # Move each export of a function, memory, global or table defined in the
    # module into its definition.
    # (func $f) (export "f" (func $f))  ->  (func $f (export "f"))
    def move_each_export_into_its_definition!
      each_node(tree) do |node, _|
        next unless node.type == "module"

        EXPORTED_KINDS.each { |kind| move_exports_of_kind(node.children, kind) }
      end
    end

    def move_exports_of_kind(fields, kind)
      definitions = fields.select { |field| field.type == "module_field_#{kind}" || import_of?(field, kind) }
      fields.dup.each do |field|
        target = export_target(field, kind, definitions)
        next unless target

        add_export(target, field)
        fields.delete_if { |other| other.equal?(field) }
      end
    end

    def import_of?(field, kind)
      field.type == "module_field_import" && field.children.any? { |child| child.type == "extern_type_#{kind}" }
    end

    # Return the definition that an export points at, unless it is an
    # import. The definitions are in index order: imports first.
    def export_target(field, kind, definitions)
      return nil unless field.type == "module_field_export"

      description = field.children.find { |child| child.type == "extern_idx" }
      return nil unless description&.children&.any? { |child| child.type == kind }

      index = description.children.find { |child| child.type == "index" }&.children&.first
      target = index && definition_at(index, definitions)
      target&.type == "module_field_#{kind}" ? target : nil
    end

    def definition_at(index, definitions)
      return definitions[index.text.delete("_").to_i] unless index.type == "identifier"

      definitions.find do |definition|
        definition.children.any? { |child| child.type == "identifier" && child.text == index.text }
      end
    end

    def add_export(target, field)
      name = field.children.find { |child| ["string", "literal"].include?(child.type) }
      position = target.children.rindex do |child|
        ["identifier", "export"].include?(child.type) || EXPORTED_KINDS.include?(child.type)
      end
      target.children.insert((position || -1) + 1, build(:export, token("export"), name))
    end

    ### Types ###

    # Drop each function type without a name, if no instruction or function
    # uses a type by its number. Such a type only gives a function's type,
    # which a function written without it has too.
    # (type (func (param i32))) (func (param i32))  ->  (func (param i32))
    def drop_function_types_without_a_name!
      each_node(tree) do |node, _|
        next unless node.type == "module" && descendants(node).none? { |descendant| type_use?(descendant) }

        node.children.reject! { |field| function_type_without_a_name?(field) }
      end
    end

    # The grammar sometimes reads a flat `call_indirect (type 0)` as two
    # instructions, the second one being `type`.
    def type_use?(node)
      node.type == "type_use" || (node.type == "instr_name" && node.text == "type")
    end

    def function_type_without_a_name?(field)
      field.type == "type_def" && field.children.none? { |child| child.type == "identifier" } &&
        descendants(field).any? { |node| node.type == "func_type" } &&
        descendants(field).none? { |node| ["struct_type", "array_type", "cont_type"].include?(node.type) }
    end

    def descendants(node)
      found = []
      node.each_descendant { |descendant| found << descendant }
      found
    end

    ### Values ###

    # Write each string as its bytes, so that `\0a` and `\n` are the same. If
    # the bytes aren't valid UTF-8, keep the string's text, so two different
    # strings can never get the same value.
    # "a\0a"  ->  "a\n"
    # "\u{41}"  ->  "A"
    def write_strings_as_their_bytes!
      transform(tree, "(string) @string") do |match|
        text = match.node.text[1...-1]
        value = decode(text).force_encoding(Encoding::UTF_8)
        literal(value.valid_encoding? ? value : text)
      end
    end

    def decode(text)
      text.b.gsub(/\\(u\{\h+\}|\h\h|.)/m) do
        code = Regexp.last_match(1)
        if code.start_with?("u{") then [code[2..-2].to_i(16)].pack("U").b
        elsif code.match?(/\A\h\h\z/) then [code.to_i(16)].pack("C")
        else ESCAPES.fetch("\\#{code}", "\\#{code}").b
        end
      end
    end

    # Drop the underscores from a memory offset or alignment.
    # offset=1_000  ->  offset=1000
    def drop_underscores_from_memory_offsets!
      each_node(tree) { |node, _| node.text = node.text.delete("_") if node.type == "mem_arg" && node.leaf? }
    end

    # Write each constant as its value in its type, because a constant with
    # the same bits is the same value.
    # f32.const 1  ->  f32.const 1.0
    # i32.const 4294967295  ->  i32.const -1
    def write_each_constant_as_its_value_in_its_type!
      pattern = '(plain_instr (instr_name /\A[if](32|64)\.const\z/) [(integer) (float)] @number)'
      find_all(tree, pattern).each do |match|
        kind, bits = match.node.children.find { |child| child.type == "instr_name" }.text.match(/\A([if])(\d+)/).captures
        value = kind == "f" ? float_constant(match[:number]) : integer_constant(match[:number], bits.to_i)
        match.node.replace_child(match[:number], value) if value
      end
    end

    def float_constant(number)
      value = number.type == "integer" && Rosetta::Engine::Numbers.integer(number.text)
      value && leaf(:float, Rosetta::Engine::Numbers.write_decimal(value.to_r))
    end

    # Return the integer with the same bits, as a signed number.
    def integer_constant(number, bits)
      return nil unless number.type == "integer" && number.text.match?(/\A-?\d+\z/)

      size = 2**bits
      value = number.text.to_i % size
      value -= size if value >= size / 2
      value.to_s == number.text ? nil : leaf(:integer, value.to_s)
    end

    ### Module ###

    # Drop the `(module ...)` around a whole file, because a file can hold a
    # module's fields without it. A module with a name keeps it.
    # (module (func))  ->  (func)
    def drop_the_module_around_a_whole_file!
      return unless tree.children.one?

      mod = tree.children.first
      tree.children = mod.named_children if mod.type == "module" && mod.children.none? { |child| child.type == "identifier" }
    end
  end
end
