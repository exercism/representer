# What this class does to a JavaScript solution's code to make its representation:
#
# - Drops comments, `#!` lines and empty statements (except in a `for`).
# - Drops imports, `require` declarations, export lists and `module.exports
#   = { ... }`, and keeps an import with no names (`import "./setup"`).
# - Drops punctuation, quotes and keywords that the tree already shows, and
#   brackets that only group.
# - Writes `(x) => x` as `x => x`.
# - Writes a string as its value, however it is quoted.
# - Writes numbers as their values: `1_000`, `1000.0` and `1e3` are `1000`,
#   and `0x1F` is `31`.
# - Replaces each name that the solution defines with a placeholder
#   (PLACEHOLDER_1, PLACEHOLDER_2 and so on).
# - Keeps every name used in the tests and the members of the exercise's stub.
# - Also keeps the methods that JavaScript itself calls (`constructor`,
#   `toString` and so on).
# - Keeps shorthand property names, because they are also property names.
# - Ignores files with other extensions, and test and config files.
# - Joins the files into one tree, in an order set by their code. File names
#   never appear.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    class JavaScript < Language
      tracks "javascript"
      version 8
      grammar "javascript"
      extensions ".js", ".mjs", ".cjs", ".jsx"

      # Shorthand properties ({ a } and const { a } = obj) are left out: their
      # name is also a property name, so renaming it would change the code.
      names :identifier, :property_identifier, :private_property_identifier, :statement_identifier

      ### Drop ###

      # A `#!` line only says how to run the file as a script.
      drop "[(comment) (hash_bang_line)]"
      # An empty statement does nothing, except as the first or second part of
      # a `for`, where it shows which part is missing: `for (;; i++)` and
      # `for (i++;;)` are different loops.
      drop "(empty_statement)", where: ->(match) { !%w[initializer condition].include?(match.node.field) }

      # Imports, `require` calls and export lists only make names available.
      # Every solution exports what the tests use, and the tests' names are
      # kept anyway. An import with no names (`import "./setup"`) runs code,
      # so it stays.
      drop "(import_statement (import_clause))"
      drop "(export_statement (export_clause))"
      drop "[(lexical_declaration) (variable_declaration)] @declaration", where: lambda { |match|
        declarators = match.node.named_children.select { |child| child.type == "variable_declarator" }
        declarators.any? && declarators.all? { |declarator| JavaScript.require_call?(declarator["value"]) }
      }
      drop "(expression_statement (assignment_expression) @assignment)", where: lambda { |match|
        JavaScript.export_list?(match[:assignment])
      }

      # The node types already say what these tokens say. String quotes go
      # too, because a string's value doesn't depend on its quotes.
      drop_tokens "(", ")", "[", "]", "{", "}", ",", ";", ".", ":", "=>", "${",
        "\"", "'", "`", "return", "function", "class", "if", "else", "while", "for", "do", "new", "export",
        "break", "continue", "throw", "try", "catch", "finally", "switch", "case", "yield", "debugger"

      ### Rewrite ###

      # (a + b) is a + b: the tree's shape already shows the grouping.
      unwrap :parenthesized_expression

      # `(x) => x` is `x => x`.
      rewrite "(arrow_function parameters: (formal_parameters (identifier) @parameter) @parameters)",
        where: ->(match) { match[:parameters].children.size == 1 } do |match|
        match.node.replace_child(match[:parameters], match[:parameter])
        match[:parameter].field = "parameter"
        match.node
      end

      # A string is its value: 'a', "a" and `a` are the same. Template
      # strings with substitutions keep their structure, with each literal
      # part as one value.
      rewrite "[(string) @string (template_string) @string]" do |match|
        pieces = JavaScript.string_parts(match.node.children)
        next nil unless pieces
        # A template made only of substitutions is already in its final form.
        next nil if pieces.any? && pieces.all?(Engine::Node)

        next literal(pieces.first || "") if pieces.size <= 1 && !pieces.first.is_a?(Engine::Node)

        build(:template_string, *pieces.map { |piece| piece.is_a?(String) ? literal(piece) : piece })
      end

      # Numbers are their values. JavaScript has one number type, so `1_000`,
      # `1000.0` and `1e3` are all `1000`, and `0x1F` is `31`. A BigInt
      # (`10n`) and an old octal number (`017`) keep their text.
      numbers :number do |text|
        next nil if text.match?(/\A0\d|n\z/)

        value = Engine::Numbers.integer(text) || Engine::Numbers.decimal(text)
        value && Engine::Numbers.write_number(value.to_r)
      end

      ### Rename and keep ###

      # Local variables, parameters, functions and classes.
      rename "(variable_declarator name: (identifier) @name)"
      rename "(formal_parameters (identifier)* @name)"
      rename "[(arrow_function parameter: (identifier) @name) (assignment_pattern left: (identifier) @name)]"
      rename "[(rest_pattern (identifier) @name) (array_pattern (identifier)* @name)]"
      rename "[(for_in_statement left: (identifier) @name) (catch_clause parameter: (identifier) @name)]"
      rename "[(function_declaration name: (identifier) @name) (generator_function_declaration name: (identifier) @name)]"
      rename "[(function_expression name: (identifier) @name) (class_declaration name: (identifier) @name)]"
      rename "(assignment_expression left: (identifier) @name)"
      rename "(labeled_statement label: (statement_identifier) @name)"

      # Methods, fields and properties set on `this`.
      rename_member "(method_definition name: (property_identifier) @name)"
      rename_member "(field_definition property: [(property_identifier) (private_property_identifier)] @name)"
      rename_member "(assignment_expression left: (member_expression object: (this) property: (property_identifier) @name))"
      rename_member "(private_property_identifier) @name"

      # Names after a dot, and object keys, refer to some object's property.
      member "(member_expression property: (_) @name)"
      member "(pair key: (property_identifier) @name)"

      # Methods that JavaScript itself calls.
      keep "constructor", "toString", "valueOf", "toJSON", "then", "next", "length", "default"

      # `require("fs")`.
      def self.require_call?(node)
        return false unless node&.type == "call_expression" && node["function"]&.text == "require"

        arguments = node["arguments"]&.named_children || []
        arguments.size == 1 && arguments.first.type == "string"
      end

      # `module.exports = { a, b }`.
      def self.export_list?(assignment)
        target = assignment["left"]
        value = assignment["right"]
        target&.type == "member_expression" && target["object"]&.text == "module" && target["property"]&.text == "exports" &&
          value&.type == "object" && value.children.select(&:named?).all? { |child| child.type == "shorthand_property_identifier" }
      end

      ESCAPES = {
        "n" => "\n", "t" => "\t", "r" => "\r", "b" => "\b", "f" => "\f", "v" => "\v", "0" => "\0",
        "\n" => "", "\r\n" => ""
      }.freeze

      # Joins a string's literal parts into values, decoding escapes, and keeps
      # substitutions as they are. Returns a list of Strings and nodes, or nil
      # if the string holds anything else.
      def self.string_parts(children)
        children.each_with_object([]) do |part, pieces|
          case part.type
          when "template_substitution"
            pieces << part
            next
          when "string_fragment", "escape_sequence"
            text = part.type == "escape_sequence" ? decode(part.text) : part.text
            pieces.last.is_a?(String) ? pieces.last << text : pieces << text.dup
          else
            return nil
          end
        end
      end

      # Decodes an escape. One not listed here keeps its source text, so two
      # different strings can never get the same value.
      def self.decode(escape)
        code = escape[1..]
        case code
        when /\Au\{([0-9a-fA-F]+)\}\z/, /\Au([0-9a-fA-F]{4})\z/
          value = Regexp.last_match(1).to_i(16)
          value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
        when /\Ax([0-7][0-9a-fA-F])\z/ then Regexp.last_match(1).to_i(16).chr(Encoding::UTF_8)
        when /\A[\\"'`$]\z/ then code
        else ESCAPES.fetch(code, escape)
        end
      end
    end
  end
end
