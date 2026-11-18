module Representer
  module Languages
    # Follows the old exercism/php-representer, which renamed names in
    # nikic/php-parser's tree and printed the tree back as code.
    class PHP < Language
      tracks "php"
      version 3
      grammar "php"
      extensions ".php"

      # Variables are (variable_name (name)), so every name in a PHP file is
      # a `name` leaf.
      names :name

      # Names that PHP gives a meaning to.
      SUPERGLOBALS = %w[GLOBALS _SERVER _GET _POST _FILES _COOKIE _SESSION _REQUEST _ENV argv argc].freeze

      # Function names that mean the same as another name.
      # https://www.php.net/manual/en/aliases.php
      FUNCTION_ALIASES = {
        "chop" => "rtrim", "doubleval" => "floatval", "fputs" => "fwrite", "ini_alter" => "ini_set",
        "is_double" => "is_float", "is_integer" => "is_int", "is_long" => "is_int", "is_writeable" => "is_writable",
        "join" => "implode", "key_exists" => "array_key_exists", "pos" => "current", "show_source" => "highlight_file",
        "sizeof" => "count", "strchr" => "strstr", "die" => "exit"
      }.freeze

      CASTS = { "integer" => "int", "boolean" => "bool", "double" => "float", "real" => "float", "binary" => "string" }.freeze

      ### Drop ###

      drop "(comment)"

      # Text outside <?php ... ?> is not code.
      drop "[(php_tag) (php_end_tag) (text) (text_interpolation) (empty_statement)]"

      # The node types already say what these tokens say. `array(1)` is `[1]`.
      drop_tokens "(", ")", "[", "]", "{", "}", ",", ";", "\"", "array", "list", "if", "else", "elseif"

      ### Rewrite ###

      # (a + b) is a + b: the tree's shape already shows the grouping.
      unwrap :parenthesized_expression

      # `exit;` is `exit()`.
      rewrite "(exit_statement) @exit" do |match|
        arguments = build(:arguments)
        arguments.children.concat(match.node.named_children.map { |value| build(:argument, value) })
        build(:expression_statement, build(:function_call_expression, { function: leaf(:name, "exit") }, { arguments: arguments }))
      end

      # `new Foo` is `new Foo()`.
      rewrite "(object_creation_expression (arguments) @arguments)", where: ->(match) { match[:arguments].children.empty? } do |match|
        match.node.children.delete(match[:arguments])
        match.node
      end

      # `(integer)` is `(int)`, and so on.
      rewrite "(cast_type) @cast" do |match|
        text = match.node.text.downcase
        text = CASTS.fetch(text, text)
        text == match.node.text ? nil : leaf(:cast_type, text)
      end

      # TRUE is true.
      rewrite "[(boolean) (null)] @constant" do |match|
        match.node.text == match.node.text.downcase ? nil : leaf(match.node.type, match.node.text.downcase)
      end

      # Every method is public, and `final` and `readonly` are removed from methods.
      rewrite "(method_declaration) @method",
        where: ->(match) { match.node.children.any? { |child| PHP.method_modifier?(child) } } do |match|
        match.node.children.reject! { |child| PHP.method_modifier?(child) }
        match.node
      end

      # The type of a class constant is removed.
      rewrite "(const_declaration type: (_) @type)" do |match|
        match.node.children.delete(match[:type])
        match.node
      end

      # `${a}` is `$a`.
      rewrite "(dynamic_variable_name (name) @name)", where: ->(match) { match.node.named_children.size == 1 } do |match|
        build(:variable_name, token("$"), match[:name])
      end

      # `elseif` is an `else` that holds an `if`.
      rewrite "(if_statement) @if", where: ->(match) { match.node.children.any? { |child| child.type == "else_if_clause" } } do |match|
        children = match.node.children
        index = children.index { |child| child.type == "else_if_clause" }
        elseif = children[index]
        nested = build(:if_statement, { condition: elseif["condition"] }, { body: elseif["body"] }, *children[(index + 1)..])
        otherwise = build(:else_clause, { body: build(:compound_statement, nested) })
        otherwise.field = "alternative"
        children.slice!(index..)
        children << otherwise
        match.node
      end

      # `if ($a) b();` is `if ($a) { b(); }`.
      braced = ->(match) { %w[compound_statement colon_block].include?(match[:body].type) }
      %w[if_statement else_clause while_statement for_statement foreach_statement do_statement].each do |type|
        rewrite "(#{type} body: (_) @body)", where: ->(match) { !braced.(match) } do |match|
          match.node.replace_child(match[:body], build(:compound_statement, match[:body]))
          match.node
        end
      end

      # Numbers are their values: 1_000 is 1000, and 0x10 is 16.
      rewrite "(integer) @number" do |match|
        value = PHP.integer_value(match.node.text)
        value == match.node.text ? nil : leaf(:integer, value)
      end
      rewrite "(float) @number" do |match|
        value = PHP.float_value(match.node.text)
        value == match.node.text ? nil : leaf(:float, value)
      end

      # A string is its value, so 'a' and "a" are the same. A string with
      # variables in it is a concatenation, as in the old representer:
      # "a $b" is 'a ' . $b.
      rewrite("(string) @string") { |match| PHP.string_value(match.node.children) }
      rewrite("(nowdoc) @string") { |match| PHP.nowdoc_value(match.node) }
      rewrite "[(encapsed_string) (heredoc)] @string" do |match|
        PHP.interpolated_value(match.node)
      end

      # 'a' . 'b' is 'ab'.
      rewrite "(binary_expression \".\") @concat" do |match|
        PHP.merge_concat(match.node)
      end

      # PHP ignores the case of function, method and class names, so every
      # spelling gets the one that the solution uses most. A function that PHP
      # provides gets its lower case name, and its main name if it is an alias.
      rewrite "(program) @program" do |match|
        PHP.canonicalize_names(match.node) ? match.node : nil
      end

      ### Rename and keep ###

      # Variables, including parameters, and names imported with an alias.
      rename "(variable_name (name) @name)"
      rename "(namespace_use_clause alias: (name) @name)"

      # Functions, methods, classes, constants and properties.
      rename_member "[(function_definition name: (name) @name) (method_declaration name: (name) @name)]"
      rename_member "[(class_declaration name: (name) @name) (interface_declaration name: (name) @name)]"
      rename_member "[(trait_declaration name: (name) @name) (enum_declaration name: (name) @name)]"
      rename_member "[(const_element (name) @name) (enum_case name: (name) @name)]"
      rename_member "(property_element name: (variable_name (name) @name))"
      rename_member "(property_promotion_parameter name: (variable_name (name) @name))"

      # Names that refer to something of another class or object, or a function
      # called by its name.
      member "[(function_call_expression function: (name) @name) (member_call_expression name: (name) @name)]"
      member "[(nullsafe_member_call_expression name: (name) @name) (scoped_call_expression name: (name) @name)]"
      member "[(member_access_expression name: (name) @name) (nullsafe_member_access_expression name: (name) @name)]"
      member "(scoped_property_access_expression name: (variable_name (name) @name))"
      member "(class_constant_access_expression (relative_scope) (name) @name)"
      member "(class_constant_access_expression (name) (name) @name)"
      member "[(namespace_name (name)* @name) (qualified_name (name) @name)]"

      # Names that PHP itself gives a meaning to.
      keep "this", "class", *SUPERGLOBALS
      keep "(name /\\A__\\w+\\z/) @name"

      library_names File.join(__dir__, "library_names", "php.txt")

      ### Helpers for the rules above ###

      ESCAPES = {
        "n" => "\n", "r" => "\r", "t" => "\t", "v" => "\v", "e" => "\e", "f" => "\f", "\\" => "\\", "$" => "$", "\"" => "\""
      }.freeze

      class << self
        def method_modifier?(node) = %w[visibility_modifier final_modifier readonly_modifier].include?(node.type)

        def integer_value(text)
          digits = text.delete("_").downcase
          value =
            case digits
            when /\A0x[0-9a-f]+\z/, /\A0b[01]+\z/ then Integer(digits, exception: false)
            when /\A0o?[0-7]+\z/ then Integer(digits.sub("o", ""), 8, exception: false)
            when /\A\d+\z/ then Integer(digits, 10, exception: false)
            end
          value&.to_s || text
        end

        def float_value(text)
          number = Float(text.delete("_"), exception: false)
          number&.finite? ? number.to_s : text
        end

        ### Strings ###

        # 'text': only \\ and \' are escapes.
        def string_value(parts)
          text = parts.filter_map do |part|
            case part.type
            when "string_content" then part.text
            when "escape_sequence" then ["\\\\", "\\'"].include?(part.text) ? part.text[1] : part.text
            end
          end
          literal(text.join)
        end

        def nowdoc_value(node)
          text = node.children.flat_map(&:children).map(&:text).join
          literal(text)
        end

        # "text $a": the pieces, as a concatenation, or as a single value.
        def interpolated_value(node)
          parts = node.type == "heredoc" ? node["value"].children : node.children
          pieces = []
          parts.each do |part|
            case part.type
            when "string_content" then add_text(pieces, part.text)
            when "escape_sequence" then add_text(pieces, decode(part.text))
            else pieces << part
            end
          end
          trim_heredoc_end(pieces) if node.type == "heredoc"
          return literal(pieces.first || "") if pieces.size <= 1 && !pieces.first.is_a?(Engine::Node)

          concatenation(pieces.map { |piece| piece.is_a?(String) ? literal(piece) : piece })
        end

        # Decodes an escape in a double-quoted string. One not listed here
        # keeps its source text, so two different strings can never get the
        # same value.
        def decode(escape)
          code = escape[1..]
          case code
          when /\A([0-7]{1,3})\z/, /\Ax([0-9a-fA-F]{1,2})\z/
            # A byte above 127 isn't a character, so it keeps its source text.
            value = code.start_with?("x") ? code[1..].to_i(16) : code.to_i(8)
            value > 0x7F ? escape : value.chr(Encoding::UTF_8)
          when /\Au\{([0-9a-fA-F]+)\}\z/
            value = Regexp.last_match(1).to_i(16)
            value > 0x10FFFF ? escape : [value].pack("U")
          else ESCAPES.fetch(code, escape)
          end
        end

        def add_text(pieces, text)
          pieces.last.is_a?(String) ? pieces.last << text : pieces << text.dup
        end

        # The line break before a heredoc's closing marker isn't part of the string.
        def trim_heredoc_end(pieces)
          pieces.last.sub!(/\r?\n\z/, "") if pieces.last.is_a?(String)
        end

        def concatenation(operands)
          operands.reduce do |left, right|
            build(:binary_expression, { left: left }, { operator: token(".") }, { right: right })
          end
        end

        # Flattens a chain of dots, joins the strings that touch, and
        # builds the chain again with the dots grouped from the left.
        def merge_concat(node)
          operands = flatten_concat(node)
          merged = operands.each_with_object([]) do |operand, list|
            if operand.type == "literal" && list.last&.type == "literal"
              list[-1] = literal(list.last.text + operand.text)
            else
              list << operand
            end
          end
          return nil if merged.size == operands.size && !concat?(node["right"])

          concatenation(merged)
        end

        def flatten_concat(node)
          return [node] unless concat?(node)

          flatten_concat(node["left"]) + flatten_concat(node["right"])
        end

        def concat?(node) = node&.type == "binary_expression" && node.children.any? { |child| child.type == "." }

        ### Case ###

        # Gives every spelling of a user-defined function, method or class
        # name the one that the solution uses most, and lower-cases and
        # unaliases the functions that PHP provides. Returns whether it
        # changed anything.
        def canonicalize_names(program)
          positions = name_positions(program)
          defined = positions.select { |_, _, definition| definition }.group_by { |kind, _, _| kind }
          changed = false

          positions.group_by { |kind, leaf, _| [kind, leaf.text.downcase] }.each do |(kind, lower), uses|
            leaves = uses.map { |_, leaf, _| leaf }
            defined_here = defined.fetch(kind, []).any? { |_, leaf, _| leaf.text.downcase == lower }
            target = defined_here ? most_common(leaves.map(&:text)) : provided_name(kind, lower)
            next unless target

            leaves.each do |leaf|
              next if leaf.text == target

              leaf.text = target
              changed = true
            end
          end
          changed
        end

        # The name that a function PHP provides is written with.
        def provided_name(kind, lower)
          return nil unless kind == :function && (library.include?(lower) || FUNCTION_ALIASES.key?(lower))

          FUNCTION_ALIASES.fetch(lower, lower)
        end

        def most_common(names)
          names.tally.max_by { |name, count| [count, -names.index(name)] }.first
        end

        # Every name that is a function, method or class: [kind, leaf, defined here].
        def name_positions(program)
          found = []
          program.each_descendant do |node|
            node.children.each_with_index do |child, index|
              next unless child.type == "name" && child.leaf?

              kind, definition = name_kind(node, child, index)
              found << [kind, child, definition] if kind
            end
          end
          found
        end

        def name_kind(parent, child, index)
          case parent.type
          when "function_definition" then child.field == "name" ? [:function, true] : nil
          when "function_call_expression" then child.field == "function" ? [:function, false] : nil
          when "method_declaration" then child.field == "name" ? [:method, true] : nil
          when "member_call_expression", "nullsafe_member_call_expression", "scoped_call_expression"
            child.field == "name" ? [:method, false] : class_use(parent, child)
          when "class_declaration", "interface_declaration", "trait_declaration", "enum_declaration"
            child.field == "name" ? [:class, true] : [:class, false]
          when "object_creation_expression", "base_clause", "class_interface_clause", "named_type", "use_declaration"
            [:class, false]
          when "class_constant_access_expression", "scoped_property_access_expression"
            index.zero? ? [:class, false] : nil
          end
        end

        def class_use(parent, child)
          parent.type == "scoped_call_expression" && child.field == "scope" ? [:class, false] : nil
        end
      end
    end
  end
end
