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
      version 3
      grammar "wat"
      extensions ".wat"

      # A string's text is left out of the tree, apart from its escapes.
      text_nodes :string

      # Every name starts with a `$`.
      names identifier: "$"

      ### Drop ###

      comments "[(comment_line) (comment_block)]"

      # The node types already say what these brackets say.
      drop_tokens "(", ")"

      ### Rewrite ###

      # `(i32.add (local.get $a) (local.get $b))` is
      # `local.get $a  local.get $b  i32.add`. A folded instruction is
      # replaced by the plain instructions that it stands for, in the list that
      # holds it.
      rewrite "(_ (instr (expr))) @node" do |match|
        Wasm.unfold_children(match.node) ? match.node : nil
      end
      rewrite "(offset_expr (expr)) @offset" do |match|
        Wasm.unfold_offset(match.node) ? match.node : nil
      end

      # `(param i32 i32)` is `(param i32) (param i32)`, and the same for
      # locals and results.
      rewrite "(module_field_func) @func" do |match|
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

      # 1_000 is 1000.
      rewrite "[(dec_nat /_/) @number (hex_nat /_/) @number (dec_num /_/) @number]" do |match|
        leaf(match.node.type, match.node.text.delete("_"))
      end

      ### Rename ###

      # Every `$name` is chosen by the student: functions, parameters, locals,
      # globals, labels and so on. Other modules are reached by strings.
      rename "(identifier) @name"

      INSTRUCTION_KINDS = %w[func memory global table].freeze
      PLAIN_ESCAPES = { "n" => "\n", "t" => "\t", "r" => "\r", "\\" => "\\", "'" => "'", "\"" => "\"" }.freeze

      class << self
        def instr_with_expr?(node) = node.type == "instr" && node.children.any? { |child| child.type == "expr" }

        # Replaces each folded instruction among the node's children.
        def unfold_children(node)
          return false unless node.children.any? { |child| instr_with_expr?(child) }

          node.children.replace(node.children.flat_map do |child|
            instr_with_expr?(child) ? unfold(child.children.find { |part| part.type == "expr" }) : [child]
          end)
          true
        end

        def unfold_offset(offset)
          offset.children.replace(offset.children.flat_map { |child| child.type == "expr" ? unfold(child) : [child] })
          true
        end

        # The plain instructions that a folded expression stands for: its
        # operands first, then the instruction.
        def unfold(expr)
          inner = expr.named_children.first&.named_children&.first
          return [instruction(expr)] unless inner

          operands = inner.children.select { |child| child.type == "expr" }
          rest = inner.children.reject { |child| child.type == "expr" }
          case inner.type
          when "expr1_plain" then unfold_all(operands) + rest.map { |plain| instruction(plain) }
          when "expr1_block" then [instruction(block("block_block", rest))]
          when "expr1_loop" then [instruction(block("block_loop", rest))]
          when "expr1_if" then unfold_if(rest)
          when "expr1_call" then unfold_all(operands) + [instruction(Engine::Node.new("instr_call", rest))]
          else [instruction(expr)]
          end
        end

        def unfold_all(exprs) = exprs.flat_map { |expr| unfold(expr) }

        def descendants(node)
          found = []
          node.each_descendant { |descendant| found << descendant }
          found
        end

        def instruction(child) = Engine::Node.new("instr", [child])

        def block(type, children)
          Engine::Node.new("instr_block", [Engine::Node.new(type, children + [Engine::Node.token("end")])])
        end

        # `(if $l (result i32) (cond) (then ...) (else ...))` is the condition's
        # instructions, then `if $l (result i32) ... else ... end`.
        def unfold_if(rest)
          body = rest.find { |child| child.type == "if_block" }
          return [instruction(Engine::Node.new("expr1_if", rest))] unless body

          lists = body.children.select { |child| child.type == "instr_list" }
          branches = [lists.first]
          branches += [Engine::Node.token("else"), lists[1]] if lists[1]
          children = (rest - [body]) + body.children.select { |child| child.type == "func_type_results" } + branches
          unfold_all(body.children.select { |child| child.type == "expr" }) + [instruction(block("block_if", children))]
        end

        ### Groups of parameters, results and locals ###

        def split_groups(func)
          changed = false
          children = func.children.flat_map do |child|
            parts = split_group(child)
            changed ||= parts.size > 1
            parts
          end
          func.children.replace(children) if changed
          changed
        end

        def split_group(child)
          case child.type
          when "func_type_params" then split_many(child, "func_type_params_many")
          when "func_locals" then split_many(child, "func_locals_many")
          when "func_type_results" then split_results(child)
          else [child]
          end
        end

        def split_many(group, inner_type)
          many = group.children.find { |part| part.type == inner_type }
          types = many ? many.children.select { |part| part.type == "value_type" } : []
          return [group] if types.size < 2

          keywords = many.children.reject { |part| part.type == "value_type" }
          types.map do |type|
            Engine::Node.new(group.type, [Engine::Node.new(inner_type, keywords.map do |part|
              Engine.deep_copy(part)
            end + [Engine.deep_copy(type)])])
          end
        end

        def split_results(group)
          types = group.children.select { |part| part.type == "value_type" }
          return [group] if types.size < 2

          keywords = group.children.reject { |part| part.type == "value_type" }
          types.map { |type| Engine::Node.new(group.type, keywords.map { |part| Engine.deep_copy(part) } + [Engine.deep_copy(type)]) }
        end

        ### Types ###

        # Removes `(type (func ...))` fields, if no instruction or function
        # uses a type by number.
        def drop_anonymous_types(module_node)
          return false if descendants(module_node).any? { |node| node.type == "type_use" }

          before = module_node.children.size
          module_node.children.reject! do |field|
            inner = field.type == "module_field" ? field.children.first : field
            inner&.type == "module_field_type" && inner.children.none? { |child| child.type == "identifier" }
          end
          module_node.children.size != before
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
          fields.filter_map do |field|
            inner = field.type == "module_field" ? field.children.first : field
            next unless inner

            inner if inner.type == "module_field_#{kind}" || import_of?(inner, kind)
          end
        end

        def import_of?(inner, kind)
          inner.type == "module_field_import" && descendants(inner).any? { |node| node.type.start_with?("import_desc_#{kind}") }
        end

        # The definition that an export field points at, if it is in this
        # module and isn't an import.
        def export_target(field, kind, targets)
          export = field.type == "module_field" ? field.children.first : field
          return nil unless export&.type == "module_field_export"

          desc = export.children.find { |child| child.type == "export_desc" }&.children&.first
          return nil unless desc&.type == "export_desc_#{kind}"

          index = desc.children.find { |child| child.type == "index" }&.children&.first
          target = resolve(index, targets)
          target&.type == "module_field_#{kind}" ? target : nil
        end

        def resolve(index, targets)
          return nil unless index

          if index.type == "identifier"
            targets.find { |target| target.children.any? { |child| child.type == "identifier" && child.text == index.text } }
          else
            targets[descendants(index).find { |node| node.type == "dec_nat" }&.text.to_i]
          end
        end

        def attach_export(target, field)
          export = field.type == "module_field" ? field.children.first : field
          name = export.children.find { |child| child.type == "name" }
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
