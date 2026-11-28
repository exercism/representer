# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that PowerShell's own parser gives, where names and
# keywords ignore case and each string is its value.
module Inspector::Languages::Powershell::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Keep `filter`, `until` and `default`, because they
    # change what the code does.
    # function f { return 1 }  ->  (function_definition f (script_block (return_statement 1)))
    strip_tokens "function", "if", "elseif", "else", "foreach", "in", "for", "do", "switch", "return", "break",
                 "continue", "throw", "exit", "try", "catch", "finally", "trap", "param", "class", "enum", "base",
                 "data"
    strip_tokens "while", only_in: :while_statement

    # Strip the brackets, separators and pipes, because they are layout.
    # @{ a = 1; b = 2 }  ->  (hashtable_expression (hash_entry "a" 1) (hash_entry "b" 2))
    # $a | Sort-Object  ->  (pipeline $a sort-object)
    strip_tokens "(", ")", "{", "}", "[", "]", "@{", "@(", "$(", ",", ";", "|", "?", ":"
    strip_tokens "=", only_in: [:hash_entry, :class_property, :parameter, :enum_member, :attribute_argument]

    # Keep the brackets and commas of an array type, and the comma that
    # makes an array of one item.
    # [int[,]]  ->  (type_name int [ , ])
    # ,$x  ->  (unary_expression , $x)
    keep_tokens "[", "]", ",", in: :type_name
    keep_tokens ",", in: :unary_expression

    # Keep the `:` of a parameter's value, because `-Force:$false` turns a
    # switch off, and `-Force $false` passes $false as another argument.
    keep_tokens ":", in: :command_parameter

    # Write each number as its value. PowerShell has no digit separators,
    # and a decimal ending in `d` is a System.Decimal, which keeps its `d`.
    # 1.50  ->  1.5
    # 1e3  ->  1000.0
    # 1.50d  ->  1.5d
    numbers_are integer: :integer_literal,
                decimal: :real_literal,
                prefixes: {},
                suffixes: ["d"],
                separators: []

    # A backtick before any character that isn't a letter or a digit stands
    # for that character.
    # "`$x"  ->  "$x"
    ESCAPES = { "`n" => "\n", "`r" => "\r", "`t" => "\t" }.freeze

    # PowerShell writes out the value of a command or an assignment in
    # brackets, so the brackets around them do more than group.
    STATEMENTS = ["pipeline", "command", "command_expression", "assignment_statement", "pipeline_chain",
                  "background_pipeline"].freeze

    NAMES = ["variable", "splat_expression", "identifier", "type_identifier", "function_name", "command_name",
             "command_parameter_name", "integer_literal", "real_literal"].freeze

    def call
      tree.tap do
        drop_line_continuations!
        drop_empty_parameter_lists!
        write_hex_numbers_as_values!
        write_strings_as_their_values!
        write_bare_words_as_strings!
        write_command_names_as_names!
        write_variables_without_braces!
        write_names_in_lower_case!
        unwrap_pipelines_of_one_expression!
        unwrap_brackets_that_only_group!
      end
    end

    private
    # Drop the backticks that continue a line, because they are layout.
    def drop_line_continuations!
      drop(tree, "(line_continuation)")
    end

    # Drop the empty brackets after a function's name, because PowerShell's
    # parser reads `function f() { }` as `function f { }`.
    def drop_empty_parameter_lists!
      each_node(tree) do |node, _|
        next unless node.type == "function_definition"

        node.children = node.children.reject { |child| child.type == "parameter_list" && child.children.none?(&:named?) }
      end
    end

    # Write each hex number as its value. PowerShell reads a hex number that
    # fits in 32 bits as an int, and one that fits in 64 bits as a long, so
    # a number with its top bit set is negative.
    # 0x7F  ->  127
    # 0xFFFFFFFF  ->  -1
    def write_hex_numbers_as_values!
      captured(tree, "(integer_literal /\\A0[xX]\\h+\\z/) @name").each do |number|
        value = number.text[2..].to_i(16)
        next if value >= 2**64

        bits = value < 2**32 ? 32 : 64
        number.text = (value >= 2**(bits - 1) ? value - 2**bits : value).to_s
      end
    end

    # Write each string as its value, whichever quotes it uses. A string
    # that holds variables or `$(...)` stays an expandable string, with the
    # text between them written as values.
    # 'it''s'  ->  "it's"
    # "say ""hi"""  ->  'say "hi"'
    # @"\nhi $name\n"@  ->  (expandable_string "hi " $name)
    def write_strings_as_their_values!
      transform(tree, "[(single_quoted_string) (single_quoted_here_string)] @string") do |match|
        literal(single_quoted_value(match.node.text))
      end
      transform(tree, "[(expandable_string) (expandable_here_string)] @string") do |match|
        string_node(match.node.children.flat_map { |part| string_pieces(part, match.node.type) })
      end
    end

    # A here-string's value starts on the line after its `@'` and ends at
    # the end of the line before its `'@`.
    def single_quoted_value(text)
      return text[/\A@'[^\n]*\n(.*?)\r?\n?'@\z/m, 1] if text.start_with?("@")

      text[1...-1].gsub("''", "'")
    end

    # Only a string in double quotes reads `""` as one quote.
    def string_pieces(part, type)
      case part.type
      when "\"" then []
      when "string_content" then [type == "expandable_string" ? part.text.gsub('""', '"') : part.text]
      when "escape_sequence" then [escape(part)]
      else [part]
      end
    end

    def escape(sequence)
      return ESCAPES[sequence.text] if ESCAPES.key?(sequence.text)

      sequence.text.match?(/\A`[^[:alnum:]]\z/) ? sequence.text[1] : sequence
    end

    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:expandable_string, *parts)
    end

    # Write each bare word that is a command's argument, and each bare hash
    # key, as a string, because PowerShell reads it as one.
    # Write-Host hello  ->  Write-Host 'hello'
    # @{ a = 1 }  ->  @{ 'a' = 1 }
    def write_bare_words_as_strings!
      words = captured(tree, "(command_argument (bare_word) @name)") + captured(tree, "(hash_entry key: (identifier) @name)")
      words.each do |word|
        word.type = "literal"
        word.quoted = true
      end
    end

    # Write each command's name as one name.
    # Get-Date  ->  (command_name get-date)
    def write_command_names_as_names!
      transform(tree, "(command_name (bare_word) @word)") { |match| leaf(:command_name, match[:word].text) }
    end

    # Write each variable without the braces around its name, because
    # PowerShell reads `${name}` as `$name`.
    # ${count}  ->  $count
    def write_variables_without_braces!
      captured(tree, "(variable /\\A\\$\\{/) @name").each do |variable|
        variable.text = variable.text.sub(/\A\$\{(.*)\}\z/m, '$\1')
      end
    end

    # Write every name and number in lower case, because PowerShell ignores
    # the case of names, and of the letters in numbers. The grammar spells
    # the keywords and operators in lower case already.
    # Write-Host $Total.Length  ->  write-host $total.length
    # 10L  ->  10l
    def write_names_in_lower_case!
      each_node(tree) do |node, _|
        node.text = node.text.downcase if NAMES.include?(node.type) && node.leaf?
      end
    end

    # Unwrap each pipeline that holds one expression, because the pipeline
    # adds nothing to it.
    # $x = $a + 1  ->  (assignment_statement $x = (binary_expression $a + 1))
    def unwrap_pipelines_of_one_expression!
      unwrap(tree, "(command_expression)")
      unwrap(tree, "(pipeline)")
    end

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Brackets around a command or an assignment stay, because
    # `(Get-Date).Year` needs them and `($x = 1)` writes out the 1.
    # ($a + $b) * $c  ->  (binary_expression (binary_expression $a + $b) * $c)
    def unwrap_brackets_that_only_group!
      transform(tree, "(parenthesized_expression) @brackets") do |match|
        inner = match.node.named_children
        inner.first if inner.one? && !STATEMENTS.include?(inner.first.type)
      end
    end
  end
end
