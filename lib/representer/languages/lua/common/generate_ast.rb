# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, with one form for each spelling that Lua's parser reads the
# same way.
module Representer::Languages::Lua::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if x then return y end  ->  (if_statement x (block (return_statement y)))
    strip_tokens "function", "end", "do", "if", "then", "elseif", "else", "for", "in", "while", "repeat", "until",
                 "return", "break", "goto", "::"

    # Strip the brackets, commas, semicolons, dots and `=`, because they are
    # layout. Lua's parser reads `f "s"` and `f {1}` as `f("s")` and `f({1})`.
    # f(a, b)  ->  (function_call f (arguments a b))
    # f "s"  ->  (function_call f (arguments "s"))
    # {1, 2; 3}  ->  (table_constructor (field 1) (field 2) (field 3))
    # a.b:c()  ->  (function_call (method_index_expression (dot_index_expression a b) c) (arguments))
    strip_tokens "(", ")", "{", "}", "[", "]", ",", ";", ".", ":", "="

    # Write each number as its value. Lua reads a number with a point or an
    # exponent as a float, and any other number as an integer, so `1.0` and
    # `1` stay apart. Lua has no octal numbers and no digit separators.
    #
    # 0x1F  ->  31
    # 010  ->  10
    # 1.50  ->  1.5
    # 1e3  ->  1000.0
    numbers_are integer: :number,
                decimal: :number,
                prefixes: { "0x" => 16 },
                separators: []

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'"
    }.freeze

    def call
      tree.tap do
        drop_empty_statements!
        unwrap_brackets_that_only_group!
        write_strings_as_their_values!
        write_attributes_as_leaves!
        give_fields_with_a_key_in_brackets_a_type_of_their_own!
        write_function_declarations_as_assignments!
        give_each_assigned_field_the_field_name!
      end
    end

    private
    # Drop each empty statement, because Lua's parser skips a lone `;`.
    # x = 1;;  ->  x = 1
    def drop_empty_statements!
      drop(tree, "(empty_statement)")
    end

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Keep the brackets around a call or `...`, because they keep
    # only its first value.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    # (f())  ->  (parenthesized_expression (function_call f (arguments)))
    def unwrap_brackets_that_only_group!
      transform(tree, "(parenthesized_expression) @brackets") do |match|
        inner = match.node.named_children
        next nil unless inner.one?
        next nil if ["function_call", "vararg_expression"].include?(inner.first.type)

        inner.first
      end
    end

    ### Strings ###

    # Turn each string into its value, however it is quoted, and read its
    # escapes. Keep any other escape as a node of its own, so it can't make
    # two different strings the same. A long string reads no escapes, and
    # leaves out a line break straight after its opening brackets, as Lua
    # does.
    #
    # 'a'  ->  "a"
    # [[a\n]]  ->  "a\\n"
    # [==[\na]==]  ->  "a"
    # "a\x41"  ->  (string "a" (escape_sequence \x41))
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        long = match.node.children.first.text.start_with?("[")
        content = match.node[:content]
        string_node(content ? content_pieces(content, long:) : [])
      end
    end

    # Return the pieces of a string's content: text, and the escapes that
    # stay as nodes.
    def content_pieces(content, long:)
      return [content.text.sub(/\A\r?\n/, "")] if long
      return [content.text] if content.leaf?

      content.children.map do |piece|
        piece.type == "escape_sequence" ? ESCAPES.fetch(piece.text, piece) : piece.text
      end
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end

    ### Names ###

    # Write the attribute of a local variable as a leaf, because it is a
    # keyword that the grammar gives as a name.
    # local x <const> = 1  ->  (variable_list x (attribute const))
    def write_attributes_as_leaves!
      transform(tree, "(attribute (identifier) @name)") do |match|
        leaf(:attribute, match[:name].text)
      end
    end

    # Give each table field with a key in brackets a type of its own, so
    # that representation/spec.rb can tell `{[k] = 1}`, whose key is the value of
    # `k`, from `{k = 1}`, whose key is the name `k`.
    # {[k] = 1}  ->  (table_constructor (keyed_field k 1))
    def give_fields_with_a_key_in_brackets_a_type_of_their_own!
      find_all(tree, '(field "[")').each { |match| match.node.type = "keyed_field" }
    end

    # Write each function declaration that isn't local as an assignment of
    # a function, and a method's `:` as a `self` parameter, because Lua's
    # parser reads them the same way. Keep `local function f`, because Lua
    # reads it as `local f; f = function`, which differs from
    # `local f = function` when f calls itself.
    #
    # function f(x) end  ->  f = function(x) end
    # function M.f(x) end  ->  M.f = function(x) end
    # function M:f(x) end  ->  M.f = function(self, x) end
    def write_function_declarations_as_assignments!
      transform(tree, "(function_declaration) @declaration") do |match|
        declaration = match.node
        next nil if declaration.children.any? { |child| !child.named? && child.text == "local" }

        build(:assignment_statement,
              build(:variable_list, { name: function_target(declaration) }),
              build(:expression_list, { value: function_value(declaration) }))
      end
    end

    # Return the name or field that a function declaration assigns to.
    # Return a method's name as a field.
    def function_target(declaration)
      name = declaration[:name]
      return name unless name.type == "method_index_expression"

      build(:dot_index_expression, { table: name[:table] }, { field: name[:method] })
    end

    # Return the function that a declaration defines, with `self` as the
    # first parameter of a method.
    def function_value(declaration)
      parameters = declaration[:parameters]
      method = declaration[:name].type == "method_index_expression"
      parameters.children.unshift(leaf(:identifier, "self", field: :name)) if method
      build(:function_definition, { parameters:, body: declaration[:body] })
    end

    # Give the field of each `a.b` that is assigned to the field `name`, so
    # that representation/spec.rb can list it with the other names that are
    # assigned to, and leave the fields that are only read alone.
    # self.«count» = 0
    # M.«f» = function(x) end
    def give_each_assigned_field_the_field_name!
      captured(tree, "(variable_list name: (dot_index_expression) @name)").each do |target|
        target[:field].field = "name"
      end
    end
  end
end
