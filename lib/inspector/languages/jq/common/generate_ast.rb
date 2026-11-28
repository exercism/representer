# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that jq's own parser gives.
module Inspector::Languages::Jq::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if . then 1 else 2 end  ->  (if_expression . 1 (else_expression 2))
    strip_tokens "def", "as", "reduce", "foreach", "if", "then", "elif", "else", "end", "try", "catch", "label",
                 "break", "import", "include", "module"

    # Strip the brackets, separators and quotes, because they are layout.
    # f(a; b)  ->  (call_expression f (argument_list a b))
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", ":", "|", "?", "?//", "\"", "\\("

    # Keep the `:` of a slice, because it shows which end of the slice is
    # missing.
    # .[1:]  ->  (slice_expression 1 :)
    # .[:1]  ->  (slice_expression : 1)
    keep_tokens ":", in: :slice_expression

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping.
    # (. + 1) * 2  ->  (binary_expression (binary_expression (dot) + 1) * 2)
    unwrap :parenthesized_expression

    # Write each number as its value. jq reads every number as a decimal,
    # but `1` and `1.0` stay apart, because jq can print them differently.
    #
    # 1.50  ->  1.5
    # .5  ->  0.5
    # 1e3  ->  1000.0
    numbers_are integer: :number,
                decimal: :number,
                prefixes: {}

    ESCAPES = {
      '\n' => "\n",
      '\"' => '"',
      '\\\\' => "\\"
    }.freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        write_every_object_key_as_a_string!
        write_every_field_as_an_index!
        write_every_optional_expression_as_a_try!
        write_every_elif_as_an_if_inside_an_else!
      end
    end

    private
    ### Values ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same. An interpolation keeps its code, with the text around it as
    # values.
    #
    # "say \"hi\""  ->  say "hi"
    # "a\(.b)"  ->  (string "a" (interpolation (subscript_expression . "b")))
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        pieces = match.node.children.filter_map do |child|
          case child.type
          when "string_content" then child.text
          when "escape_sequence" then ESCAPES.fetch(child.text) { leaf(:escape_sequence, child.text) }
          when "interpolation" then child
          end
        end
        string_value(pieces)
      end
    end

    # Build a string from its pieces: a literal if it is all text, or a
    # string of literals and interpolations. Join neighbouring text.
    def string_value(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.quoted

      build(:string, *parts)
    end

    ### Objects ###

    # Write each key of an object, and of an object pattern, as a string,
    # because jq's parser reads a bare key as a string. Write each key given
    # on its own as the pair it stands for, so a variable's name stays a key
    # when the variable is renamed.
    #
    # {name: 1}  ->  {"name": 1}
    # {name}  ->  {"name": .name}
    # {"name"}  ->  {"name": .name}
    # {$name}  ->  {"name": $name}
    # . as {$name}  ->  . as {"name": $name}
    def write_every_object_key_as_a_string!
      each_node(tree) do |node, _|
        next unless ["object", "object_pattern"].include?(node.type)

        node.children.dup.each do |child|
          key = child["key"]
          child.replace_child(key, literal(key.text)) if key&.type == "field_id"
          pair = shorthand_pair(node.type, child)
          node.replace_child(child, pair) if pair
        end
      end
    end

    def shorthand_pair(type, child)
      case child.type
      when "variable"
        build(type == "object" ? :pair : :pair_pattern, key: literal(child.text.delete_prefix("$")), value: child)
      when "field_id"
        build(:pair, key: literal(child.text), value: index_of_input(literal(child.text)))
      when "literal", "string"
        build(:pair, key: child, value: index_of_input(copy(child))) if type == "object"
      end
    end

    def index_of_input(key) = build(:subscript_expression, object: leaf(:dot, "."), index: key)

    ### Paths ###

    # Write each field as an index with a string, because jq's parser reads
    # them as the same path.
    #
    # .a  ->  .["a"]
    # ."a"  ->  .["a"]
    # .a.b  ->  .["a"]["b"]
    def write_every_field_as_an_index!
      transform(tree, "(field_expression) @path") do |match|
        build(:subscript_expression, object: match.node["object"], index: field_key(match.node["field"]))
      end
      transform(tree, "(field) @field") { |match| index_of_input(field_key(match.node)) }
    end

    def field_key(field)
      name = field["name"]
      name.type == "field_id" ? literal(name.text) : name
    end

    # Write `x?` as `try x`, because jq's parser reads them as the same
    # code.
    # .a?  ->  try .a
    def write_every_optional_expression_as_a_try!
      transform(tree, "(optional_expression) @optional") do |match|
        build(:try_expression, body: match.node.named_children.first)
      end
    end

    ### Conditionals ###

    # Write each `elif` as an `if` inside the `else`, and give an `if`
    # without an `else` the `else .` it stands for, because jq's parser
    # reads them as the same code.
    #
    # if a then b elif c then d else e end  ->  if a then b else if c then d else e end end
    # if a then b end  ->  if a then b else . end
    def write_every_elif_as_an_if_inside_an_else!
      transform(tree, "(if_expression) @if") do |match|
        node = match.node
        branches = node.children.select { |child| child.type == "elif_expression" }
        tail = node.children.find { |child| child.type == "else_expression" } || build(:else_expression, leaf(:dot, "."))
        branches.reverse_each do |branch|
          tail = build(:else_expression, build(:if_expression, condition: branch["condition"], body: branch["body"], tail: tail))
        end
        node.children = [node["condition"], node["body"], tail]
        node
      end
    end
  end
end
