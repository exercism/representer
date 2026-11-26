# What this class does to a C++ solution's code to make its representation:
#
# - Drops comments, `#include` lines and `#pragma` lines, and keeps
#   `#define`s.
# - Drops an include guard around a whole file.
# - Drops `using namespace` and `using` declarations at file, namespace and
#   function level, and keeps them in a class.
# - Drops punctuation and keywords that the tree already shows, except where
#   they tell two programs apart (such as `delete[]` and `delete`).
# - Writes `and`, `or` and the other operator words as `&&`, `||` and so on.
# - Writes `template <class T>` as `template <typename T>`, and adds braces
#   to a statement that controls another.
# - Writes numbers as their values (`1'000` is `1000`, `0x1F` and `037` are
#   `31`) when they fit in an int, and keeps any suffix.
# - Writes a string as its value, joining adjacent strings.
# - Replaces each name that the solution defines with a placeholder
#   (PLACEHOLDER_1, PLACEHOLDER_2 and so on).
# - Keeps every name used in the tests, the members of the exercise's stub,
#   and the language's library names.
# - Also keeps `main`, and renames a name after `.`, `->` or `::` only if
#   the solution defines it.
# - Ignores files with other extensions, and test and config files.
# - Joins the files into one tree, in an order set by their code. File names
#   never appear.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    # Every step of exercism/cpp-representer is a rule here. The old
    # representer split the code into tokens with a lexer, dropped comments
    # and preprocessor lines, and renamed every name except those after
    # `std::`. Here the syntax tree does that job: only the names that the
    # solution defines are renamed, so every library name stays.
    class Cpp < Language
      tracks "cpp"
      version 7
      grammar "cpp"
      extensions ".cpp", ".h", ".hpp", ".cc", ".cxx", ".hh", ".hxx"

      names :identifier, :namespace_identifier, :type_identifier, :field_identifier, :statement_identifier

      OPERATOR_WORDS = {
        "and" => "&&", "or" => "||", "not" => "!", "not_eq" => "!=", "bitand" => "&", "bitor" => "|", "xor" => "^",
        "compl" => "~", "and_eq" => "&=", "or_eq" => "|=", "xor_eq" => "^="
      }.freeze

      ### Drop ###

      # RemoveComments.
      drop "(comment)"

      # Includes only make names available, and every solution includes what
      # it needs to pass the tests. `#pragma` lines carry no meaning for a
      # mentor. `#define`s stay, because they change the code.
      drop "(preproc_include)"
      drop '(preproc_call directive: (preproc_directive "#pragma"))'

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "{", "}", "[", "]", ";", ",", "::", "return", "if", "else", "while", "for", "do", "switch",
        "namespace", "class", "struct", "enum", "union", "using", "template", "typedef",
        "break", "continue", "goto", "try", "catch", "throw", "new", "delete", "sizeof", "static_assert"

      # In these nodes, a dropped token is the only thing that tells two
      # programs apart: `delete[] p` and `delete p`, `::new` and `new`,
      # `enum class` and `enum`, `friend class` and `friend struct`,
      # `using namespace A` and `using A`, `for (;; i++)` and `for (i++;;)`,
      # and `operator()` and `operator[]`. The access specifiers (`public`,
      # `private` and `protected`) are never dropped.
      keep_tokens_in :delete_expression, "[", "]", "::"
      keep_tokens_in :new_expression, "::"
      keep_tokens_in :enum_specifier, "class", "struct"
      keep_tokens_in :friend_declaration, "class", "struct", "union"
      keep_tokens_in :using_declaration, "namespace", "enum"
      keep_tokens_in :for_statement, ";"
      keep_tokens_in :operator_name, "(", ")", "[", "]", ",", "new", "delete"

      ### Rewrite ###

      # `#ifndef X` and `#define X` around a whole file is `#pragma once`,
      # which is dropped, so the guard goes too.
      rewrite "(translation_unit (preproc_ifdef) @guard)",
        where: ->(match) { match.node.children.size == 1 && Cpp.include_guard?(match[:guard]) } do |match|
        guard = match[:guard]
        body = guard.children.reject { |child| child.equal?(guard.children[1]) || child.equal?(guard.children[2]) }
        build(:translation_unit, *body.select(&:named?))
      end

      # `using namespace std;` and `using std::string;` only make names
      # available. A `using` in a class (such as `using Base::Base;`) changes
      # what the class has, so it stays.
      USING_SCOPES = %w[translation_unit declaration_list compound_statement preproc_ifdef preproc_if preproc_else].freeze
      rewrite "[#{USING_SCOPES.map { |type| "(#{type})" }.join(' ')}] @node" do |match|
        match.node.children.reject! { |child| child.type == "using_declaration" } ? match.node : nil
      end

      # Numbers are their values: `1'000` is `1000`, and `0x1F` and `037`
      # are `31`. An integer only changes if it fits in an int, because a
      # large hexadecimal number can have a different type from the same
      # decimal number. A number with a suffix keeps its text.
      numbers(:number_literal) { |text| Cpp.number(text) }

      # `and` is `&&`, `or` is `||`, and so on.
      OPERATOR_WORDS.each do |word, symbol|
        rewrite("[(binary_expression operator: \"#{word}\" @operator) (unary_expression operator: \"#{word}\" @operator)]") do |match|
          match[:operator].type = symbol
          match.node
        end
        rewrite("(assignment_expression operator: \"#{word}\" @operator)") do |match|
          match[:operator].type = symbol
          match.node
        end
      end

      # `template <class T>` is `template <typename T>`. The grammar drops
      # `class` above, so `typename` goes too.
      rewrite '(type_parameter_declaration "typename") @parameter' do |match|
        match.node.children.reject! { |child| child.type == "typename" }
        match.node
      end

      # A statement that controls another is the same with or without braces:
      # `if (x) y;` is `if (x) { y; }`. This also turns `else if` into
      # `else { if ... }`.
      %w[consequence body].each do |field|
        rewrite "[(if_statement #{field}: (_) @body) (while_statement #{field}: (_) @body) (for_statement #{field}: (_) @body) " \
                "(for_range_loop #{field}: (_) @body) (do_statement #{field}: (_) @body)]",
          where: ->(match) { match[:body].type != "compound_statement" } do |match|
          match.node.replace_child(match[:body], build(:compound_statement, match[:body]))
          match.node
        end
      end
      rewrite "(else_clause (_) @body)", where: ->(match) { match[:body].type != "compound_statement" } do |match|
        match.node.replace_child(match[:body], build(:compound_statement, match[:body]))
        match.node
      end

      # A string is its value: "a" "b" is "ab", and R"(a)" is "a".
      rewrite '(string_literal "\"") @string', where: ->(match) { Cpp.plain_string?(match.node) } do |match|
        parts = match.node.children.select(&:named?)
        literal(parts.map { |part| part.type == "escape_sequence" ? Cpp.decode(part.text) : part.text }.join)
      end
      rewrite '(raw_string_literal "R\"") @string',
        where: ->(match) { match.node.named_children.map(&:type) == ["raw_string_content"] } do |match|
        literal(match.node.named_children.first.text)
      end
      rewrite "(concatenated_string) @string",
        where: ->(match) { match.node.children.all? { |part| part.type == "literal" } } do |match|
        literal(match.node.children.map(&:text).join)
      end

      ### Rename and keep ###

      # Variables and parameters. A declarator can be wrapped in pointer,
      # reference and array declarators, and each wrapper is matched on its own.
      rename "(parameter_declaration declarator: (identifier) @name)"
      rename "(optional_parameter_declaration declarator: (identifier) @name)"
      rename "[(init_declarator declarator: (identifier) @name) (for_range_loop declarator: (identifier) @name)]"
      rename "[(pointer_declarator declarator: (identifier) @name) (array_declarator declarator: (identifier) @name)]"
      rename "(reference_declarator (identifier) @name)"
      rename "[(declaration (identifier)* @name) (structured_binding_declarator (identifier)* @name)]"
      rename "(type_parameter_declaration (type_identifier) @name)"
      rename "(variadic_type_parameter_declaration (type_identifier) @name)"
      rename "(labeled_statement label: (statement_identifier) @name)"

      # Functions, types, namespaces, fields, enumerators and macros.
      rename_member "(function_declarator declarator: [(identifier) @name (field_identifier) @name])"
      rename_member "(function_declarator declarator: (qualified_identifier name: (identifier) @name))"
      rename_member "(field_declaration (field_identifier)* @name)"
      rename_member "(field_declaration declarator: (pointer_declarator declarator: (field_identifier) @name))"
      rename_member "(field_declaration declarator: (array_declarator declarator: (field_identifier) @name))"
      rename_member "(field_declaration declarator: (reference_declarator (field_identifier) @name))"
      rename_member "[(class_specifier name: (type_identifier) @name) (struct_specifier name: (type_identifier) @name)]"
      rename_member "[(union_specifier name: (type_identifier) @name) (enum_specifier name: (type_identifier) @name)]"
      rename_member "[(enumerator name: (identifier) @name) (alias_declaration name: (type_identifier) @name)]"
      rename_member "(type_definition declarator: (type_identifier) @name)"
      rename_member "(namespace_definition name: (namespace_identifier) @name)"
      rename_member "(namespace_definition name: (nested_namespace_specifier (namespace_identifier)* @name))"
      rename_member "[(preproc_def name: (identifier) @name) (preproc_function_def name: (identifier) @name)]"

      # Names after a dot, an arrow or `::` belong to some object, type or
      # namespace.
      member "(field_expression field: (field_identifier) @name)"
      member "(qualified_identifier name: [(identifier) @name (type_identifier) @name])"
      member "(qualified_identifier name: (template_type name: (type_identifier) @name))"
      member "(qualified_identifier name: (template_function name: (identifier) @name))"

      keep "main"

      library_names File.join(__dir__, "library_names", "cpp.txt")

      ESCAPES = {
        "n" => "\n", "t" => "\t", "r" => "\r", "a" => "\a", "b" => "\b", "f" => "\f", "v" => "\v", "\\" => "\\",
        "\"" => "\"", "'" => "'", "?" => "?"
      }.freeze

      # Whether a string node is still in the grammar's form: a plain quote,
      # text and escapes only.
      def self.plain_string?(node)
        node.children.all? { |child| %w[" string_content escape_sequence].include?(child.type) }
      end

      # Whether an `#ifndef` is an include guard: its first child is a
      # `#define` of the same name.
      def self.include_guard?(node)
        define = node.children[2]
        node.children.first&.type == "#ifndef" && define&.type == "preproc_def" && node.children[1].text == define.children[1]&.text
      end

      # Decodes an escape. One not listed here keeps its source text, so two
      # different strings can never get the same value.
      def self.decode(escape)
        code = escape[1..]
        case code
        when /\Au([0-9a-fA-F]{4})\z/, /\AU([0-9a-fA-F]{8})\z/
          value = Regexp.last_match(1).to_i(16)
          value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
        when /\A[0-7]{1,3}\z/ then code.to_i(8) > 127 ? escape : code.to_i(8).chr
        when /\Ax([0-7][0-9a-fA-F]?)\z/ then Regexp.last_match(1).to_i(16).chr
        else ESCAPES.fetch(code, escape)
        end
      end

      INT = (0...(2**31))

      def self.number(text)
        text = text.delete("'")
        text = "0o#{text[1..]}" if text.match?(/\A0\d/)
        value = Engine::Numbers.integer(text, separator: "")
        return value.to_s if value && INT.cover?(value)

        value = !text.match?(/\A0[xb]/i) && Engine::Numbers.decimal(text, separator: "")
        value && Engine::Numbers.write_decimal(value)
      end
    end
  end
end
