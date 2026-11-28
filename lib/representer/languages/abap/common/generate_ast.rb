# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that the ABAP compiler's parser gives, where names and
# keywords ignore case and each chained statement is a statement of its own.
module Representer::Languages::Abap::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the full stops, colons, commas and brackets, because they are
    # layout. A chained statement is split into its statements first.
    # f( a ).  ->  (function_call f (call_argument_list (positional_argument a)))
    strip_tokens ".", ":", ",", "(", ")", "[", "]", "{", "}"

    # Strip the `!` that escapes a parameter's name, because ABAP reads
    # `!year` as `year`.
    # IMPORTING !year TYPE i  ->  (parameter (implicit_reference year) ...)
    strip_tokens "!", only_in: :implicit_reference

    # Strip the `EXPORTING` of a method call, because the field already shows
    # which parameters are exported, and ABAP reads the call the same without it.
    # f( EXPORTING a = 1 )  ->  f( a = 1 )
    strip_tokens "exporting", only_in: :call_argument_list

    # Strip the keywords that always sit in a fixed place, because the node
    # types already show them.
    # METHOD leap. ... ENDMETHOD.  ->  (method_implementation leap ...)
    strip_tokens "add", "adjacent", "append", "ascending", "assign", "assigning", "at", "binary", "blanks", "by",
                 "case", "check", "class", "class-data", "class-methods", "comparing", "concatenate", "cond",
                 "condense", "constants", "constructor", "continue", "conv", "create", "decimals", "definition",
                 "delete", "descending", "describe", "do", "duplicates", "else", "elseif", "empty", "endcase",
                 "endclass", "enddo", "endif", "endloop", "endmethod", "endwhile", "exception", "exit", "fields",
                 "find", "first", "group", "if", "implementation", "init", "insert", "length", "let", "lines",
                 "loop", "lower", "match", "method", "methods", "new", "next", "no", "no-gaps", "non-unique",
                 "occurrence", "occurrences", "offset", "optional", "others", "pcre", "places", "raise", "read",
                 "reduce", "ref", "reference", "regex", "respecting", "return", "search", "separated", "shift",
                 "size", "sort", "sorted", "split", "stable", "submatches", "switch", "then", "throw", "times",
                 "translate", "transporting", "types", "unique", "until", "upper", "value", "when", "while", "write"

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # ( a + b ) * c  ->  (arithmetic_expression (arithmetic_expression a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value.
    # 007  ->  7
    numbers_are integer: :number,
                prefixes: {},
                separators: []

    COMPARISON_KEYWORDS = {
      "eq" => "=",
      "ne" => "<>",
      "lt" => "<",
      "gt" => ">",
      "le" => "<=",
      "ge" => ">="
    }.freeze

    TEMPLATE_ESCAPES = {
      '\n' => "\n",
      '\r' => "\r",
      '\t' => "\t",
      '\\\\' => "\\",
      '\|' => "|",
      '\{' => "{",
      '\}' => "}"
    }.freeze

    def call
      tree.tap do
        split_chained_statements!
        write_strings_as_their_values!
        write_string_templates_as_their_parts!
        write_field_symbols_as_names!
        write_names_in_lower_case!
        write_comparison_keywords_as_symbols!
      end
    end

    private
    # Split each chained statement into one statement for each part after
    # the colon, because ABAP's parser reads the chain as those statements.
    # e.g. We convert:
    #   DATA: a TYPE i, b TYPE string.
    # internally into:
    #   DATA a TYPE i. DATA b TYPE string.
    def split_chained_statements!
      each_node(tree) do |node, _|
        next if node.leaf?

        node.children = node.children.flat_map { |child| chain_parts(child) }
      end
    end

    def chain_parts(statement)
      return [statement] if statement.leaf?

      colon = statement.children.index { |child| !child.named? && child.type == ":" }
      return [statement] unless colon

      head = statement.children[0...colon]
      parts = statement.children[(colon + 1)..].slice_when { |child, _| child.type == "," }
      parts.map { |part| copy(statement).tap { |split| split.children = head.map { copy(_1) } + part } }
    end

    # Write each text literal and string literal as its value, and keep
    # them apart, because ABAP gives them different types.
    # 'abc'  ->  (text_literal "abc")
    # `abc`  ->  "abc"
    def write_strings_as_their_values!
      transform(tree, "(string_literal) @string") do |match|
        text = match.node.text
        value = literal(text[1...-1])
        text.start_with?("'") ? build(:text_literal, value) : value
      end
    end

    # Write the text of each string template as values between its embedded
    # expressions, and read its escapes. Keep any other escape as a node of
    # its own, so it can't make two different templates the same. The first
    # piece of text starts with the template's opening `|`.
    # |Hi { name }\n|  ->  (string_template "Hi " (embedded_expression name) "\n")
    def write_string_templates_as_their_parts!
      each_node(tree) do |node, _|
        next unless node.type == "string_template"

        node.children = node.children.each_with_object([]) do |child, parts|
          part = template_part(child)
          next if part.nil?

          part.quoted && parts.last&.quoted ? parts[-1] = literal(parts.last.text + part.text) : parts << part
        end
      end
    end

    def template_part(child)
      case child.type
      when "fragment" then (text = child.text.delete_prefix("|")).empty? ? nil : literal(text)
      when "\\" then TEMPLATE_ESCAPES.key?(child.text) ? literal(TEMPLATE_ESCAPES[child.text]) : child
      when "|" then nil
      else child
      end
    end

    # Write each field symbol as one name with its angle brackets, so
    # `<line>` and a variable called `line` stay apart.
    # <line>  ->  (field_symbol "<line>")
    def write_field_symbols_as_names!
      transform(tree, "(field_symbol) @symbol") do |match|
        leaf(:field_symbol, text_of(match.node))
      end
    end

    # Write every name in lower case, because ABAP ignores the case of names.
    # The grammar spells the keywords in lower case already.
    # Result = Year MOD 4.  ->  result = year MOD 4.
    def write_names_in_lower_case!
      each_node(tree) do |node, _|
        node.text = node.text.downcase if node.named? && node.leaf? && !node.quoted
      end
    end

    # Write each comparison keyword as its symbol, because ABAP reads the two
    # spellings as the same operator.
    # a EQ b  ->  a = b
    # a GE b  ->  a >= b
    def write_comparison_keywords_as_symbols!
      each_node(tree) do |node, _|
        next unless node.type == "comparison_expression"

        node.children.each do |child|
          symbol = COMPARISON_KEYWORDS[child.type] unless child.named?
          child.type = child.text = symbol if symbol
        end
      end
    end
  end
end
