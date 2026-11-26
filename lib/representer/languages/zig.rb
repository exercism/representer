# What this class does to a Zig solution's code to make its representation:
#
# - Drops comments and doc comments, and declarations of the form `const x =
#   @import("...")`.
# - Drops punctuation and keywords that the tree already shows, and brackets
#   that only group.
# - Writes a string as its value.
# - Writes numbers as their values (`1_000` is `1000`, `0x1F` is `31`,
#   `1.50` is `1.5`).
# - Replaces each name that the solution defines with a placeholder
#   (PLACEHOLDER_1, PLACEHOLDER_2 and so on).
# - Keeps every name used in the tests, the members of the exercise's stub,
#   and the language's library names.
# - Also keeps `main` and `_`.
# - Ignores files with other extensions, and test and config files.
# - Joins the files into one tree, in an order set by their code. File names
#   never appear.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    # The old zig-representer was the Exercism template: it joined the
    # solution files and removed blank lines and trailing whitespace, and it
    # never changed a name. Its golden tests are the template's F# examples,
    # so none of them can be ported. This class applies the same approach as
    # the other languages.
    class Zig < Language
      tracks "zig"
      version 8
      grammar "zig"
      extensions ".zig"

      # The grammar's tokens for builtins (`@import`), strings and characters
      # have only their quotes or `@` as children, so they hold their own text.
      text_nodes :BUILTINIDENTIFIER, :STRINGLITERALSINGLE, :LINESTRING, :CHAR_LITERAL

      # Every name is an IDENTIFIER. The grammar gives each one a field that
      # says what it is, but the rewrites below remove the nodes that hold
      # those fields, so the rename rules use the shape of the tree instead.
      names :IDENTIFIER

      ### Drop ###

      drop "[(line_comment) (doc_comment) (container_doc_comment)]"

      # `const std = @import("std");` only makes names available.
      drop "[(Decl (VarDecl) @declaration) (Statement (VarDecl) @declaration)]", where: lambda { |match|
        value = match[:declaration].named_children.find { |child| child.field.nil? }
        first = value
        first = first.children.first while first && !first.leaf?
        first&.type == "BUILTINIDENTIFIER" && first.text == "@import"
      }

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "{", "}", ",", ";",
        "fn", "test"

      ### Rewrite ###

      # These nodes wrap one expression, and `(a + b)` only groups. The tree's
      # shape already shows what they say.
      unwrap :ErrorUnionExpr, :SuffixExpr, :GroupedExpr

      # A string is its value. Any other escape keeps its source text.
      rewrite "(STRINGLITERALSINGLE) @string" do |match|
        literal(Zig.decode(match.node.text[1...-1]))
      end

      # Numbers are their values: `1_000` is `1000`, `0x1F` is `31`, and
      # `1.50` is `1.5`.
      numbers(:INTEGER) { |text| Engine::Numbers.integer(text)&.to_s }
      numbers :FLOAT do |text|
        value = Engine::Numbers.decimal(text)
        value && Engine::Numbers.write_decimal(value)
      end

      ### Rename and keep ###

      # Top-level and container declarations are reached after a dot
      # (`Point.init`), so they are renamed there too. A variable in a block is
      # not.
      rename_member "(Decl (VarDecl variable_type_function: (IDENTIFIER) @name))"
      rename "(Statement (VarDecl variable_type_function: (IDENTIFIER) @name))"
      rename "(VarDeclProto variable_type_function: (IDENTIFIER) @name)"
      rename_member "(FnProto function: (IDENTIFIER) @name)"
      rename "(ParamDecl parameter: (IDENTIFIER) @name)"
      rename "[(PtrPayload (IDENTIFIER)* @name) (PtrListPayload (IDENTIFIER)* @name)]"
      rename "[(PtrIndexPayload (IDENTIFIER)* @name) (Payload (IDENTIFIER)* @name)]"
      rename "[(BlockLabel (IDENTIFIER) @name) (BreakLabel (IDENTIFIER) @name)]"

      # Struct fields, the values of an enum, and error names.
      rename_member "(ContainerField (IDENTIFIER) @name)"
      rename_member "(ErrorSetDecl (IDENTIFIER)* @name)"

      # Names after a dot refer to a member of something else. They are only
      # renamed if the solution defines a member with that name.
      member "(FieldOrFnCall field_access: (IDENTIFIER) @name)"
      member "(FieldOrFnCall function_call: (IDENTIFIER) @name)"
      member "(FieldInit field_member: (IDENTIFIER) @name)"
      member "(_ field_constant: (IDENTIFIER) @name)"

      keep "main", "_"

      library_names File.join(__dir__, "library_names", "zig.txt")

      ESCAPES = { "n" => "\n", "r" => "\r", "t" => "\t", "\\" => "\\", "'" => "'", "\"" => "\"" }.freeze

      # Decodes the escapes of a string's text. One not listed here keeps its
      # source text, so two different strings can never get the same value.
      def self.decode(text)
        text.gsub(/\\(x[0-9a-fA-F]{2}|u\{[0-9a-fA-F]{1,6}\}|.)/m) do |escape|
          code = Regexp.last_match(1)
          case code
          when /\Ax(..)\z/ then Regexp.last_match(1).to_i(16) < 0x80 ? Regexp.last_match(1).to_i(16).chr : escape
          when /\Au\{(.+)\}\z/ then Zig.codepoint(Regexp.last_match(1).to_i(16), escape)
          else ESCAPES.fetch(code, escape)
          end
        end
      end

      def self.codepoint(value, escape) = value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
    end
  end
end
