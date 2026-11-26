# What this class does to a C# solution's code to make its representation:
#
# - Drops comments, `using` directives and `readonly`.
# - Drops punctuation and keywords that the tree already shows, except where
#   they tell two programs apart.
# - Drops brackets that only group, `System.` before a name, and `()` in
#   `new Foo() { ... }`.
# - Writes .NET type names as their keywords (`String` is `string`).
# - Writes `x != y ? a : b` as `x == y ? b : a`, and `x == true` as `x`.
# - Adds braces to the branches of an `if`.
# - Drops `this.` and the class's own name before one of the class's
#   members, unless a parameter or local variable has the same name.
# - Writes numbers as their values (`1_000` is `1000`, `0x1F` is `31`,
#   `1.50` is `1.5`), and keeps a decimal's digits and an integer's suffix.
# - Writes a dictionary's `[k] = v` entries as `{ k, v }`, and a string as
#   its value.
# - Replaces each name that the solution defines with a placeholder
#   (PLACEHOLDER_1, PLACEHOLDER_2 and so on).
# - Keeps every name used in the tests, the members of the exercise's stub,
#   and the language's library names.
# - Also keeps the methods that .NET itself calls (`Main`, `ToString`,
#   `Equals` and so on).
# - Ignores files with other extensions, and test and config files.
# - Joins the files into one tree, in an order set by their code. File names
#   never appear.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    # Every rewriter from exercism/csharp-representer is a rule here. Each
    # rule's comment names the rewriter it replaces.
    class CSharp < Language
      tracks "csharp"
      version 8
      grammar "c_sharp"
      extensions ".cs"

      names :identifier, :implicit_parameter

      # The keyword that each .NET type name stands for.
      TYPE_KEYWORDS = {
        "String" => "string", "Boolean" => "bool", "Char" => "char", "Byte" => "byte", "SByte" => "sbyte",
        "Int16" => "short", "UInt16" => "ushort", "Int32" => "int", "UInt32" => "uint", "Int64" => "long",
        "UInt64" => "ulong", "Single" => "float", "Double" => "double", "Decimal" => "decimal", "Object" => "object"
      }.freeze

      ### Drop ###

      # RemoveComments
      drop "(comment)"

      # RemoveUsingDirectives
      drop "(using_directive)"

      # RemoveReadOnly
      drop '(modifier "readonly")'
      drop '"readonly"'

      # NormalizeWhiteSpace: the node types already say what these tokens say.
      drop_tokens "(", ")", "{", "}", "[", "]", ";", ",", ".", ":", "?", "=>", "\"",
        "new", "return", "if", "else", "class", "struct", "interface", "record", "enum", "namespace",
        "var", "for", "foreach", "while", "do", "switch", "break", "continue", "throw", "try", "catch",
        "finally", "lock", "typeof", "sizeof", "yield", "goto"

      # In these nodes, a dropped token is the only thing that tells two
      # programs apart: `record struct` and `record class`, `where T : class`
      # and `where T : struct?`, `int[,]` and `int[]`, `new[,]` and `new[]`,
      # `Dictionary<,>` and `List<>`, and `for (;; i++)` and `for (i++;;)`.
      # `using` and `await` are never dropped, as `using var x` and
      # `await foreach` differ from `var x` and `foreach` only by them.
      keep_tokens_in :record_declaration, "class", "struct"
      keep_tokens_in :type_parameter_constraint, "class", "struct", "?"
      keep_tokens_in :array_rank_specifier, ","
      keep_tokens_in :implicit_array_creation_expression, ","
      keep_tokens_in :type_argument_list, ","
      keep_tokens_in :for_statement, ";"

      ### Rewrite ###

      # RemoveOptionalParentheses. Upstream only removes brackets around a
      # ternary's parts, but every grouping bracket is safe to remove: the
      # tree's shape already shows what it groups.
      unwrap :parenthesized_expression

      # SimplifyFullyQualifiedName: System.X is X.
      rewrite '(member_access_expression expression: (identifier "System") name: (_) @name)', "@name"
      rewrite '(qualified_name qualifier: (identifier "System") name: (_) @name)', "@name"

      # SimplifyBuiltInKeyword: String is string. Upstream only does this
      # for String, but every type keyword names exactly one .NET type.
      # A name after a dot (field "name") is left alone.
      rewrite "(_ (identifier)* @identifiers)" do |match|
        changed = false
        match[:identifiers].each do |identifier|
          keyword = TYPE_KEYWORDS[identifier.text]
          next unless keyword && identifier.field != "name"

          match.node.replace_child(identifier, leaf(:predefined_type, keyword))
          changed = true
        end
        changed ? match.node : nil
      end

      # InvertNegativeConditionals: `x != y ? a : b` is `x == y ? b : a`,
      # and `!x ? a : b` is `x ? b : a`.
      rewrite <<~PATTERN, <<~TEMPLATE
        (conditional_expression
          condition: (binary_expression left: (_) @left operator: "!=" right: (_) @right)
          consequence: (_) @yes
          alternative: (_) @no)
      PATTERN
        (conditional_expression
          condition: (binary_expression left: @left operator: "==" right: @right)
          consequence: @no
          alternative: @yes)
      TEMPLATE
      rewrite <<~PATTERN, "(conditional_expression condition: @condition consequence: @no alternative: @yes)"
        (conditional_expression
          condition: (prefix_unary_expression "!" (_) @condition)
          consequence: (_) @yes
          alternative: (_) @no)
      PATTERN

      # AddBracesToIfAndElseStatements: `if (x) y;` is `if (x) { y; }`. As
      # upstream, this also turns `else if` into `else { if ... }`.
      rewrite "(if_statement consequence: (_) @body)", where: ->(match) { match[:body].type != "block" } do |match|
        match.node.replace_child(match[:body], build(:block, match[:body]))
        match.node
      end
      rewrite "(if_statement alternative: (_) @body)", where: ->(match) { match[:body].type != "block" } do |match|
        match.node.replace_child(match[:body], build(:block, match[:body]))
        match.node
      end

      # Inside a class, `this.Name` and `ClassName.Name` are `Name`, when
      # Name is one of the class's members and no parameter or local
      # variable has the same name.
      rewrite "[(class_declaration) (struct_declaration) (record_declaration)] @type" do |match|
        CSharp.drop_own_qualifiers(match.node) ? match.node : nil
      end

      # Numbers are their values: `1_000` is `1000`, `0x1F` is `31`, and
      # `1.50` is `1.5`. A decimal (`1.50m`) keeps its digits, as .NET keeps
      # a decimal's scale, and an integer with a suffix keeps its text.
      numbers(:integer_literal) { |text| Engine::Numbers.integer(text)&.to_s }
      numbers :real_literal do |text|
        digits, suffix = text.match(/\A(.*?)([fFdD])?\z/).captures
        value = Engine::Numbers.decimal(digits)
        value && "#{Engine::Numbers.write_decimal(value)}#{suffix&.downcase}"
      end

      # LowerCaseToUpperCaseExponentNotation: 1e7 is 1E7.
      rewrite "(real_literal /e/) @number" do |match|
        leaf(:real_literal, match[:number].text.tr("e", "E"))
      end

      # SimplifyBooleanEquality: `x == true` is `x`, and `x == false` is `!x`.
      # Upstream does this for any operator, which turns `x != true` into
      # `x`. This only does it for == and !=, and gets != right.
      { "==" => %w[true false], "!=" => %w[false true] }.each do |operator, (same, negated)|
        %w[left right].each do |side|
          other = side == "left" ? "right" : "left"
          rewrite "(binary_expression #{side}: (boolean_literal \"#{same}\") operator: \"#{operator}\" #{other}: (_) @value)", "@value"
          rewrite "(binary_expression #{side}: (boolean_literal \"#{negated}\") operator: \"#{operator}\" #{other}: (_) @value)",
            '(prefix_unary_expression "!" @value)'
        end
      end

      # NormalizeDictionaryInitialization: `new Dictionary<K, V> { [k] = v }`
      # is `new Dictionary<K, V> { { k, v } }`.
      rewrite <<~PATTERN do |match|
        (object_creation_expression
          type: (generic_name (identifier "Dictionary"))
          initializer: (initializer_expression) @initializer)
      PATTERN
        entries = match[:initializer].children.select do |child|
          child.type == "assignment_expression" && child[:left]&.type == "element_binding_expression"
        end
        next nil if entries.empty?

        entries.each do |entry|
          key = entry[:left].named_children.first.named_children.first
          value = entry[:right]
          value.field = nil
          match[:initializer].replace_child(entry, build(:initializer_expression, key, value))
        end
        match.node
      end

      # `new Foo() { ... }` is `new Foo { ... }`.
      rewrite "(object_creation_expression arguments: (argument_list) @arguments initializer: (_))",
        where: ->(match) { match[:arguments].children.empty? } do |match|
        match.node.children.delete(match[:arguments])
        match.node
      end

      # A regular string is its value, so "\x41" is "A".
      rewrite '(string_literal) @string' do |match|
        parts = match.node.children
        next nil unless parts.all? { |part| %w[string_literal_content escape_sequence].include?(part.type) }

        literal(parts.map { |part| part.type == "escape_sequence" ? CSharp.decode(part.text) : part.text }.join)
      end

      ### Rename and keep ###

      # NormalizeIdentifiers. Local variables and parameters.
      rename "(parameter name: (identifier) @name)"
      rename "(implicit_parameter) @name"
      rename "(variable_declarator name: (identifier) @name)"
      rename "(tuple_pattern name: (identifier)* @name)"
      rename "[(foreach_statement left: (identifier) @name) (catch_declaration name: (identifier) @name)]"
      rename "[(declaration_expression name: (identifier) @name) (declaration_pattern name: (identifier) @name)]"
      rename "[(from_clause name: (identifier) @name) (let_clause (identifier) @name) (join_clause (identifier) @name)]"

      # Types, methods, properties, fields and local functions.
      rename_member "[(class_declaration name: (identifier) @name) (struct_declaration name: (identifier) @name)]"
      rename_member "[(interface_declaration name: (identifier) @name) (record_declaration name: (identifier) @name)]"
      rename_member "[(enum_declaration name: (identifier) @name) (enum_member_declaration name: (identifier) @name)]"
      rename_member "[(method_declaration name: (identifier) @name) (local_function_statement name: (identifier) @name)]"
      rename_member "[(property_declaration name: (identifier) @name) (constructor_declaration name: (identifier) @name)]"
      rename_member "(field_declaration (variable_declaration (variable_declarator name: (identifier) @name)*))"
      rename_member "(record_declaration (parameter_list (parameter name: (identifier) @name)*))"

      # Names after a dot, and properties set in an object initializer, refer
      # to some object's member.
      member "[(member_access_expression name: (identifier) @name) (member_access_expression name: (generic_name (identifier) @name))]"
      member "(member_binding_expression name: (_) @name)"
      member "(initializer_expression (assignment_expression left: (identifier) @name)*)"

      # Methods that .NET itself calls.
      keep "Main", "ToString", "Equals", "GetHashCode", "CompareTo", "Dispose", "GetEnumerator", "MoveNext",
        "Current", "Reset", "Deconstruct", "Clone", "value"

      library_names File.join(__dir__, "library_names", "csharp.txt")

      LOCAL_DECLARATIONS = %w[parameter variable_declarator foreach_statement catch_declaration declaration_expression
                              declaration_pattern single_variable_designation].freeze
      MEMBER_DECLARATIONS = %w[method_declaration property_declaration event_declaration].freeze

      # Replaces `this.Name` and `ClassName.Name` with `Name`, for the
      # class's own members. Returns whether anything changed.
      def self.drop_own_qualifiers(type)
        body = type["body"]
        return false unless body

        members = Set.new
        fields = Set.new
        body.children.each do |member|
          members << member["name"].text if MEMBER_DECLARATIONS.include?(member.type) && member["name"]&.leaf?
          next unless member.type == "field_declaration"

          member.each_descendant do |node|
            next unless node.type == "variable_declarator" && node["name"]&.leaf?

            members << node["name"].text
            fields << node.object_id
          end
        end
        locals = Set.new
        type.each_descendant do |node|
          next unless LOCAL_DECLARATIONS.include?(node.type) && !fields.include?(node.object_id)

          name = node["name"] || node["left"]
          locals << name.text if name&.leaf? && name.type == "identifier"
        end
        own = members - locals
        return false if own.empty?

        changed = false
        type.each_descendant do |node|
          node.children.each do |child|
            next unless child.type == "member_access_expression" && own.include?(child["name"]&.text)

            qualifier = child["expression"]
            next unless qualifier&.type == "this" || (qualifier&.type == "identifier" && qualifier.text == type["name"]&.text)

            node.replace_child(child, child["name"])
            changed = true
          end
        end
        changed
      end

      ESCAPES = {
        "n" => "\n", "t" => "\t", "r" => "\r", "0" => "\0", "a" => "\a", "b" => "\b", "f" => "\f",
        "v" => "\v", "e" => "\e", "\\" => "\\", "\"" => "\"", "'" => "'"
      }.freeze

      # Decodes an escape. One not listed here keeps its source text, so two
      # different strings can never get the same value.
      def self.decode(escape)
        code = escape[1..]
        case code
        when /\Au([0-9a-fA-F]{4})\z/, /\AU([0-9a-fA-F]{8})\z/, /\Ax([0-9a-fA-F]{1,4})\z/
          value = Regexp.last_match(1).to_i(16)
          value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
        else ESCAPES.fetch(code, escape)
        end
      end
    end
  end
end
