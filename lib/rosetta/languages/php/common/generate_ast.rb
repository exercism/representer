# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that PHP's own parser (nikic/php-parser) gives.
module Rosetta::Languages::PHP::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if ($x) { return $y; }  ->  (if_statement $x (compound_statement (return_statement $y)))
    strip_tokens "if", "else", "elseif", "foreach", "for", "while", "do", "break", "continue", "switch", "case",
                 "try", "catch", "finally", "throw", "return", "echo", "new", "class", "interface", "trait",
                 "function", "extends", "implements", "use", "namespace", "declare", "require_once"

    # Strip the brackets, commas and other punctuation, because they are layout.
    # `array` goes too, because the parser reads `array(1)` as `[1]`.
    # f($a, $b);  ->  (function_call_expression f (arguments (argument $a) (argument $b)))
    # array(1)  ->  [1]
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", '"', "array"

    # Keep the `;` in a `for` loop's header, because it is the only thing that
    # tells two loops apart there.
    # for (;; $i++) and for ($i++;;)
    keep_tokens ";", in: :for_statement

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # ($a + $b)  ->  $a + $b
    unwrap :parenthesized_expression

    # Write each number as its value. A leading 0 means octal.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 017  ->  15
    # 1.50  ->  1.5
    numbers_are integer: :integer,
                decimal: :float,
                prefixes: { "0x" => 16, "0b" => 2, "0o" => 8, "0" => 8 }

    CASTS = { "integer" => "int", "boolean" => "bool", "double" => "float", "real" => "float", "binary" => "string" }.freeze

    ESCAPES = {
      "n" => "\n",
      "r" => "\r",
      "t" => "\t",
      "v" => "\v",
      "e" => "\e",
      "f" => "\f",
      "\\" => "\\",
      "$" => "$",
      '"' => '"'
    }.freeze

    def call
      tree.tap do
        refuse_a_file_with_no_php_code!
        drop_the_text_outside_php_tags!
        write_properties_without_their_dollar!
        write_each_variable_as_one_name!
        name_the_loop_variable_of_each_foreach!
        name_the_constant_of_each_const_element!
        write_strings_as_their_values!
        write_every_exit_and_die_as_a_call_to_exit!
        drop_empty_brackets_after_new!
        write_each_cast_with_its_main_name!
      end
    end

    private
    ### Code and text ###

    # Refuse a file that is all text, because it holds no PHP code. A code
    # pattern without its `<?php` tag is all text, so this makes the engine
    # read each pattern in the contexts in representation/spec.rb.
    def refuse_a_file_with_no_php_code!
      return unless tree.children.any? && tree.children.none? { |child| child.type == "php_tag" }

      raise Rosetta::CannotRepresent.new("parse_error", "The file holds no PHP code")
    end

    # Drop the text outside `<?php ... ?>`, and empty statements, because
    # the parser drops them too.
    # <h1>Hi</h1><?php $a = 1; ?>  ->  $a = 1;
    def drop_the_text_outside_php_tags!
      drop(tree, "[(php_tag) (php_end_tag) (text) (text_interpolation) (empty_statement)]")
    end

    ### Names ###

    # Write the name of a property without its `$`, as the parser does, so it
    # is the same name in its declaration and in each use.
    # private $count;  ->  private count;
    # self::$count  ->  self::count
    def write_properties_without_their_dollar!
      pattern = "[(property_element name: (variable_name (name) @name) @variable) " \
                "(scoped_property_access_expression name: (variable_name (name) @name) @variable)]"
      find_all(tree, pattern).each do |match|
        name = match[:name]
        name.field = match[:variable].field
        match.node.replace_child(match[:variable], name)
      end
    end

    # Write each variable as one name that keeps its `$`, so a variable never
    # shares a name with a function. Read `${a}` in a string as `$a`, as PHP
    # does.
    # $count  ->  (variable_name $count)
    # "${a}"  ->  "$a"
    def write_each_variable_as_one_name!
      transform(tree, "(variable_name (name) @name)") { |match| variable(match.node, match[:name]) }
      each_node(tree) do |node, _|
        next unless ["encapsed_string", "heredoc_body"].include?(node.type)

        node.children.map! do |child|
          name = child.named_children.first if child.type == "dynamic_variable_name"
          name && child.named_children.one? && name.type == "name" ? variable(child, name) : child
        end
      end
    end

    def variable(node, name) = leaf(:variable_name, "$#{name.text}").tap { |variable| variable.field = node.field }

    # Mark the loop variable of each `foreach`, which is the code after `as`.
    # foreach ($xs as $x)  ->  (foreach_statement $xs value: $x ...)
    def name_the_loop_variable_of_each_foreach!
      each_node(tree) do |node, _|
        next unless node.type == "foreach_statement"

        index = node.children.index { |child| !child.named? && child.type == "as" }
        node.children[index + 1].field ||= "value" if index
      end
    end

    # Mark the name of each constant, which comes before its value.
    # const LIMIT = 10;  ->  (const_element name: LIMIT 10)
    def name_the_constant_of_each_const_element!
      each_node(tree) do |node, _|
        node.named_children.first.field = "name" if node.type == "const_element"
      end
    end

    ### Strings ###

    # Turn each string into its value. Read the escapes of a double-quoted
    # string or heredoc, and keep an escape that stands for no character as a
    # node of its own, so it can't make two different strings the same. A
    # string that holds code is a string of its pieces.
    #
    # "it's"  ->  'it\'s'
    # "\x41"  ->  "A"
    # "a $b"  ->  (encapsed_string "a " $b)
    def write_strings_as_their_values!
      transform(tree, "[(string) (encapsed_string) (heredoc) (nowdoc)] @string") do |match|
        node = match.node
        case node.type
        when "string" then string_node(single_quoted(node.named_children))
        when "encapsed_string" then string_node(double_quoted(node.named_children))
        else string_node(double_quoted(heredoc_pieces(node), heredoc: node.type == "heredoc"))
        end
      end
    end

    # Return the pieces of a single-quoted string, where only `\\` and `\'`
    # are escapes.
    def single_quoted(parts)
      parts.map do |part|
        ["\\\\", "\\'"].include?(part.text) && part.type == "escape_sequence" ? part.text[1] : part.text
      end
    end

    # Return the pieces of a double-quoted string or heredoc: text for its
    # text and escapes, and the nodes of the code in it.
    def double_quoted(parts, heredoc: false)
      parts.map do |part|
        case part.type
        when "string_content", "fragment", "nowdoc_string" then part.text
        when "escape_sequence" then heredoc && part.text == '\"' ? part.text : escape(part)
        else part
        end
      end
    end

    # Return the text that an escape stands for, or the escape's node if it
    # stands for a byte that isn't a character.
    def escape(node)
      code = node.text[1..]
      case code
      when /\A[0-7]{1,3}\z/, /\Ax\h{1,2}\z/
        value = code.start_with?("x") ? code[1..].to_i(16) : code.to_i(8)
        value > 0x7F ? node : value.chr(Encoding::UTF_8)
      when /\Au\{(\h+)\}\z/
        value = Regexp.last_match(1).to_i(16)
        value > 0x10FFFF || value.between?(0xD800, 0xDFFF) ? node : [value].pack("U")
      else ESCAPES.fetch(code, node.text)
      end
    end

    # Return the pieces of a heredoc or nowdoc's body, as PHP reads it: from
    # the line after the opening marker, with the closing marker's
    # indentation removed from every line.
    def heredoc_pieces(node)
      parts = Array(node["value"]&.children).select(&:named?)
      indentation = node.children.reverse.find { |child| child.type == "fragment" }&.text.to_s[/[ \t]*\z/]
      at_line_start = true
      parts.each_with_index.map do |part, index|
        unless ["string_content", "fragment", "nowdoc_string"].include?(part.type)
          at_line_start = false
          next part
        end

        text = index.zero? ? part.text.sub(/\A\r?\n/, "") : part.text
        text = text.gsub(/(?<=\n)#{Regexp.escape(indentation)}/, "")
        text = text.delete_prefix(indentation) if at_line_start
        at_line_start = text.end_with?("\n") unless text.empty?
        leaf(part.type, text)
      end
    end

    # Build a string's value from its pieces: a literal if it is all text, or
    # a string of literals and nodes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:encapsed_string, *parts)
    end

    ### Calls ###

    # Write every way of ending the program as a call to `exit`, because the
    # parser reads them all as one `exit`.
    # exit;  ->  exit();
    # die("Bye");  ->  exit("Bye");
    def write_every_exit_and_die_as_a_call_to_exit!
      transform(tree, "[(exit_statement) (expression_statement (name) @die)] @exit") do |match|
        next nil if match[:die] && !match[:die].text.casecmp?("die")

        values = match[:die] ? [] : match.node.named_children
        arguments = build(:arguments, *values.map { |value| build(:argument, value) })
        build(:expression_statement, build(:function_call_expression, { function: leaf(:name, "exit") }, { arguments: }))
      end
      captured(tree, "(function_call_expression function: (name) @name)").each do |name|
        name.text = "exit" if name.text.casecmp?("die")
      end
    end

    # Drop the empty brackets after the class of a `new`, because the parser
    # reads `new Foo` and `new Foo()` as the same.
    # new Foo()  ->  new Foo
    def drop_empty_brackets_after_new!
      find_all(tree, "(object_creation_expression (arguments) @arguments)").each do |match|
        match.node.children.delete(match[:arguments]) if match[:arguments].named_children.empty?
      end
    end

    # Write each cast with its main name, because the parser reads the other
    # names as the same cast.
    # (integer) $x  ->  (int) $x
    # (DOUBLE) $x  ->  (float) $x
    def write_each_cast_with_its_main_name!
      each_node(tree) do |node, _|
        next unless node.type == "cast_type"

        text = node.text.downcase
        node.text = CASTS.fetch(text, text)
      end
    end
  end
end
