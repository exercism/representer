module Representer
  module Languages
    # Every step of exercism/nim-representer is a rule here. The old
    # representer ran Nim's own compiler macros, so it saw the code after Nim
    # had parsed it: operators were calls, commands were calls, brackets were
    # gone, `fmt` and `&` strings were one thing, and names ignored case after
    # the first letter and underscores. Each rule's comment says which step it
    # replaces.
    class Nim < Language
      tracks "nim"
      version 2
      grammar "nim"
      extensions ".nim", ".nims"

      # `local` is a variable or parameter that the student defines,
      # `definition` is a proc, type, field or enum value that the student
      # defines, and `field` is a name after a dot inside a `fmt` string.
      names :identifier, :local, :definition, :field

      # Nim treats `helloWorld`, `hello_world` and `helloworld` as one name,
      # but `HelloWorld` as another.
      fold_names { |name| name.empty? ? name : name[0] + name[1..].delete("_").downcase }

      WORD_OPERATORS = %w[and or not xor in notin is isnot of div mod shl shr].freeze
      ROUTINES = %w[proc func method iterator template macro converter].map { |kind| "#{kind}_declaration" }.freeze
      ROUTINE_PATTERN = "[#{ROUTINES.map { |kind| "(#{kind}) @declaration" }.join(' ')}]".freeze

      ### Drop ###

      drop "[(comment) (documentation_comment) (block_comment) (block_documentation_comment)]"

      # The node types already say what these tokens say. A call `f(x)` and a
      # command `f x` are the same, so the brackets of arguments go too.
      drop_tokens "(", ")", ",", ";", "`", "[", "]", "{", "}"

      ### Rewrite ###

      # (a + b) is a + b: the tree's shape already shows the grouping.
      unwrap :parenthesized

      # 1_000 is 1000.
      rewrite "[(integer_literal /_/) @number (float_literal /_/) @number]" do |match|
        leaf(match[:number].type, match[:number].text.delete("_"))
      end

      # A string is its text.
      rewrite("(interpreted_string_literal) @string") { |match| Nim.string_text(match[:string].children) }

      # `fmt"x {a}"` and `&"x {a}"` are the same, and the names in the braces
      # are names in the code.
      rewrite '(generalized_string function: (identifier "fmt")) @string' do |match|
        Nim.format_string(Nim.string_text(match[:string].children.drop(1))&.text)
      end
      rewrite '(prefix_expression operator: (operator "&") (literal) @string)' do |match|
        Nim.format_string(match[:string].text)
      end

      # An operator is a call: `a + b` is `+`(a, b), and `$x` is `$`(x).
      rewrite "(infix_expression) @expression", where: ->(match) { Nim.operator_call?(match.node) } do |match|
        Nim.operator_call(match.node["operator"], match.node["left"], match.node["right"])
      end
      rewrite "(prefix_expression) @expression", where: ->(match) { match.node.children.size == 2 } do |match|
        Nim.operator_call(match.node.children.first, match.node.children.last)
      end
      # `+`(a, b) written with backticks.
      rewrite("(accent_quoted (identifier) @operator)", where: ->(match) { Nim.operator?(match[:operator].text) }) do |match|
        build(:accent_quoted, leaf(:operator, match[:operator].text))
      end

      # `proc f(a, b: int)` is `proc f(a: int; b: int)`.
      rewrite("(parameter_declaration_list) @list") { |match| Nim.split_parameters(match.node) }

      # A routine without parentheses, `proc f = discard`, is `proc f() = discard`.
      rewrite("[#{ROUTINES.map { |kind| "(#{kind}) @routine" }.join(' ')}]") { |match| Nim.add_empty_parameters(match.node) }

      # Imports are in alphabetical order.
      rewrite("(import_statement) @statement") { |match| Nim.sort_imports(match.node) }
      rewrite("(import_from_statement) @statement") { |match| Nim.sort_imports(match.node) }
      rewrite("(export_statement) @statement") { |match| Nim.sort_imports(match.node) }
      rewrite("(include_statement) @statement") { |match| Nim.sort_imports(match.node) }
      rewrite("(except_clause) @statement") { |match| Nim.sort_imports(match.node) }

      # Names that the student defines.
      rewrite("(variable_declaration) @declaration") do |match|
        Nim.name_declared(match.node.children.first, :local) ? match.node : nil
      end
      rewrite("(parameter_declaration) @declaration") do |match|
        Nim.name_declared(match.node.children.first, :local) ? match.node : nil
      end
      rewrite("(for) @loop") { |match| Nim.name_declared(match.node["left"], :local) ? match.node : nil }
      rewrite("(field_declaration) @declaration") do |match|
        Nim.name_declared(match.node.children.first, :definition) ? match.node : nil
      end
      rewrite("(enum_field_declaration) @declaration") { |match| Nim.name_declared(match.node, :definition) ? match.node : nil }
      rewrite("(type_symbol_declaration) @declaration") { |match| Nim.name_defined(match.node["name"]) ? match.node : nil }
      rewrite(ROUTINE_PATTERN) { |match| Nim.name_defined(match.node["name"]) ? match.node : nil }

      ### Rename and keep ###

      rename "(local) @name"
      rename_member "(definition) @name"
      member "[(dot_expression right: (identifier) @name) (dot_expression right: (field) @name)]"

      # The variable that Nim declares in every proc with a result.
      keep "result"
      library_names File.join(__dir__, "library_names", "nim.txt")

      class << self
        def operator?(text) = text.match?(/\A[^A-Za-z_]/) || WORD_OPERATORS.include?(text)

        # `import a as b` renames the module, so it stays an infix expression.
        def operator_call?(node)
          operator = node["operator"]
          operator && node["left"] && node["right"] && operator.text != "as"
        end

        def operator_call(operator, *arguments)
          return nil unless operator&.leaf?

          build(:call, { function: build(:accent_quoted, leaf(:operator, operator.text)) }, build(:argument_list, *arguments))
        end

        # The text of a string, with its escapes as they were written, or nil
        # if the string has anything else in it.
        def string_text(children)
          parts = children.reject { |child| child.type == "\"" }
          return nil unless parts.all? { |part| %w[string_content escape_sequence].include?(part.type) }

          literal(parts.map(&:text).join)
        end

        # fmt"a {b.c:>3}" is the text "a " and the expression b.c, with its
        # format. `{{` and `}}` are braces in the text. Returns nil if a brace
        # is never closed.
        def format_string(text)
          return nil unless text

          pieces = []
          buffer = +""
          index = 0
          while index < text.length
            if ["{{", "}}"].include?(text[index, 2])
              buffer << text[index]
              index += 2
            elsif text[index] == "{"
              close = closing_brace(text, index) or return nil
              pieces << literal(buffer) unless buffer.empty?
              buffer = +""
              pieces << interpolation(text[(index + 1)...close])
              index = close + 1
            else
              buffer << text[index]
              index += 1
            end
          end
          pieces << literal(buffer) unless buffer.empty?
          build(:format_string, *pieces)
        end

        def closing_brace(text, start)
          depth = 0
          (start...text.length).each do |index|
            depth += 1 if text[index] == "{"
            depth -= 1 if text[index] == "}"
            return index if depth.zero?
          end
          nil
        end

        # The names in `x.y + 1:>3` are names, and the rest is kept as text.
        def interpolation(source)
          expression, format = source.split(/:(?!:)/, 2)
          nodes = expression.scan(/(\.?)([A-Za-z_]\w*)|([^\sA-Za-z_.]+|\.)/).map do |dot, name, other|
            if name
              [dot.empty? ? nil : leaf(:operator, "."), leaf(dot.empty? ? :identifier : :field, name)].compact
            else
              [leaf(:expression_text, other)]
            end
          end
          nodes << [leaf(:format_spec, format)] if format
          build(:interpolation, *nodes.flatten)
        end

        def add_empty_parameters(routine)
          return nil if routine["parameters"] || routine["name"].nil?

          index = routine.children.index { |child| child.field == "name" } + 1
          index += 1 if routine.children[index]&.field == "generic_parameters"
          routine.children.insert(index, build(:parameter_declaration_list).tap { |list| list.field = "parameters" })
          routine
        end

        def split_parameters(list)
          changed = false
          parameters = list.children.flat_map do |parameter|
            names = parameter.type == "parameter_declaration" && parameter.children.first
            next [parameter] unless names&.type == "symbol_declaration_list" && names.children.size > 1

            changed = true
            names.children.map do |name|
              build(:parameter_declaration, build(:symbol_declaration_list, name), *parameter.children.drop(1).map do |child|
                copy(child)
              end)
            end
          end
          list.children = parameters
          changed ? list : nil
        end

        # Sorts the names in an import by their text.
        def sort_imports(statement)
          changed = false
          statement.each_descendant do |node|
            next unless %w[expression_list array_construction].include?(node.type)

            sorted = node.children.sort_by { |child| [text(child).downcase, text(child)] }
            next if sorted.each_with_index.all? { |child, index| child.equal?(node.children[index]) }

            node.children = sorted
            changed = true
          end
          changed ? statement : nil
        end

        def text(node) = node.leaf? ? node.text : node.children.map { |child| text(child) }.join(" ")

        # Gives the names in a declaration (a `symbol_declaration_list`, a
        # symbol or a tuple of them) the type of a name that the student
        # defines. Returns whether anything changed.
        def name_declared(list, type)
          return false unless list

          changed = false
          list.each_descendant do |node|
            next unless node.type == "symbol_declaration"

            name = node["name"]
            changed |= retype_name(name, type)
          end
          changed
        end

        # A routine or type name, which can be exported (`name*`).
        def name_defined(name) = name ? retype_name(name, :definition) : false

        def retype_name(name, type)
          name = name.children.first if name&.type == "exported_symbol"
          return false unless name&.type == "identifier"

          name.type = type.to_s
          true
        end
      end
    end
  end
end
