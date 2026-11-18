module Representer
  module Languages
    # The old gdscript-representer parsed the code with gdtoolkit, dropped
    # docstrings and comments, and renamed the functions and the variables
    # and parameters inside functions. It left script-level variables,
    # constants, classes, enums and signals as they were. This class renames
    # those too, because the student chooses all of those names.
    class GDScript < Language
      tracks "gdscript"
      version 2
      grammar "gdscript"
      extensions ".gd"

      # A string and a node path (`$Node/Child`) hold their text in tokens that
      # the tree doesn't show, so each is kept as a leaf with its whole text.
      text_nodes :string, :string_name, :node_path, :get_node

      # `name` is a name given to a function, variable, constant, class, enum
      # or signal. `local` is a parameter or a loop variable. `member_name` is
      # a name after a dot. Every other name is an `identifier`.
      names :identifier, :name, :local, :member_name

      ### Drop ###

      # Comments, #region markers, line continuations (a backslash at the end
      # of a line), and docstrings: a string on its own is never run.
      drop "[(comment) (region_start) (region_end) (line_continuation)]"
      drop "(expression_statement (string))", where: ->(match) { match.node.children.size == 1 }

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "[", "]", "{", "}", ",", ";"

      ### Rewrite ###

      # (a + b) is a + b: the tree's shape already shows the grouping.
      unwrap :parenthesized_expression

      # `&&` is `and`, `||` is `or`, and `!` is `not`.
      rewrite('(binary_operator "&&") @operator') { |match| GDScript.respell(match.node, "&&", "and") }
      rewrite('(binary_operator "||") @operator') { |match| GDScript.respell(match.node, "||", "or") }
      rewrite('(unary_operator "!") @operator') { |match| GDScript.respell(match.node, "!", "not") }

      # 1_000 is 1000.
      rewrite "[(integer /_/) @number (float /_/) @number]" do |match|
        leaf(match[:number].type, match[:number].text.delete("_"))
      end

      # 'a' and "a" are the same string.
      rewrite("(string) @string") { |match| GDScript.string_value(match[:string].text) }

      # The names that functions and loops define for their parameters and
      # variables.
      rewrite("(parameters) @parameters") { |match| GDScript.name_parameters(match.node) ? match.node : nil }
      rewrite("(for_statement) @loop") { |match| GDScript.retype(match.node["left"], :local) ? match.node : nil }
      rewrite("(enumerator) @enumerator") { |match| GDScript.retype(match.node["left"], :name) ? match.node : nil }

      # The names after a dot: obj.name, obj.method().
      rewrite("(attribute) @attribute") { |match| GDScript.name_members(match.node) ? match.node : nil }

      ### Rename and keep ###

      rename "(local) @name"
      rename_member "(name) @name"
      member "(member_name) @name"

      keep "self", "super", "_"
      library_names File.join(__dir__, "library_names", "gdscript.txt")

      class << self
        # Replaces the operator token `from` with `to`.
        def respell(node, from, to)
          token = node.children.find { |child| child.type == from && !child.named? }
          return nil unless token

          node.replace_child(token, self.token(to))
          node
        end

        # A string in its own quotes is its value. Triple-quoted strings keep
        # their structure, and so does any string that isn't plain quotes.
        def string_value(text)
          quote = text[0]
          return nil unless %w[" '].include?(quote) && text.length >= 2 && text.end_with?(quote)
          return build(:multiline_string, literal(text[3...-3])) if text.start_with?(quote * 3) && text.length >= 6

          literal(text[1...-1].gsub(/\\(.)/m) { Regexp.last_match(1) == quote ? quote : Regexp.last_match(0) })
        end

        # Parameters are plain names, `a: int`, `a = 1`, or `a := 1`: the
        # name is the first child.
        def name_parameters(parameters)
          changed = false
          parameters.children.each do |parameter|
            name = parameter.type == "identifier" ? parameter : parameter.children.first
            changed |= retype(name, :local)
          end
          changed
        end

        # After the first name, the names in `a.b.c(d)`, and the name of a
        # call, are names that belong to another object.
        def name_members(attribute)
          changed = false
          attribute.children.drop(1).each do |child|
            name = child.type == "attribute_call" ? child.children.first : child
            changed |= retype(name, :member_name)
          end
          changed
        end

        def retype(node, type)
          return false unless node&.type == "identifier"

          node.type = type.to_s
          true
        end
      end
    end
  end
end
