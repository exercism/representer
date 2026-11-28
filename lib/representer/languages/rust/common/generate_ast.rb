# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Rust's own parser (syn) gives.
module Representer::Languages::Rust::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if x { return y; }  ->  (if_expression x (block (return_expression y)))
    strip_tokens "fn", "let", "struct", "enum", "impl", "trait", "mod", "use", "type", "const", "static", "union",
                 "if", "else", "while", "loop", "match", "return", "break", "continue", "for", "in", "where"

    # Strip the brackets, commas and other punctuation, because they are layout.
    # f(a, b);  ->  (call_expression f (arguments a b))
    strip_tokens "(", ")", "{", "}", "[", "]", ",", ";", "|", "=>"

    # Keep every token in a macro's arguments, because they have no syntax
    # tree, so the tokens are the only thing that tells two programs apart.
    # vec![a - 1] and vec![a, -1]
    keep_tokens(*stripped_tokens, in: [:token_tree, :token_tree_pattern, :delim_token_tree, :token_repetition,
                                       :token_repetition_pattern])

    # Keep the `;` in an array, because it repeats the value.
    # [0; 5] and [0, 5]
    keep_tokens ";", in: :array_expression

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b)  ->  a + b
    unwrap :parenthesized_expression

    # Write each number as its value. A float keeps its type suffix.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    # 2.0_f64  ->  2.0f64
    numbers_are integer: :integer_literal,
                decimal: :float_literal,
                suffixes: ["f32", "f64"]

    ESCAPES = {
      '\n' => "\n",
      '\r' => "\r",
      '\t' => "\t",
      '\0' => "\0",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'"
    }.freeze

    PATTERNS = ["tuple_struct_pattern", "tuple_pattern", "slice_pattern", "match_pattern", "captured_pattern",
                "let_condition"].freeze

    def call
      tree.tap do
        write_integers_with_a_suffix_as_their_values!
        write_strings_as_their_values!
        drop_empty_statements!
        mark_the_names_of_lifetime_parameters!
        write_capitalised_names_in_patterns_as_paths!
      end
    end

    private
    ### Values ###

    # Write each integer with a type suffix as its value too, and keep the
    # suffix.
    # 1_000u32  ->  1000u32
    # 0x1F_u8  ->  31u8
    def write_integers_with_a_suffix_as_their_values!
      each_node(tree) do |node, _|
        next unless node.type == "integer_literal"

        digits, suffix = node.text.match(/\A(.*?)_?([iu](?:8|16|32|64|128|size))\z/)&.captures
        value = digits && Representer::Engine::Numbers.integer(digits)
        node.text = "#{value}#{suffix}" if value
      end
    end

    # Turn each string and raw string into its value, and read its escapes.
    # Keep any other escape as a node of its own, so it can't make two
    # different strings the same. A byte string or C string keeps a marker,
    # because it has a different type.
    #
    # "a\u{41}"  ->  "aA"
    # r"a"  ->  "a"
    # b"a"  ->  (byte_string "a")
    def write_strings_as_their_values!
      transform(tree, "[(string_literal) @string (raw_string_literal) @string]") do |match|
        parts = match.node.children.select(&:named?)
        next nil unless parts.all? { |part| ["string_content", "escape_sequence"].include?(part.type) }

        string = string_node(parts.map { |part| part.type == "escape_sequence" ? escape(part) : part.text })
        match.node.children.first&.text&.match?(/\A[bc]/) ? build(:byte_string, string) : string
      end
    end

    # Return the text that an escape stands for, or the escape's node if it
    # stands for no single character, such as a byte above 127.
    def escape(node)
      code = node.text[1..]
      case code
      when /\Au\{(\h[\h_]{0,5})\}\z/
        value = Regexp.last_match(1).delete("_").to_i(16)
        value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? node : [value].pack("U")
      when /\Ax([0-7]\h)\z/ then Regexp.last_match(1).to_i(16).chr
      else ESCAPES.fetch(node.text, node)
      end
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string_literal, *parts)
    end

    ### Statements ###

    # Drop each empty statement, as syn does.
    # let a = 1;;  ->  let a = 1;
    def drop_empty_statements!
      drop(tree, "(empty_statement)")
    end

    ### Names ###

    # Mark the name inside a lifetime parameter's lifetime as its name, so
    # that representation/spec.rb can list it with the other definitions.
    # struct S<'«a»> { x: &'a str }
    def mark_the_names_of_lifetime_parameters!
      captured(tree, "(lifetime_parameter name: (lifetime (identifier) @name))").each { |name| name.field = "name" }
    end

    # Write each name in a pattern that starts with a capital letter as a
    # path. Rust reads such a name as an enum variant, a struct or a
    # constant, so it binds nothing, and representation/spec.rb lists only the
    # names that a pattern binds.
    # Some(x) => x  ->  (match_pattern (tuple_struct_pattern (path Some) x)) x
    # None => 0  ->  (match_pattern (path None)) 0
    def write_capitalised_names_in_patterns_as_paths!
      each_node(tree) do |node, _|
        next unless PATTERNS.include?(node.type)

        node.children.each do |child|
          node.replace_child(child, build(:path, copy(child))) if child.type == "identifier" && child.text.match?(/\A[A-Z]/)
        end
      end
    end
  end
end
