module Representer
  module Languages
    # Every step of exercism/elm-representer is a rule here. The old
    # representer parsed the code with elm-syntax, removed comments, renamed
    # every name that wasn't a standard library name, and printed the result
    # with elm-format. Here only the names that the solution defines are
    # renamed, and the tree has no layout, so the printing step has no
    # equivalent.
    class Elm < Language
      tracks "elm"
      version 3
      grammar "elm"
      extensions ".elm"

      names :lower_case_identifier, :upper_case_identifier

      ### Drop ###

      # RemoveComments
      drop "[(line_comment) (block_comment)]"

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "[", "]", "{", "}", ",", "let", "in", "if", "then", "else"

      ### Rewrite ###

      # A string is its value, however it is quoted. The grammar calls the
      # escape `\u{41}` invalid, though Elm accepts it.
      rewrite "(string_constant_expr) @string" do |match|
        parts = match.node.children.reject { |part| %w[open_quote close_quote].include?(part.type) }
        next nil unless parts.all? { |part| STRING_PARTS.include?(part.type) }

        literal(parts.map { |part| part.type == "regular_string_part" ? part.text : Elm.decode(part.text) }.join)
      end

      ### Rename and keep ###

      # Functions, values, parameters and variables in patterns.
      rename "(function_declaration_left (lower_case_identifier) @name)"
      rename "(lower_pattern (lower_case_identifier) @name)"
      rename "(type_annotation name: (lower_case_identifier) @name)"

      # Type variables.
      rename "(lower_type_name (lower_case_identifier) @name)"
      rename "(type_variable (lower_case_identifier) @name)"
      rename "(record_type baseRecord: (record_base_identifier (lower_case_identifier) @name))"

      # Types, constructors and record fields. A field is reached through
      # `record.field`, `.field` and record literals.
      rename_member "(type_declaration name: (upper_case_identifier) @name)"
      rename_member "(type_alias_declaration name: (upper_case_identifier) @name)"
      rename_member "(union_variant name: (upper_case_identifier) @name)"
      rename_member "(field_type name: (lower_case_identifier) @name)"
      rename_member "(field name: (lower_case_identifier) @name)"
      rename_member "(record_pattern (lower_pattern (lower_case_identifier) @name)*)"

      # A name after a dot refers to a name inside a module, or to a field.
      member "(value_qid (dot) (lower_case_identifier)* @name)"
      member "[(value_qid (dot) (upper_case_identifier)* @name) (upper_case_qid (dot) (upper_case_identifier)* @name)]"
      member "[(field_access_expr (lower_case_identifier) @name) (field_accessor_function_expr (lower_case_identifier) @name)]"

      # The names of the module and the things it exposes are the solution's
      # interface, so they stay.
      keep "(module_declaration name: (upper_case_qid (upper_case_identifier) @name))"
      keep "(module_declaration exposing: (exposing_list (exposed_value (lower_case_identifier) @name)))"
      keep "(module_declaration exposing: (exposing_list (exposed_type (upper_case_identifier) @name)))"

      # The names that Elm imports into every module.
      keep "Int", "Float", "toFloat", "round", "floor", "ceiling", "truncate", "max", "min", "compare", "Order", "GT",
        "EQ", "LT", "Bool", "True", "False", "not", "xor", "modBy", "remainderBy", "negate", "abs", "clamp", "sqrt",
        "logBase", "e", "pi", "cos", "sin", "tan", "acos", "asin", "atan", "atan2", "degrees", "radians", "turns",
        "toPolar", "fromPolar", "isNaN", "isInfinite", "identity", "always", "Never", "never", "List", "Maybe", "Just",
        "Nothing", "Result", "Ok", "Err", "String", "Char", "Tuple", "Debug", "Program", "Cmd", "Sub", "number",
        "comparable", "appendable", "compappend", "main", "init", "update", "view", "subscriptions", "Msg", "Model"

      STRING_PARTS = %w[regular_string_part string_escape invalid_string_escape].freeze
      ESCAPES = { "n" => "\n", "r" => "\r", "t" => "\t", "\\" => "\\", "\"" => "\"", "'" => "'" }.freeze

      # Decodes an escape. One not listed here keeps its source text, so two
      # different strings can never get the same value.
      def self.decode(escape)
        code = escape[1..]
        case code
        when /\Au\{([0-9a-fA-F]{1,6})\}\z/
          value = Regexp.last_match(1).to_i(16)
          value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
        else ESCAPES.fetch(code, escape)
        end
      end
    end
  end
end
