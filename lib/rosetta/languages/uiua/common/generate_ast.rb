# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the tree that Uiua's own parser would read, with one form for each spelling
# that Uiua reads the same way. Uiua code is mostly a flat run of words, and
# the grammar only gives structure to bindings, functions, arrays, strands,
# modules and data definitions.
module Rosetta::Languages::Uiua::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the brackets, the `_` between the items of a strand, the `~` of a
    # module access or a data definition, and the lines that open and close a
    # module or a test scope, because the node types already show them. Keep
    # the `|` between the branches of a function or an array, because the
    # branches are separate functions.
    # (+|-)  ->  (function + | -)
    # 1_2_3  ->  (strand 1 2 3)
    # Character~Ability  ->  (module_access Character Ability)
    strip_tokens "(", ")", "[", "]", "{", "}", "_", "~", "┌─╴", "└─╴", "---"

    # Uiua reads each of these short names as the primitive's glyph.
    # ne  ->  ≠
    ALIASES = {
      "id" => "∘", "ga" => "⋅", "po" => "◌", "fx" => "¤", "bx" => "□", "elem" => "∊", "idx" => "⨴", "sw" => "⨬",
      "st" => "◫", "flr" => "⌊", "flor" => "⌊", "ran" => "⇡", "par" => "⊜", "flat" => "♭", "fla" => "♭",
      "ne" => "≠", "neq" => "≠", "eq" => "=", "lt" => "<", "less" => "<", "le" => "≤", "leq" => "≤", "lte" => "≤",
      "gt" => ">", "greater" => ">", "ge" => "≥", "geq" => "≥", "gte" => "≥", "fst" => "⊢", "lst" => "⊣",
      "slf" => "˙", "sel" => "⊏", "prs" => "⋕", "rnd" => "⚂", "sgn" => "±", "bw" => "˜", "mul" => "×",
      "mult" => "×", "mv" => "𝕍", "multi" => "𝕍", "wedge" => "⨱", "wed" => "⨱"
    }.freeze

    # Uiua reads each of these names as the primitive's glyph, and so it
    # reads any start of a name that is at least three letters long, if no
    # other name starts the same way. The names leave out the deprecated
    # primitives, as Uiua does.
    # reverse  ->  ⇌
    # rev  ->  ⇌
    NAMES = {
      "identity" => "∘", "pop" => "◌", "self" => "˙", "backward" => "˜", "dip" => "⊙", "gap" => "⋅", "on" => "⟜",
      "by" => "⊸", "with" => "⤙", "off" => "⤚", "above" => "◠", "below" => "◡", "both" => "∩", "fork" => "⊃",
      "bracket" => "⊓", "not" => "¬", "sign" => "±", "negate" => "¯", "reciprocal" => "⨪",
      "absolute value" => "⌵", "sqrt" => "√", "exponential" => "ₑ", "sine" => "∿", "floor" => "⌊",
      "ceiling" => "⌈", "round" => "⁅", "equals" => "=", "not equals" => "≠", "less than" => "<",
      "less or equal" => "≤", "greater than" => ">", "greater or equal" => "≥", "add" => "+", "subtract" => "-",
      "multiply" => "×", "inner product" => "⨰", "outer product" => "⨱", "divide" => "÷", "modulo" => "◿",
      "or" => "∨", "power" => "ⁿ", "minimum" => "↧", "maximum" => "↥", "atangent" => "∠", "complex" => "ℂ",
      "multivector" => "𝕍", "random" => "⚂", "eta" => "η", "pi" => "π", "tau" => "τ", "infinity" => "∞",
      "args" => "?", "length" => "⧻", "shape" => "△", "range" => "⇡", "first" => "⊢", "last" => "⊣",
      "reverse" => "⇌", "deshape" => "♭", "fix" => "¤", "bits" => "⋯", "transpose" => "⍉", "sort" => "⍆",
      "rise" => "⍏", "fall" => "⍖", "where" => "⊚", "deduplicate" => "◴", "classify" => "⊛",
      "occurrences" => "⧆", "box" => "□", "parse" => "⋕", "match" => "≍", "couple" => "⊟", "join" => "⊂",
      "select" => "⊏", "pick" => "⊡", "reshape" => "↯", "take" => "↙", "drop" => "↘", "rotate" => "↻",
      "orient" => "⤸", "keep" => "▽", "find" => "⌕", "mask" => "⚇", "memberof" => "∊", "indexin" => "⨴",
      "base" => "⊥", "reduce" => "/", "fold" => "∧", "scan" => "\\", "rows" => "≡", "inventory" => "⍚",
      "table" => "⊞", "tuples" => "⧅", "stencil" => "◫", "repeat" => "⍥", "group" => "⊕", "partition" => "⊜",
      "evert" => "⧋", "content" => "◇", "reach" => "∪", "obverse" => "⌅", "un" => "°", "anti" => "⌝",
      "under" => "⍜", "do" => "⍢", "fill" => "⬚", "switch" => "⨬", "try" => "⍣", "pattern" => "⍡", "case" => "⍩",
      "assert" => "⍤", "validate" => "⊨", "derivative" => "∂", "integral" => "∫"
    }.freeze

    # Uiua reads these ASCII spellings as the glyphs.
    ASCII = { "*" => "×", "%" => "÷", "`" => "¯" }.freeze

    # Uiua reads these primitives as numbers, and the grammar reads their
    # glyphs as numbers too.
    CONSTANTS = ["η", "π", "τ", "∞"].freeze

    ESCAPES = { "n" => "\n", "r" => "\r", "t" => "\t", "0" => "\0", "s" => " ",
                "\\" => "\\", "\"" => "\"", "'" => "'" }.freeze

    SUBSCRIPT_DIGITS = "₀₁₂₃₄₅₆₇₈₉".freeze

    def call
      tree.tap do
        write_each_primitive_as_its_glyph!
        write_each_number_as_its_value!
        write_strings_and_characters_as_their_values!
        write_each_binding_arrow_the_same_way!
        mark_the_fields_of_each_data_definition!
      end
    end

    private
    ### Primitives ###

    # Write each primitive as its glyph, however it is spelled, and write its
    # subscript in subscript digits. Uiua's formatter makes these changes, so
    # Uiua reads the spellings as the same program. A name of a primitive
    # with no glyph, such as `datetime`, stays a name.
    #
    # reverse  ->  ⇌
    # rev  ->  ⇌
    # *  ->  ×
    # +__2  ->  +₂
    # pi  ->  π
    def write_each_primitive_as_its_glyph!
      each_node(tree) do |node, _|
        next unless node.type == "primitive"

        spelling, subscript = node.text.match(/\A(.+?)((?:[⌞⌟₋₀-₉]|__).*)?\z/m).captures
        glyph = glyph_for(spelling)
        node.type = "number" if CONSTANTS.include?(glyph) && subscript.nil?
        node.text = "#{glyph || spelling}#{subscript && write_subscript(subscript)}"
      end
    end

    def glyph_for(spelling)
      return ASCII[spelling] if ASCII.key?(spelling)
      return spelling unless spelling.match?(/\A[a-z]+\z/)
      return ALIASES[spelling] if ALIASES.key?(spelling)
      return NAMES[spelling] if NAMES.key?(spelling)
      return nil if spelling.size < 3 || spelling == "int"

      matches = NAMES.select { |name, _| name.start_with?(spelling) }
      matches.values.first if matches.one?
    end

    # __2  ->  ₂
    # __¯1  ->  ₋₁
    def write_subscript(text)
      text.gsub(/__([`¯]?)(\d*)/) { "#{'₋' unless Regexp.last_match(1).empty?}#{Regexp.last_match(2).tr('0-9', SUBSCRIPT_DIGITS)}" }
    end

    ### Numbers ###

    # Write each number as its value. Uiua stores every number the same way,
    # so `1.0` and `1` are the same, and it reads `` ` `` and `¯` as the same
    # minus sign. A fraction such as `1/2` and a constant such as `π` keep
    # their text.
    #
    # 1e9  ->  1000000000
    # 1.50  ->  1.5
    # `3  ->  -3
    def write_each_number_as_its_value!
      each_node(tree) do |node, _|
        next unless node.type == "number"

        value = Rosetta::Engine::Numbers.decimal(node.text.tr("`¯", "--"))
        node.text = Rosetta::Engine::Numbers.write_number(value) if value
      end
    end

    ### Strings ###

    # Turn each string, format string and character into its value, and read
    # its escapes. Keep any other escape as a node of its own, so it can't
    # make two different strings the same. A format string keeps its own
    # type, because each `_` in it is a hole for a value.
    #
    # "a\sb"  ->  "a b"
    # @\s  ->  (character " ")
    # $"_ \_"  ->  (format_string "_ " (escape \_))
    # "a\x41"  ->  (string "a" (escape \x) "41")
    def write_strings_and_characters_as_their_values!
      transform(tree, "[(string) (format_string) (character)] @string") do |match|
        node = match.node
        content = { "string" => node.text[1...-1], "format_string" => node.text[2...-1],
                    "character" => node.text[1..] }.fetch(node.type)
        string_node(node.type, content.scan(/\\.|[^\\]+/m).map { |piece| escape(piece) })
      end
    end

    def escape(piece)
      return piece unless piece.start_with?("\\")

      ESCAPES.fetch(piece[1]) { leaf(:escape, piece) }
    end

    # Build a value from its pieces: a literal if it is a string of only
    # text, or a node of the type given that holds literals and escapes.
    # Join neighbouring text.
    def string_node(type, pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return parts.first if type == "string" && parts.one? && parts.first.type == "literal"
      return literal("") if type == "string" && parts.empty?

      build(type.to_sym, *parts)
    end

    ### Bindings ###

    # Write each binding arrow in one form, because Uiua reads `=` at the
    # start of a line as `←`, and `=~` and `←~` as `↚`. `↚` makes a private
    # binding, so it stays apart from `←`.
    #
    # F = +1  ->  F ← +1
    # F ←~ +1  ->  F ↚ +1
    def write_each_binding_arrow_the_same_way!
      each_node(tree) do |node, _|
        next unless node.type == "binding"

        arrow = node["operator"]
        arrow.text = arrow.type = { "=" => "←", "=~" => "↚", "←~" => "↚" }.fetch(arrow.text, arrow.text)
      end
    end

    # Give the fields of each data definition a type of their own, so that
    # representation/spec.rb can list them.
    # ~ Point «[X Y]»
    def mark_the_fields_of_each_data_definition!
      captured(tree, "(data_definition fields: (_) @name)").each { |fields| fields.type = "fields" }
    end
  end
end
