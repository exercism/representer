# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, with one form for each spelling that MoonScript's parser
# reads the same way.
module Inspector::Languages::Moonscript::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. MoonScript's parser reads a body after `then` or
    # `do` as the same body on the next line.
    # if x then return y  ->  (if_expression x (block (return_statement y)))
    # while x do f!  ->  (while_expression x (block (call f (arguments))))
    strip_tokens "import", "from", "local", "export", "return", "if", "unless", "elseif", "else", "then", "switch",
                 "when", "with", "for", "in", "while", "do", "class"

    # Strip the brackets, commas, dots and other punctuation, because they
    # are layout. MoonScript's parser reads `f a`, `f(a)` and `f!` with no
    # arguments as the same call. The commas of a slice stay, because they
    # show which of its bounds are given.
    # f(a, b)  ->  (call f (arguments a b))
    # f!  ->  (call f (arguments))
    # a\b c  ->  (call (method_index a b) (arguments c))
    # @count  ->  (self_field count)
    # a[2,]  ->  (slice_expression a 2 ,)
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ".", ":", "\\", "@", "@@", "="
    strip_tokens "!", only_in: :arguments
    strip_tokens "*", only_in: :unpack
    keep_tokens ",", in: :slice_expression

    # Write each number as its value. MoonScript writes its numbers into
    # Lua as they are, and Lua reads a number with a point or an exponent
    # as a float and any other number as an integer, so `1.0` and `1` stay
    # apart.
    #
    # 0x1F  ->  31
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

    BODIES = ["body", "consequence"].freeze

    PARAMETERS = ["identifier", "self_field", "vararg", "table"].freeze

    CONSTRUCTOR = "new".freeze
    METAMETHOD_PREFIX = "__".freeze

    def call
      tree.tap do
        read_one_parameter_in_brackets_as_a_function!
        unwrap_brackets_that_only_group!
        write_strings_as_their_values!
        write_shorthand_pairs_as_pairs!
        give_pairs_with_a_key_in_brackets_a_type_of_their_own!
        give_the_properties_of_a_class_a_type_of_their_own!
        write_implicit_tables_as_tables!
        drop_empty_parameter_lists!
        wrap_each_body_in_a_block!
        keep_the_names_of_constructors_and_metamethods!
        give_each_assigned_field_the_field_name!
        mark_patterns!
      end
    end

    private
    # Read one name in brackets before a function as the function's
    # parameter, because MoonScript's parser reads `(x) ->` as the start of a
    # function wherever it can. The grammar sometimes reads it as a call of
    # `(x)` with the function as its argument.
    # f = (x) -> x  ->  (function_definition (parameters (parameter x)) -> (block x))
    def read_one_parameter_in_brackets_as_a_function!
      pattern = "(call function: (parenthesized_expression (_) @name) " \
                "arguments: (arguments (function_definition) @function))"
      transform(tree, pattern) do |match|
        function = match[:function]
        next nil unless match.node[:arguments].children.one? && function[:parameters].nil?
        next nil unless PARAMETERS.include?(match[:name].type)

        parameters = build(:parameters, token("("), build(:parameter, match[:name]), token(")"))
        parameters.field = "parameters"
        function.children.unshift(parameters)
        function
      end
    end

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Keep the brackets around a call or `...`, because they keep
    # only its first value.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    # (f!)  ->  (parenthesized_expression (call f (arguments)))
    def unwrap_brackets_that_only_group!
      transform(tree, "(parenthesized_expression) @brackets") do |match|
        inner = match.node.named_children
        next nil unless inner.one?
        next nil if ["call", "vararg"].include?(inner.first.type)

        inner.first
      end
    end

    ### Strings ###

    # Turn each string into its value, however it is quoted, and read its
    # escapes. Keep any other escape as a node of its own, so it can't make
    # two different strings the same. A string with interpolations keeps
    # them, with the text between them as values. A long string reads no
    # escapes, and leaves out a line break straight after its opening
    # brackets, as MoonScript does.
    #
    # 'a'  ->  "a"
    # 'it\'s'  ->  "it's"
    # [[a\n]]  ->  "a\\n"
    # "a #{n}"  ->  (string "a " (interpolation n))
    # "a\qb"  ->  (string "a" (escape_sequence \q) "b")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        string_node(string_pieces(match.node))
      end
    end

    # Return a string's pieces: its text, its escapes and its interpolations.
    def string_pieces(string)
      return string.children.flat_map { |part| double_quoted_piece(part) } unless string.leaf?

      text = string.text
      return [text[/\A\[=*\[\r?\n?(.*)\]=*\]\z/m, 1]] if text.start_with?("[")

      text[1...-1].scan(/\\.|[^\\]+/m).map { |piece| piece.start_with?("\\") ? escape(piece) : piece }
    end

    def double_quoted_piece(part)
      case part.type
      when "string_content" then [part.text]
      when "escape_sequence" then [escape(part.text)]
      when "interpolation" then [build(:interpolation, *part.named_children)]
      else []
      end
    end

    def escape(text) = ESCAPES.fetch(text) { leaf(:escape_sequence, text) }

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and other nodes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end

    ### Tables ###

    # Write each `:name` in a table as `name: name`, because MoonScript's
    # parser reads the two the same way.
    # { :count }  ->  { count: count }
    def write_shorthand_pairs_as_pairs!
      transform(tree, "(pair (shorthand_pair (identifier) @name))") do |match|
        name = match[:name].text
        build(:pair, { key: leaf(:property_identifier, name) }, { value: leaf(:identifier, name) })
      end
    end

    # Give each pair with a key in brackets a type of its own, so that
    # representation/spec.rb can tell `{[k]: 1}`, whose key is the value of
    # `k`, from `{k: 1}`, whose key is the name `k`.
    # {[k]: 1}  ->  (table (keyed_pair k 1))
    def give_pairs_with_a_key_in_brackets_a_type_of_their_own!
      find_all(tree, '(pair "[")').each { |match| match.node.type = "keyed_pair" }
    end

    # Give each line of `key: value` pairs in a class's body a type of its
    # own, because MoonScript's parser reads them as the class's properties.
    # area: => 1 (in a class's body)  ->  (class_properties (pair area (function_definition => ...)))
    def give_the_properties_of_a_class_a_type_of_their_own!
      each_node(tree) do |node, parent|
        next unless node.type == "expression_statement" && parent&.type == "class_body"

        node.type = "class_properties" if node.named_children.all? { |child| child.type == "pair" }
      end
    end

    # Write each run of pairs in a list, and each table written as indented
    # lines, as a table with braces, because MoonScript's parser reads them
    # as tables.
    # f a, b: 1, c: 2  ->  f a, {b: 1, c: 2}
    # x = a: 1  ->  x = {a: 1}
    #
    # e.g. We convert:
    #   x =
    #     a: 1
    #     b: 2
    # internally into:
    #   x = {a: 1, b: 2}
    def write_implicit_tables_as_tables!
      captured(tree, "(assignment right: (table_block) @name)").each do |table|
        table.type = "expression_list"
        table.children = [build(:table, *table.children)]
      end
      retype(tree, table_block: :table)
      each_node(tree) do |node, _|
        next unless ["expression_list", "arguments", "expression_statement"].include?(node.type)

        items = node.children.reject { |child| child.type == "," }
        node.children = items.chunk_while { |a, b| a.type == "pair" && b.type == "pair" }.map do |run|
          run.first.type == "pair" ? build(:table, *run) : run.first
        end
      end
    end

    ### Functions and bodies ###

    # Drop each empty parameter list, because MoonScript's parser reads
    # `() ->` and `->` the same way.
    # () -> 1  ->  -> 1
    def drop_empty_parameter_lists!
      each_node(tree) do |node, _|
        next unless node.type == "function_definition"

        node.children.reject! { |child| child.type == "parameters" && child.named_children.empty? }
      end
    end

    # Put each body that isn't a block in a block, because MoonScript's
    # parser reads a body on the same line as a block of one statement.
    # (x) -> x * 2  ->  (function_definition (parameters (parameter x)) -> (block (binary_expression x * 2)))
    # if a then b  ->  (if_expression a (block b))
    def wrap_each_body_in_a_block!
      each_node(tree) do |node, _|
        body = node.named_children.find { |child| BODIES.include?(child.field) }
        next if body.nil? || body.type == "block" || body.type == "class_body"

        node.replace_child(body, build(:block, body)).tap { body.field = nil }
      end
    end

    ### Names ###

    # Keep the name of a class's constructor and of each metamethod, such
    # as `__tostring`, because MoonScript and Lua call them by these names.
    # new: => @x = 1 (in a class's body)  ->  (class_properties (pair (reserved_key new) ...))
    # { __index: base }  ->  (table (pair (reserved_key __index) base))
    def keep_the_names_of_constructors_and_metamethods!
      each_node(tree) do |node, parent|
        key = node[:key] if node.type == "pair"
        next unless key&.type == "property_identifier"

        constructor = parent&.type == "class_properties" && key.text == CONSTRUCTOR
        key.type = "reserved_key" if constructor || key.text.start_with?(METAMETHOD_PREFIX)
      end
    end

    # Give the field of each `a.b` or `@b` that is assigned to, or set by a
    # parameter or a class's property, the field `name`, so that
    # representation/spec.rb can list it with the other names that are
    # assigned to, and leave the fields that are only read alone.
    # self.«count» = 0
    # @«count» = 0
    # new: (@«name») =>
    # @«total»: 0
    def give_each_assigned_field_the_field_name!
      each_node(tree) do |node, _|
        assigned_targets(node).each do |target|
          next unless ["dot_index", "with_dot_index", "self_field", "class_field"].include?(target.type)

          target.named_children.last&.field = "name"
        end
      end
    end

    # Return the children of a node that it assigns to.
    def assigned_targets(node)
      case node.type
      when "variable_list", "parameter" then node.named_children
      when "default_parameter" then [node[:name]]
      when "pair" then [node[:key]]
      else []
      end
    end

    # Mark the tables that a solution unpacks into names, so that
    # representation/spec.rb can list their names with the other
    # definitions, and leave the tables that build values alone.
    # {a, b} = pair  ->  (table_pattern a b)
    # {:count} = totals  ->  (table_pattern (pair_pattern count count))
    # for {x, y} in *points  ->  (name_list (table_pattern x y))
    def mark_patterns!
      each_node(tree) do |node, _|
        next unless ["variable_list", "name_list", "parameter", "default_parameter"].include?(node.type)

        targets = node.type == "default_parameter" ? [node[:name]] : node.named_children
        targets.each { |target| mark_pattern(target) }
      end
    end

    def mark_pattern(node)
      case node.type
      when "table" then node.type = "table_pattern"
      when "pair"
        node.type = "pair_pattern"
        return mark_pattern(node[:value])
      else return
      end
      node.named_children.each { |child| mark_pattern(child) }
    end
  end
end
