# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Dart's own parser (the analyzer's unresolved AST)
# gives.
module Representer::Languages::Dart::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if (x) { return y; }  ->  (if_statement x (block (return_statement y)))
    strip_tokens "if", "else", "for", "in", "while", "do", "return", "switch", "case", "default", "try", "catch",
                 "finally", "on", "throw", "continue", "yield", "class", "enum", "extension", "mixin", "typedef",
                 "import", "export", "library", "part", "part of", "with", "implements", "extends", "new", "factory",
                 "this", "super", "var", "final", "true", "false", "null", "@"

    # Strip these keywords only from the nodes listed, because elsewhere the
    # grammar can read them as names.
    # int get count => 1;  ->  (getter_signature int count)
    strip_tokens "get", only_in: :getter_signature
    strip_tokens "set", only_in: :setter_signature
    strip_tokens "operator", only_in: :operator_signature
    strip_tokens "Function", only_in: :function_type
    strip_tokens "await", only_in: :await_expression

    # Strip the brackets, commas, arrows and other punctuation, because they
    # are layout.
    # f(a, b);  ->  (identifier f) (selector (argument_part (arguments a b)))
    # int f() => 1;  ->  (function_signature int f (formal_parameter_list)) (function_body 1)
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", ".", ":", "=", "=>", "..."

    # Strip the angle brackets of type arguments and the `?` of a conditional
    # only there, because elsewhere they are operators.
    # List<int>  ->  (type_identifier List) (type_arguments int)
    strip_tokens "<", ">", only_in: [:type_arguments, :type_parameters]
    strip_tokens "?", only_in: :conditional_expression

    # Strip the `$` of an interpolation, as the line above strips its braces,
    # because `$x` and `${x}` are the same to the parser.
    # '$x'  ->  '${x}'
    strip_tokens "$", only_in: :template_substitution

    # Keep these tokens in the nodes listed, because they are the only thing
    # that tells two programs apart there.
    # x = 1 and x += 1
    # f({int a}) and f([int a])
    # for (;; i++) and for (i++;;)
    keep_tokens "=", in: [:assignment_expression, :assignment_expression_without_cascade, :cascade_section]
    keep_tokens "[", "]", "{", "}", in: [:optional_formal_parameters, :record_type]
    keep_tokens ";", in: :for_loop_parts

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (multiplicative_expression (additive_expression a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value. Dart reads an integer with a leading
    # zero as a decimal integer, and a number with a point or an exponent as
    # a double.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 010  ->  10
    # 1.50  ->  1.5
    # 1e3  ->  1000.0
    numbers_are integer: [:decimal_integer_literal, :hex_integer_literal],
                decimal: :decimal_floating_point_literal,
                prefixes: { "0x" => 16 }

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\\\\' => "\\",
      "\\'" => "'",
      '\"' => '"',
      '\$' => "$"
    }.freeze

    def call
      tree.tap do
        unwrap_imports_and_exports!
        write_names_spelled_like_keywords_as_leaves!
        write_strings_as_their_values!
        write_interpolated_names_as_names!
        mark_the_variables_that_patterns_declare!
        give_each_defined_name_its_field!
      end
    end

    private
    # Unwrap the nodes that only hold an import or an export, as the parser
    # gives the directive itself.
    # import 'dart:math';  ->  (import_specification (configurable_uri (uri "dart:math")))
    def unwrap_imports_and_exports!
      unwrap(tree, "[(import_or_export) (library_import)]")
    end

    ### Names ###

    # Write a name such as `set` or `get` as a leaf, because the grammar
    # gives it as an identifier that holds a keyword token.
    # var set = {1};  ->  (identifier set)
    def write_names_spelled_like_keywords_as_leaves!
      transform(tree, "(identifier) @name") do |match|
        children = match.node.children
        next nil unless children.one? && !children.first.named?

        leaf(:identifier, children.first.text)
      end
    end

    # Write a name in an interpolation as a name, so it is renamed with the
    # variable it reads.
    # '$total'  ->  '${total}'
    def write_interpolated_names_as_names!
      retype(tree, identifier_dollar_escaped: :identifier)
    end

    # Mark each name in a declared pattern as a variable, as the parser does.
    # The grammar reads the names in `var (a, b) = pair;` and
    # `for (final (a, b) in pairs)` as constants.
    # var (a, b) = pair;  ->  (pattern_variable_declaration (record_pattern (variable_pattern a) (variable_pattern b)) pair)
    def mark_the_variables_that_patterns_declare!
      find_all(tree, "[(pattern_variable_declaration) (for_loop_parts)]").each do |match|
        match.node.children.select { |child| child.type.end_with?("_pattern") }.each do |pattern|
          each_node(pattern) { |node, _| node.type = "variable_pattern" if bare_name?(node) }
        end
      end
    end

    def bare_name?(node)
      node.type == "constant_pattern" && node.children.one? && node.children.first.type == "identifier"
    end

    # Give the name in each of these declarations the field `name`, as the
    # parser does, so that representation/spec.rb can tell it from the types and
    # values beside it.
    # int total = sum;  ->  (initialized_identifier name: total sum)
    # (int y) => y  ->  (formal_parameter int name: y)
    # ({int moves}) f()  ->  (record_type_named_field (typed_identifier int name: moves))
    # case int z:  ->  (variable_pattern int name: z)
    def give_each_defined_name_its_field!
      each_node(tree) do |node, _|
        next if node.children.any? { |child| child.field == "name" }

        name = defined_name(node)
        name.field = "name" if name
      end
    end

    # Return the child that holds the name that the node declares, if the
    # grammar gives it no field.
    def defined_name(node)
      case node.type
      when "initialized_identifier", "static_final_declaration"
        node.children.first if node.children.first&.type == "identifier"
      when "formal_parameter", "typed_identifier", "variable_pattern", "mixin_declaration"
        node.children.find { |child| child.type == "identifier" }
      when "type_alias"
        node.named_children.first if node.children.any? { |child| child.type == "=" }
      end
    end

    ### Strings ###

    # Turn each string into its value, however it is quoted, and read its
    # escapes. Keep any other escape as a node of its own, so it can't make
    # two different strings the same. An interpolation keeps its code, with
    # the text around it as values. Adjacent strings stay apart, as the
    # parser keeps them.
    #
    # 'a'  ->  "a"
    # r'a\n'  ->  "a\\n"
    # '''a'''  ->  "a"
    # 'a $n'  ->  (string_literal "a " (template_substitution n))
    # 'a' 'b'  ->  (adjacent_strings "a" "b")
    def write_strings_as_their_values!
      transform(tree, "(string_literal) @string") do |match|
        values = quoted_strings(match.node.children).map { |opener, parts| string_value(opener, parts) }
        values.one? ? values.first : build(:adjacent_strings, *values)
      end
    end

    # Split a string node's children into its quoted strings, each with its
    # opening quote. The grammar gives adjacent strings as one node, and a
    # quote inside a string as a token.
    def quoted_strings(children)
      strings = []
      children.each do |child|
        string = strings.last
        if string && !string[:closed]
          child.type == string[:closer] && !child.named? ? string[:closed] = true : string[:parts] << child
        elsif !child.named?
          strings << { opener: child.type, closer: child.type.delete_prefix("r"), parts: [], closed: false }
        end
      end
      strings.map { |string| [string[:opener], string[:parts]] }
    end

    # Return the value of one quoted string. A raw string's text is its value.
    # A triple-quoted string leaves out its first line if that line is blank,
    # as Dart does.
    def string_value(opener, parts)
      pieces = parts.map do |part|
        if opener.start_with?("r") || !part.named? || part.type == "fragment" then part.text
        elsif part.type == "escape_sequence" then ESCAPES.fetch(part.text) { escape(part) }
        else part
        end
      end
      pieces[0] = pieces[0].sub(/\A[ \t]*\n/, "") if opener.delete_prefix("r").size == 3 && parts.first&.type == "fragment"
      string_node(pieces)
    end

    # Return the text that a hexadecimal or Unicode escape stands for, or the
    # escape's node if it stands for no single character, such as half of a
    # surrogate pair.
    def escape(node)
      match = node.text.match(/\A\\(?:x(\h{2})|u(\h{4})|u\{(\h{1,6})\})\z/)
      return node unless match

      value = match.captures.compact.first.to_i(16)
      value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? node : [value].pack("U")
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and other nodes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string_literal, *parts)
    end
  end
end
