# What this class does to a WebAssembly solution's code to make its representation:
#
# - Drops comments, and the tokens that the tree already shows.
# - Writes folded instructions as plain instructions, and writes every `if`
#   with a `then` branch.
# - Splits `(param i32 i32)` into one group for each type, and the same for
#   locals and results.
# - Moves `(export "f" (func $f))` into the function as `(func $f (export
#   "f"))`.
# - Drops function types without a name that nothing refers to by number.
# - Writes a string as its bytes.
# - Writes numbers as their values (`1_000` is `1000`, `0x1F` is `31`),
#   `f32.const 1` as `f32.const 1.0`, and `i32.const 4294967295` as
#   `i32.const -1`.
# - Writes a file without `(module ...)` the same as one with it.
# - Keeps imports and exports, because they define what the module needs and
#   offers, beyond making names available.
# - Renames every `$name`, because the solution chooses all of them.
# - Ignores files with other extensions, and test and config files.
# - Joins the files into one tree, in an order set by their code. File names
#   never appear.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    # The old representer (exercism/wasm-representer) ran wabt's `wat-desugar`
    # over every file. That tool removes comments and expands folded
    # S-expressions into plain instructions, and it also writes inline
    # exports as separate export fields. It never renamed anything. Here
    # every one of those steps is a rule, and every name that the solution
    # chooses (written `$name`) is renamed.
    class Wasm < Language
      tracks "wasm"
      version 7
      grammar "wat"
      extensions ".wat"

      # A string's text is left out of the tree, apart from its escapes.
      text_nodes :string

      # Every name starts with a `$`.
      names identifier: "$"

      ### Drop ###

      drop "[(line_comment) (block_comment)]"

      # The node types already say what these tokens say. The grammar gives
      # `(if c (then ...) (else ...))`, `if ... else ... end` and the
      # shorthand `(if c t e)` the same node types, and they differ only in
      # these tokens.
      drop_tokens "(", ")", "then", "else", "end", "offset"

      ### Rewrite ###

      # `(i32.add (local.get $a) (local.get $b))` is
      # `local.get $a  local.get $b  i32.add`. A folded instruction is
      # replaced by the plain instructions that it stands for, in the list that
      # holds it.
      rewrite "(_) @node" do |match|
        Wasm.unfold_children(match.node) ? match.node : nil
      end

      # An `if` always has a "then" branch, and has an "else" branch only if
      # that has instructions in it.
      rewrite "(block_if) @if" do |match|
        Wasm.normalise_if(match.node) ? match.node : nil
      end

      # `(param i32 i32)` is `(param i32) (param i32)`, and the same for
      # locals and results.
      rewrite "(_) @node" do |match|
        Wasm.split_groups(match.node) ? match.node : nil
      end

      # `(export "f" (func $f))` is `(func $f (export "f"))`.
      rewrite "(module) @module" do |match|
        Wasm.inline_exports(match.node) ? match.node : nil
      end

      # A type written without a name that nothing refers to by number is the
      # type of a function, which `wat-desugar` worked out for itself.
      rewrite "(module) @module" do |match|
        Wasm.drop_anonymous_types(match.node) ? match.node : nil
      end

      # A string is its value. Escapes are decoded into bytes, so that `\0a`
      # and `\n` are the same.
      rewrite "(string) @string" do |match|
        Wasm.decode(match.node.text[1...-1])
      end

      # Numbers are their values: `1_000` is `1000`, and `0x1F` is `31`.
      numbers(:integer, :uinteger) { |text| Engine::Numbers.integer(text, prefixes: { "0x" => 16 })&.to_s }
      numbers :float do |text|
        value = Engine::Numbers.decimal(text)
        value && Engine::Numbers.write_decimal(value)
      end
      rewrite "(mem_arg /_/) @number" do |match|
        leaf(match.node.type, match.node.text.delete("_"))
      end

      # A constant is its value in its type: `f32.const 1` is `f32.const 1.0`,
      # and `i32.const 4294967295` is `i32.const -1`, as both have the same
      # bits.
      rewrite '(plain_instr (instr_name /\A[if](32|64)\.const\z/) [(integer) (float)] @number)' do |match|
        Wasm.normalise_constant(match.node, match[:number])
      end

      # A file can hold a module's fields without the `(module ...)` around
      # them.
      rewrite "(root (module) @module)", where: lambda { |match|
        match.node.children.size == 1 && match[:module].children.none? { |child| child.type == "identifier" }
      } do |match|
        build(:root, *match[:module].named_children)
      end

      ### Rename ###

      # Every `$name` is chosen by the student: functions, parameters, locals,
      # globals, labels and so on. Other modules are reached by strings.
      rename "(identifier) @name"

      INSTRUCTION_KINDS = %w[func memory global table].freeze
      PLAIN_ESCAPES = { "n" => "\n", "t" => "\t", "r" => "\r", "\\" => "\\", "'" => "'", "\"" => "\"" }.freeze

      # The nodes that are instructions. A folded instruction holds the
      # instructions that it takes as operands.
      INSTRUCTIONS = %w[plain_instr block_block block_loop block_if block_try_table].freeze

      # The groups that can list several types at once.
      GROUPS = %w[param result local].freeze

      class << self
        def normalise_constant(instruction, number)
          kind, bits = instruction.children.find { |child| child.type == "instr_name" }.text.match(/\A([if])(\d+)/).captures
          if kind == "f"
            return nil unless number.type == "integer"

            value = Engine::Numbers.integer(number.text)
            return nil unless value

            instruction.replace_child(number, leaf(:float, Engine::Numbers.write_decimal(value.to_r)))
          else
            return nil unless number.type == "integer" && number.text.match?(/\A-?\d+\z/)

            size = 2**bits.to_i
            value = number.text.to_i % size
            value -= size if value >= size / 2
            return nil if value.to_s == number.text

            instruction.replace_child(number, leaf(:integer, value.to_s))
          end
          instruction
        end

        def instruction?(node) = INSTRUCTIONS.include?(node.type)

        # The operands of a folded instruction: its instruction children, and
        # for an `if` only those before the branches, which are its condition.
        def operands(node)
          return [] unless %w[plain_instr block_if].include?(node.type)

          node.children.select { |child| instruction?(child) }
        end

        # Replaces each folded instruction among the node's children.
        def unfold_children(node)
          return false unless node.children.any? { |child| !operands(child).empty? }

          node.children.replace(node.children.flat_map { |child| unfold(child) })
          true
        end

        # The plain instructions that a folded instruction stands for: its
        # operands first, then the instruction.
        def unfold(node)
          found = operands(node)
          return [node] if found.empty?

          node.children.reject! { |child| found.any? { |operand| operand.equal?(child) } }
          found + [node]
        end

        # A flat `if` has no "then" branch if that has no instructions, and
        # the folded form `(then)` and `(else)` may be empty.
        def normalise_if(node)
          changed = node.children.reject! { |child| child.type == "block_if_else" && child.children.empty? }
          unless node.children.any? { |child| child.type == "block_if_then" }
            position = node.children.index { |child| child.type == "block_if_else" } || node.children.size
            node.children.insert(position, Engine::Node.new("block_if_then", []))
            changed = true
          end
          changed ? true : false
        end

        ### Groups of parameters, results and locals ###

        def split_groups(node)
          return false unless node.children.any? { |child| split?(child) }

          node.children.replace(node.children.flat_map { |child| split?(child) ? split_group(child) : [child] })
          true
        end

        def split?(child) = GROUPS.include?(child.type) && group_types(child).size > 1

        def group_types(group) = group.children.select { |part| part.named? && part.type != "identifier" }

        # Each type gets its own copy of the group's keyword.
        def split_group(group)
          types = group_types(group)
          keywords = group.children.reject { |part| types.include?(part) }
          types.map do |type|
            Engine::Node.new(group.type, keywords.map { |part| Engine.deep_copy(part) } + [Engine.deep_copy(type)])
          end
        end

        ### Types ###

        # Removes `(type (func ...))` fields, if no instruction or function
        # uses a type by number.
        def drop_anonymous_types(module_node)
          return false if descendants(module_node).any? { |node| type_use?(node) }

          before = module_node.children.size
          module_node.children.reject! do |field|
            field.type == "type_def" && field.children.none? { |child| child.type == "identifier" } &&
              descendants(field).any? { |node| node.type == "func_type" } &&
              descendants(field).none? { |node| %w[struct_type array_type cont_type].include?(node.type) }
          end
          module_node.children.size != before
        end

        # The grammar sometimes reads a flat `call_indirect (type 0)` as two
        # instructions, the second one being `type`.
        def type_use?(node)
          node.type == "type_use" || (node.type == "instr_name" && node.text == "type")
        end

        def descendants(node)
          found = []
          node.each_descendant { |descendant| found << descendant }
          found
        end

        ### Exports ###

        # Moves `(export "name" (func $f))` into the function `$f` as
        # `(func $f (export "name") ...)`, for functions, memories, globals
        # and tables defined in this module.
        def inline_exports(module_node)
          fields = module_node.children
          changed = false
          INSTRUCTION_KINDS.each do |kind|
            targets = definitions(fields, kind)
            fields.dup.each do |field|
              target = export_target(field, kind, targets)
              next unless target

              attach_export(target, field)
              fields.delete_if { |other| other.equal?(field) }
              changed = true
            end
          end
          changed
        end

        # The fields that define something of this kind, in index order:
        # imports first, then definitions.
        def definitions(fields, kind)
          fields.select { |field| field.type == "module_field_#{kind}" || import_of?(field, kind) }
        end

        def import_of?(field, kind)
          field.type == "module_field_import" && field.children.any? { |child| child.type == "extern_type_#{kind}" }
        end

        # The definition that an export field points at, if it is in this
        # module and isn't an import.
        def export_target(field, kind, targets)
          return nil unless field.type == "module_field_export"

          desc = field.children.find { |child| child.type == "extern_idx" }
          return nil unless desc&.children&.first&.type == kind

          target = resolve(desc.children.find { |child| child.type == "index" }&.children&.first, targets)
          target&.type == "module_field_#{kind}" ? target : nil
        end

        def resolve(index, targets)
          return nil unless index

          if index.type == "identifier"
            targets.find { |target| target.children.any? { |child| child.type == "identifier" && child.text == index.text } }
          else
            targets[index.text.delete("_").to_i]
          end
        end

        def attach_export(target, field)
          name = field.children.find { |child| %w[string literal].include?(child.type) }
          position = target.children.rindex do |child|
            %w[identifier export].include?(child.type) || INSTRUCTION_KINDS.include?(child.type)
          end
          target.children.insert((position || -1) + 1, Engine::Node.new("export", [Engine::Node.token("export"), name]))
        end

        ### Strings ###

        # Decodes a string's escapes into its bytes. If they aren't valid
        # UTF-8, the string keeps its source text, so two different strings
        # can never get the same value.
        def decode(text)
          bytes = text.b.gsub(/\\(u\{\h+\}|\h\h|.)/m) do
            code = Regexp.last_match(1)
            if code.start_with?("u{") then [code[2..-2].to_i(16)].pack("U").b
            elsif code.match?(/\A\h\h\z/) then [code.to_i(16)].pack("C")
            else PLAIN_ESCAPES.fetch(code, "\\#{code}").b
            end
          end
          value = bytes.force_encoding(Encoding::UTF_8)
          Engine::Node.leaf("literal", value.valid_encoding? ? value : text, quoted: true)
        end
      end
    end
  end
end
