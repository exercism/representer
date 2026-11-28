# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Nim's own parser gives, where operators and commands
# are calls and names ignore case after their first letter.
module Representer::Languages::Nim::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the brackets, commas and other punctuation, because they are
    # layout. Nim's parser reads a command `f x` as the call `f(x)`, so the
    # brackets of arguments go too.
    # echo(1, 2)  ->  echo 1, 2
    strip_tokens "(", ")", ",", ";", "`", "[", "]", "{", "}"

    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # let x = 1  ->  (let_section (variable_declaration x = 1))
    strip_tokens "const", "discard", "distinct", "let", "macro", "proc", "template", "type", "var"

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b)  ->  a + b
    unwrap :parenthesized

    ROUTINES = [:proc_declaration, :func_declaration, :method_declaration, :iterator_declaration,
                :template_declaration, :macro_declaration, :converter_declaration].freeze

    WORD_OPERATORS = ["and", "or", "not", "xor", "in", "notin", "is", "isnot", "of", "div", "mod", "shl", "shr"].freeze

    def call
      tree.tap do
        write_numbers_as_values!
        write_strings_as_their_text!
        write_fmt_strings_the_same_way!
        write_operators_as_calls!
        write_quoted_operators_as_operators!
        add_empty_brackets_to_routines_without_parameters!
        write_names_in_one_spelling!
      end
    end

    private
    ### Values ###

    # Write each number as its value, and keep its type suffix.
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    # 1_000'i64  ->  1000'i64
    def write_numbers_as_values!
      each_node(tree) do |node, _|
        next unless node.leaf?

        node.text = integer(node.text) || node.text if node.type == "integer_literal"
        node.text = float(node.text) || node.text if node.type == "float_literal"
      end
    end

    def integer(text)
      digits, suffix = text.match(/\A(.*?)('?[iIuU](?:8|16|32|64)?)?\z/).captures
      Representer::Engine::Numbers.integer(digits.sub(/\A0[cC]/, "0o"))&.then { |value| "#{value}#{suffix}" }
    end

    def float(text)
      digits, suffix = text.match(/\A(.*?)('?[fFdD](?:32|64|128)?)?\z/).captures
      value = Representer::Engine::Numbers.decimal(digits)
      value && "#{Representer::Engine::Numbers.write_decimal(value)}#{suffix}"
    end

    # Write each string as its text, with its escapes as they are written.
    # "Hello\n"  ->  (literal "Hello\n")
    def write_strings_as_their_text!
      transform(tree, "(interpreted_string_literal) @string") { |match| string_text(match.node.children) }
    end

    # Return the text of a string's parts as a literal, or nil if a part
    # isn't text.
    def string_text(parts)
      contents = parts.reject { |part| part.type == "\"" }
      return nil unless contents.all? { |part| part.type == "string_content" }

      literal(contents.map { |part| text_of(part) }.join)
    end

    # Write `fmt"..."` and `&"..."` as one format string, because Nim's `fmt`
    # and `&` read them the same way. Read the names in the braces as code.
    # fmt"x {a}"  ->  (format_string "x " (interpolation a))
    # &"x {a}"  ->  (format_string "x " (interpolation a))
    def write_fmt_strings_the_same_way!
      transform(tree, '(generalized_string function: (identifier "fmt")) @string') do |match|
        format_string(string_text(match.node.children.drop(1))&.text)
      end
      transform(tree, '(prefix_expression operator: (operator "&") (literal) @string)') do |match|
        format_string(match[:string].text)
      end
    end

    # Split a format string into its text and its interpolations. `{{` and
    # `}}` are braces in the text. Return nil if a brace is never closed.
    # "a {b.c:>3} {{d}}"  ->  "a " (interpolation b . c >3) " {d}"
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

    # Read the names in an interpolation as identifiers, and keep the rest,
    # and the format after the `:`, as text.
    # x.y + 1:>3  ->  (interpolation x . y + 1 >3)
    def interpolation(source)
      expression, format = source.split(/:(?!:)/, 2)
      nodes = expression.scan(/(\.?)([A-Za-z_]\w*)|([^\sA-Za-z_.]+|\.)/).flat_map do |dot, name, other|
        next [leaf(:expression_text, other)] unless name

        [dot.empty? ? nil : leaf(:operator, "."), leaf(:identifier, name)].compact
      end
      nodes << leaf(:format_spec, format) if format
      build(:interpolation, *nodes)
    end

    ### Operators ###

    # Write each operator as a call, as Nim's parser does. Leave `as`, which
    # renames a module or an exception.
    # a + b  ->  `+`(a, b)
    # -x  ->  `-`(x)
    def write_operators_as_calls!
      transform(tree, "(infix_expression left: (_) @left operator: (_) @operator right: (_) @right) @expression") do |match|
        operator_call(match[:operator], match[:left], match[:right]) unless match[:operator].text == "as"
      end
      transform(tree, "(prefix_expression) @expression") do |match|
        children = match.node.children
        operator_call(children.first, children.last) if children.size == 2
      end
    end

    def operator_call(operator, *arguments)
      return nil unless operator.leaf?

      build(:call, { function: build(:accent_quoted, leaf(:operator, operator.text)) }, build(:argument_list, *arguments))
    end

    # Write an operator in backticks as an operator, so it is never renamed.
    # `+`(a, b)  ->  (call (accent_quoted +) (argument_list a b))
    def write_quoted_operators_as_operators!
      transform(tree, "(accent_quoted (identifier) @operator)") do |match|
        text = match[:operator].text
        build(:accent_quoted, leaf(:operator, text)) if operator?(text)
      end
    end

    def operator?(text) = text.match?(/\A[^A-Za-z_]/) || WORD_OPERATORS.include?(text)

    ### Routines and names ###

    # Give a routine without brackets an empty parameter list, because Nim's
    # parser reads the two the same.
    # proc f = discard  ->  proc f() = discard
    def add_empty_brackets_to_routines_without_parameters!
      each_node(tree) do |node, _|
        next unless ROUTINES.include?(node.type.to_sym) && node["name"] && !node["parameters"]

        index = node.children.index { |child| child.field == "name" } + 1
        index += 1 if node.children[index]&.field == "generic_parameters"
        node.children.insert(index, build(:parameter_declaration_list).tap { |list| list.field = "parameters" })
      end
    end

    # Write each name with its first letter as it is, and the rest in lower
    # case without underscores, because Nim reads all these spellings as one
    # name. Keep the case of the first letter, which Nim reads.
    # helloWorld  ->  helloworld
    # hello_World  ->  helloworld
    # HelloWorld  ->  Helloworld
    def write_names_in_one_spelling!
      each_node(tree) do |node, _|
        node.text = node.text[0] + node.text[1..].delete("_").downcase if node.type == "identifier" && node.leaf?
      end
    end
  end
end
