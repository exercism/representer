module Representer
  module Languages
    # Follows the old exercism/java-representer, which renamed types, methods,
    # fields, record components and variables in Spoon's model, and printed
    # the model back as formatted code without comments, imports and the
    # package.
    class Java < Language
      tracks "java"
      version 3
      grammar "java"
      extensions ".java"

      # Type names (`List`) are type_identifiers. Everything else is an identifier.
      names :identifier, :type_identifier

      ESCAPES = {
        "n" => "\n", "t" => "\t", "r" => "\r", "b" => "\b", "f" => "\f", "s" => " ", "\\" => "\\", "'" => "'", "\"" => "\""
      }.freeze

      ### Drop ###

      drop "[(line_comment) (block_comment) (package_declaration) (import_declaration)]"

      # The `;` after the constants of an enum with nothing after it.
      drop "(enum_body_declarations)", where: ->(match) { match.node.children.empty? }

      # The node types already say what these tokens say. String quotes go
      # too, because a string's value doesn't depend on how it is written.
      drop_tokens "(", ")", "{", "}", "[", "]", ";", ",", "\"", "if", "else", "for", "while", "do", "return", "new"

      ### Rewrite ###

      # (a + b) is a + b: the tree's shape already shows the grouping.
      unwrap :parenthesized_expression

      # `(x) -> x` is `x -> x`.
      rewrite "(lambda_expression parameters: (inferred_parameters (identifier) @parameter) @parameters)",
        where: ->(match) { match[:parameters].children.size == 1 } do |match|
        match.node.replace_child(match[:parameters], match[:parameter])
        match[:parameter].field = "parameters"
        match.node
      end

      # `else { if (a) b(); }` is `else if (a) b();`.
      rewrite "(if_statement alternative: (block (if_statement) @inner) @block)",
        where: ->(match) { match[:block].children.size == 1 } do |match|
        match.node.replace_child(match[:block], match[:inner])
        match.node
      end

      # `if (a) b();` is `if (a) { b(); }`. The `else if` chain stays as it is.
      { "if_statement" => %w[consequence alternative], "for_statement" => %w[body], "enhanced_for_statement" => %w[body],
        "while_statement" => %w[body], "do_statement" => %w[body] }.each do |type, fields|
        fields.each do |field|
          # A block needs no braces, and neither does the `if` of an `else if`.
          needs_braces = lambda do |match|
            kind = match[:body].type
            kind != "block" && (kind != "if_statement" || field != "alternative")
          end
          rewrite "(#{type} #{field}: (_) @body)", where: needs_braces do |match|
            match.node.replace_child(match[:body], build(:block, match[:body]))
            match.node
          end
        end
      end

      # `int a, b;` is `int a; int b;`.
      rewrite "[(block) (class_body) (constructor_body) (enum_body_declarations) (switch_block_statement_group)] @body" do |match|
        Java.split_declarations(match.node)
      end

      # `java.util.List` is `List` (the old representer imported everything).
      rewrite "(scoped_type_identifier) @type" do |match|
        Java.package_qualified?(match.node) ? match.node.children.last : nil
      end
      rewrite "(field_access) @access" do |match|
        Java.package_qualified?(match.node) ? leaf(:identifier, match.node["field"].text) : nil
      end

      # Numbers are their values: 1_000 is 1000, and 0x10 is 16.
      rewrite "[(decimal_integer_literal) (hex_integer_literal) (octal_integer_literal) (binary_integer_literal)] @number" do |match|
        value = Java.integer_value(match.node.text)
        value == match.node.text ? nil : leaf(:decimal_integer_literal, value)
      end
      rewrite "(decimal_floating_point_literal) @number" do |match|
        value = Java.float_value(match.node.text)
        value == match.node.text ? nil : leaf(:decimal_floating_point_literal, value)
      end

      # A string is its value, so "A" is "A".
      rewrite "(string_literal) @string" do |match|
        Java.string_value(match.node)
      end

      ### Rename and keep ###

      # Local variables, parameters, labels and type parameters.
      rename "(local_variable_declaration (variable_declarator name: (identifier) @name)*)"
      rename "[(formal_parameter name: (identifier) @name) (catch_formal_parameter name: (identifier) @name)]"
      rename "[(enhanced_for_statement name: (identifier) @name) (resource name: (identifier) @name)]"
      rename "[(spread_parameter (variable_declarator name: (identifier) @name)) (instanceof_expression name: (identifier) @name)]"
      rename "[(lambda_expression parameters: (identifier) @name) (inferred_parameters (identifier)* @name)]"
      rename "[(labeled_statement (identifier) @name) (type_parameter (type_identifier) @name)]"

      # Types, methods, fields, constants and record components.
      rename_member "[(class_declaration name: (identifier) @name) (interface_declaration name: (identifier) @name)]"
      rename_member "[(enum_declaration name: (identifier) @name) (record_declaration name: (identifier) @name)]"
      rename_member "[(method_declaration name: (identifier) @name) (enum_constant name: (identifier) @name)]"
      rename_member "(field_declaration (variable_declarator name: (identifier) @name)*)"
      rename_member "(record_declaration parameters: (formal_parameters (formal_parameter name: (identifier) @name)*))"

      # Names after a dot, and the names of annotations, refer to some
      # object's member.
      member "[(field_access field: (identifier) @name) (method_invocation object: (_) name: (identifier) @name)]"
      member "[(method_reference (_) (identifier) @name) (annotation name: (identifier) @name)]"
      member "[(marker_annotation name: (identifier) @name) (element_value_pair key: (identifier) @name)]"

      # Methods that Java itself calls.
      keep "main", "toString", "equals", "hashCode", "compareTo", "compare", "iterator", "hasNext", "next", "run", "call",
        "close", "clone", "finalize", "get", "apply", "accept", "test", "values", "valueOf", "length"

      library_names File.join(__dir__, "library_names", "java.txt")

      class << self
        # Splits every declaration of several variables into one declaration
        # for each, in the children of a block or class body.
        def split_declarations(node)
          split = node.children.flat_map { |child| split_declaration(child) }
          return nil if split.size == node.children.size

          node.children.replace(split)
          node
        end

        def split_declaration(declaration)
          return [declaration] unless %w[local_variable_declaration field_declaration].include?(declaration.type)

          declarators = declaration.children.select { |child| child.type == "variable_declarator" }
          return [declaration] if declarators.size < 2

          declarators.map do |declarator|
            copied = copy(declaration)
            copied.children.reject! { |child| child.type == "variable_declarator" }
            copied.children << copy(declarator).tap { |own| own.field = "declarator" }
            copied
          end
        end

        # Whether this is `java.util.List` or `java.lang.Math`: names that
        # start with a lower case letter and then a class name.
        def package_qualified?(node)
          parts = qualified_parts(node)
          return false unless parts && parts.size > 2

          %w[java javax].include?(parts.first) && parts[0...-1].all? { |part| part.match?(/\A[a-z]/) } && parts.last.match?(/\A[A-Z]/)
        end

        def qualified_parts(node)
          case node.type
          when "identifier", "type_identifier" then [node.text]
          when "field_access" then qualified_parts(node["object"]).then { |parts| parts && parts + [node["field"].text] }
          when "scoped_type_identifier"
            parts = node.named_children.flat_map { |child| qualified_parts(child) || [nil] }
            parts.include?(nil) ? nil : parts
          end
        end

        def integer_value(text)
          digits = text.delete("_")
          suffix = digits.match?(/[lL]\z/) ? "L" : ""
          digits = digits.delete_suffix("l").delete_suffix("L").downcase
          value =
            case digits
            when /\A0x[0-9a-f]+\z/, /\A0b[01]+\z/ then Integer(digits, exception: false)
            when /\A0[0-7]+\z/ then Integer(digits, 8, exception: false)
            when /\A(0|[1-9]\d*)\z/ then Integer(digits, 10, exception: false)
            end
          value ? "#{value}#{suffix}" : text
        end

        def float_value(text)
          digits = text.delete("_")
          suffix = digits[/[fFdD]\z/]&.downcase || ""
          number = Float(digits.delete_suffix(suffix).delete_suffix(suffix.upcase), exception: false)
          number&.finite? ? "#{number}#{suffix}" : text
        end

        def string_value(node)
          parts = node.children.select { |child| %w[string_fragment escape_sequence].include?(child.type) }
          return nil unless parts.size == node.children.size

          literal(parts.map { |part| part.type == "escape_sequence" ? decode(part.text) : part.text }.join)
        end

        # Decodes an escape. One not listed here keeps its source text, so two
        # different strings can never get the same value.
        def decode(escape)
          code = escape[1..]
          case code
          when /\Au+([0-9a-fA-F]{4})\z/
            value = Regexp.last_match(1).to_i(16)
            value.between?(0xD800, 0xDFFF) ? escape : [value].pack("U")
          when /\A([0-3]?[0-7]{1,2})\z/ then Regexp.last_match(1).to_i(8).chr(Encoding::UTF_8)
          else ESCAPES.fetch(code, escape)
          end
        end
      end
    end
  end
end
