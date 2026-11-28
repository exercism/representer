# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that the Futhark compiler's parser gives.
module Inspector::Languages::Futhark::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Futhark's parser reads a top-level `let` as `def`.
    # Keep `entry`, `local`, `type^`, `type~`, `'^` and `'~`, which change
    # what the code means.
    # if a then b else c  ->  (if_expression a b c)
    # let f x = x  ->  def f x = x
    strip_tokens "def", "let", "in", "if", "then", "else", "loop", "for", "while", "do", "match", "case",
                 "assert", "type", "module", "val", "with", "import", "open", "include", "'", "\\", "?"
    strip_tokens "-", only_in: :negative_literal
    strip_tokens "*", only_in: :unique_type
    strip_tokens "|", only_in: :sum_type
    strip_tokens "<", only_in: :for_upto
    strip_tokens "..", only_in: :range

    # Strip the brackets, separators and arrows, because they are layout.
    # Futhark's parser ignores a trailing comma, and an `in` between two
    # `let`s.
    # f (x) [1, 2,]  ->  (application (application f x) (array 1 2))
    # let a = 1 in let b = 2 in b  ->  let a = 1 let b = 2 in b
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ".", ":", "=", "->", ":>", "`"

    # Keep the `:` before a return type, because a return type of `()`
    # would otherwise read as a parameter.
    # def f x: () = x  and  def f x () = x
    keep_tokens ":", in: [:value_declaration, :binding, :lambda]

    # Keep the `:` of a slice, because it tells its start from its end.
    # a[i:]  and  a[:i]
    keep_tokens ":", in: :slice

    # Keep the `=` and `:` in a record pattern, because they tell a field's
    # pattern from its type and from the next field.
    # {a = b}  and  {a, b}
    keep_tokens "=", ":", in: :record_pattern

    # Keep the brackets of an index, because they tell it from a parameter
    # or a field with the same name.
    # let a[i] = v  and  let a i = v
    # a with [i] = v  and  a with i = v
    # (.[i])  and  (.i)
    keep_tokens "[", "]", in: [:binding, :with_expression, :projection_section, :type_application]

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Write an operator defined by the solution as the operator
    # itself.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    # def (+++) a b = ...  ->  (value_declaration +++ a b ...)
    unwrap :parenthesized_expression,
           :parenthesized_pattern,
           :parenthesized_type,
           :operator_name

    PREFIXES = { "0x" => 16, "0b" => 2 }.freeze

    # Write each number as its value. Futhark reads `1` and `1.0` as
    # different types, so they stay apart. A type suffix stays with its
    # value, so `1i32` stays apart from `1` and from `1i64`.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50f32  ->  1.5f32
    numbers_are integer: :number,
                decimal: :float,
                prefixes: PREFIXES,
                suffixes: ["f16", "f32", "f64"]

    ESCAPES = { '\n' => "\n" }.freeze

    BINDING_FIELDS = ["parameter", "pattern"].freeze

    def call
      tree.tap do
        write_integers_with_a_suffix_as_their_values!
        write_strings_as_their_values!
        write_characters_as_their_text!
        put_each_defined_name_in_a_field!
      end
    end

    private
    ### Values ###

    # Write each integer with a type suffix as its value too, and keep the
    # suffix.
    # 0x80u32  ->  128u32
    # 1_000i64  ->  1000i64
    def write_integers_with_a_suffix_as_their_values!
      each_node(tree) do |node, _|
        next unless node.type == "number"

        digits, suffix = node.text.match(/\A(.*?)([iu](?:8|16|32|64))\z/)&.captures
        value = digits && Inspector::Engine::Numbers.integer(digits, prefixes: PREFIXES)
        node.text = "#{value}#{suffix}" if value
      end
    end

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same.
    #
    # "a\n"  ->  "a\n"
    # "a\tb"  ->  (string "a" \t "b")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        parts = match.node.named_children
        next literal(string_value(parts)) if parts.all? { |part| read?(part) }

        runs = parts.chunk_while { |a, b| read?(a) && read?(b) }
        build(:string, *runs.map { |run| read?(run.first) ? literal(string_value(run)) : leaf(:escape, run.first.text) })
      end
    end

    # Write each character as its text between the quotes, in a node of its
    # own, so that `'a'` stays apart from the string `"a"`.
    # 'a'  ->  (char "a")
    def write_characters_as_their_text!
      transform(tree, "(char) @char") do |match|
        build(:char, literal(match.node.text[1..-2]))
      end
    end

    def read?(part) = part.type == "string_content" || ESCAPES.key?(part.text)

    def string_value(parts) = parts.sum("") { |part| ESCAPES.fetch(part.text, part.text) }

    ### Names ###

    # Put each name that a definition or pattern binds in the field `name`,
    # so that representation/spec.rb can tell it from the code beside it: a
    # parameter from the body, a variable from a constructor, and the
    # parameter of a module from its signature.
    # def «area» «w» = w
    # case #some «x» -> x
    # module m («p»: integral) = ...
    def put_each_defined_name_in_a_field!
      each_node(tree) do |node, _|
        case node.type
        when "value_declaration", "binding"
          node.children.each { |child| child.field = "name" if child.type == "identifier" && BINDING_FIELDS.include?(child.field) }
        when "constructor_pattern"
          node.children.each { |child| child.field = "name" if child.type == "identifier" }
        when "module_parameter"
          node.children.find { |child| child.type == "identifier" }.field = "name"
        end
      end
    end
  end
end
