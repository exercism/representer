# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that CoffeeScript's own parser (`coffee --nodes`) gives.
module Inspector::Languages::Coffeescript::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if x then return y  ->  (if_expression x (block (return_statement y)))
    strip_tokens "class", "if", "else", "then", "for", "loop", "switch", "try", "catch", "finally", "return", "throw",
                 "new", "do", "yield", "await"

    # Strip these keywords only where they sit in a fixed place, because a
    # loop's `when` gives its guard.
    # switch x when 1 then y  ->  (switch_expression x (when_clause 1 (block y)))
    # a?  ->  (existence_expression a)
    strip_tokens "when", only_in: :when_clause
    strip_tokens "?", only_in: :existence_expression

    # Strip the brackets, commas, quotes and other punctuation, because they
    # are layout. The soaks `?.` and `?[` stay.
    # f(a, b)  ->  (call_expression f (arguments a b))
    # x = a.b  ->  (assignment x (member_expression a b))
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", ".", ":", "=", '"', '"""'

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value. CoffeeScript numbers are JavaScript
    # numbers, so an integer and a decimal with the same value are the same.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1e3  ->  1000
    # .50  ->  0.5
    numbers_are number: :number

    # CoffeeScript's lexer reads each of these words as the operator beside it.
    ALIASES = {
      "and" => "&&",
      "or" => "||",
      "is" => "==",
      "isnt" => "!="
    }.freeze

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\b' => "\b",
      '\f' => "\f",
      '\v' => "\v",
      '\0' => "\0",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'"
    }.freeze

    POSTFIX = ["postfix_conditional", "postfix_loop", "comprehension"].freeze

    BODIES = ["if_expression", "when_clause", "for_expression", "while_expression", "try_expression", "function"].freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        keep_regexes_apart_from_strings!
        write_booleans_as_true_or_false!
        write_this_the_same_way!
        write_operator_words_as_operators!
        write_this_members_as_member_expressions!
        write_the_dots_of_each_splat_after_it!
        write_prototype_access_as_member_expressions!
        move_postfix_conditions_and_loops_into_one_line_functions!
        write_postfix_statements_before_their_bodies!
        wrap_each_body_in_a_block!
        write_implicit_objects_as_objects!
        pass_the_pairs_of_a_call_as_one_object!
        write_calls_without_brackets_as_calls!
        write_new_with_arguments_the_same_way!
        unwrap_a_value_written_on_the_next_line!
        mark_parameter_names!
        mark_loop_variables!
        mark_patterns!
        mark_class_members!
        mark_properties_set_on_this!
        mark_properties_set_on_a_prototype!
      end
    end

    private
    ### Values ###

    # Turn each string into its value, however it is quoted, and read its
    # escapes. Keep any other escape as a node of its own, so it can't make
    # two different strings the same. A string with interpolations keeps
    # them, with the text between them as values.
    #
    # CoffeeScript trims the lines of a string that spans several lines, so
    # such a string keeps its text and escapes as written, and says whether
    # it is a heredoc, because a heredoc keeps its line breaks.
    #
    # 'a'  ->  "a"
    # "a\tb"  ->  "a	b"
    # "a #{n}"  ->  (string "a " (interpolation n))
    # '''a'''  ->  "a"
    # """a\n  b"""  ->  (heredoc "a\n  b")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        string = match.node
        as_written = text_of(string).include?("\n")
        string_node(string_type(string, as_written), string_pieces(string, as_written:), as_written:)
      end
    end

    def string_type(string, as_written)
      return :string unless as_written

      heredoc = string.leaf? ? string.text.start_with?("'''") : string.children.first.type == '"""'
      heredoc ? :heredoc : :multiline_string
    end

    # Return a string's pieces: its text, its escapes and its interpolations.
    def string_pieces(string, as_written:)
      if string.leaf?
        quotes = string.text.start_with?("'''") ? 3 : 1
        text = string.text[quotes...-quotes]
        return as_written ? [text] : escaped_pieces(text)
      end

      string.children.flat_map do |part|
        case part.type
        when "fragment" then as_written ? [part.text] : escaped_pieces(part.text)
        when "escape_sequence" then [as_written ? leaf(:escape, part.text) : escape(part.text)]
        when "interpolation" then [part]
        else []
        end
      end
    end

    # Split text into its characters and escapes, and read each escape.
    def escaped_pieces(text)
      text.scan(/\\u\{\h+\}|\\u\h{4}|\\x\h{2}|\\.|[^\\]+/m).map { |piece| piece.start_with?("\\") ? escape(piece) : piece }
    end

    # Return the text that an escape stands for, or a node for the escape if
    # it stands for no single character, such as half of a surrogate pair.
    def escape(text)
      return ESCAPES.fetch(text) { leaf(:escape, text) } unless text.match?(/\A\\(u\h{4}|u\{\h+\}|x\h{2})\z/)

      value = text[/\h+(?=\}?\z)/].to_i(16)
      value.between?(0xD800, 0xDFFF) ? leaf(:escape, text) : [value].pack("U")
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # node of the string's type holding literals and other nodes. Join
    # neighbouring text.
    def string_node(type, pieces, as_written:)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      parts = [literal("")] if parts.empty?
      return parts.first if !as_written && parts.one? && parts.first.type == "literal"

      build(type, *parts)
    end

    # Wrap each regex in a node of its own, because the output would write a
    # regex that holds a backslash in quotes, as it writes a string.
    # /a\/b/  ->  (regex "/a\\/b/")
    def keep_regexes_apart_from_strings!
      transform(tree, "(regex) @regex") { |match| build(:regex, literal(match.node.text)) if match.node.leaf? }
    end

    # Write each boolean as `true` or `false`, because CoffeeScript's lexer
    # reads `yes` and `on` as `true`, and `no` and `off` as `false`.
    # yes  ->  true
    # off  ->  false
    def write_booleans_as_true_or_false!
      transform(tree, "(boolean) @boolean") do |match|
        leaf(:boolean, ["true", "yes", "on"].include?(text_of(match.node)) ? "true" : "false")
      end
    end

    # Write `@` on its own as `this`, because CoffeeScript's parser reads the
    # two the same way.
    # @  ->  this
    def write_this_the_same_way!
      transform(tree, "(this) @this") { leaf(:this, "this") }
    end

    # Write each operator word as its operator, because CoffeeScript's lexer
    # reads the two the same way.
    # a and b  ->  a && b
    # a isnt b  ->  a != b
    # not a  ->  !a
    def write_operator_words_as_operators!
      each_node(tree) do |node, _|
        next unless ["binary_expression", "unary_expression"].include?(node.type)

        operator = node[:operator]
        word = node.type == "unary_expression" ? { "not" => "!" } : ALIASES
        node.replace_child(operator, token(word[operator.text])) if operator && word.key?(operator.text)
      end
    end

    ### Members ###

    # Write `@x` as `this.x`, because CoffeeScript's parser reads the two
    # the same way.
    # @count  ->  (member_expression this count)
    def write_this_members_as_member_expressions!
      transform(tree, "(this_member property: (_) @property)") do |match|
        build(:member_expression, { object: leaf(:this, "this") }, { property: match[:property] })
      end
    end

    # Write the `...` of each splat after it, because CoffeeScript's parser
    # reads `...a` and `a...` the same way.
    # f(...a)  ->  f(a...)
    # (...rest) ->  ->  (rest...) ->
    def write_the_dots_of_each_splat_after_it!
      each_node(tree) do |node, _|
        next unless ["splat", "parameter"].include?(node.type) && node.children.first.type == "..."

        node.children.rotate!
      end
    end

    # Write `A::b` as `A.prototype.b`, because CoffeeScript's parser reads
    # the two the same way. The soak `?::` stays.
    # A::b  ->  (member_expression (member_expression A prototype) b)
    def write_prototype_access_as_member_expressions!
      transform(tree, '(prototype_expression object: (_) @object "::" property: (_)? @property)') do |match|
        prototype = build(:member_expression, { object: match[:object] },
                          { property: leaf(:property_identifier, "prototype") })
        next prototype unless match[:property]

        build(:member_expression, { object: prototype }, { property: match[:property] })
      end
    end

    ### Bodies ###

    # Move a condition or a loop written after a one-line function into the
    # function's body, because the body of a one-line function runs to the
    # end of the line. The grammar reads the condition as applying to the
    # whole statement. Brackets around the function end its body.
    # f = (x) -> g(x) if x  ->  f = (x) -> (g(x) if x)
    # f g, -> a for a in b  ->  f g, -> (a for a in b)
    def move_postfix_conditions_and_loops_into_one_line_functions!
      each_node(tree) do |node, _|
        node.children.map! { |child| postfix_moved_into_function(child) }
      end
    end

    # Return the statement with its condition or loop moved into the last
    # one-line function in it, or the statement as it is if it has none.
    def postfix_moved_into_function(statement)
      return statement unless POSTFIX.include?(statement.type)

      outer = statement[:body]
      function = last_one_line_function(outer)
      return statement unless function

      field = statement.field
      inner = function[:body]
      statement.replace_child(outer, inner)
      function.replace_child(inner, statement)
      outer.tap { outer.field = field }
    end

    # Follow the last child of each node down from this one, up to the first
    # token, and return the last one-line function on the way.
    def last_one_line_function(node)
      found = nil
      while node&.named?
        found = node if node.type == "function" && node[:body] && node[:body].type != "block"
        node = node.children.last
      end
      found
    end

    # Write each statement with a condition or a loop after it as the
    # statement that puts them first, because CoffeeScript's parser reads the
    # two the same way.
    # x if a  ->  if a then x
    # x while a  ->  while a then x
    # x for x in xs  ->  for x in xs then x
    def write_postfix_statements_before_their_bodies!
      types = { "postfix_conditional" => "if_expression", "postfix_loop" => "while_expression",
                "comprehension" => "for_expression" }
      each_node(tree) do |node, _|
        next unless types.key?(node.type)

        node.type = types[node.type]
        body = node[:body]
        node.children = node.children.reject { |child| child.equal?(body) } << body
      end
    end

    # Put each body that isn't a block in a block, because CoffeeScript's
    # parser reads a body after `then` or `->` as a block of one statement.
    # if a then b  ->  (if_expression a (block b))
    # (x) -> x * 2  ->  (function (parameters (parameter x)) -> (block (binary_expression x * 2)))
    # else if b  ->  (else_clause (block (if_expression b ...)))
    def wrap_each_body_in_a_block!
      each_node(tree) do |node, _|
        body = body_of(node)
        node.replace_child(body, build(:block, body)) if body && body.type != "block"
      end
    end

    # Return a node's body: the child in its `body` field, or the statement
    # of an `else` or a `catch`, which the grammar gives no field.
    def body_of(node)
      return node[:body] if BODIES.include?(node.type)
      return node.named_children.first if node.type == "else_clause"

      node.named_children.find { |child| child.field.nil? } if node.type == "catch_clause"
    end

    ### Objects and calls ###

    # Write each run of `key: value` lines as one object, because
    # CoffeeScript's parser reads the lines as one object without braces.
    # a: 1, b: 2  ->  {a: 1, b: 2}
    # a: 1 (then, on the next line) b: 2  ->  {a: 1, b: 2}
    def write_implicit_objects_as_objects!
      each_node(tree) do |node, _|
        runs = node.children.chunk_while { |a, b| a.type == "implicit_object" && b.type == "implicit_object" }
        node.children = runs.map do |run|
          next run.first unless run.first.type == "implicit_object"

          build(:object, *run.flat_map(&:named_children)).tap { |object| object.field = run.first.field }
        end
      end
    end

    # Pass each run of `key: value` arguments as one object, because
    # CoffeeScript's parser reads them as one object without braces.
    # f x, a: 1, b: 2  ->  f x, {a: 1, b: 2}
    def pass_the_pairs_of_a_call_as_one_object!
      each_node(tree) do |node, _|
        next unless node.type == "arguments"

        runs = node.named_children.chunk_while { |a, b| a.type == "pair" && b.type == "pair" }
        node.children = runs.map { |run| run.first.type == "pair" ? build(:object, *run) : run.first }
      end
    end

    # Write a call without brackets as a call with them, because
    # CoffeeScript's parser reads the two the same way.
    # f x, y  ->  f(x, y)
    def write_calls_without_brackets_as_calls!
      retype(tree, implicit_call: :call_expression)
    end

    # Write `new A x` as `new A(x)`, because CoffeeScript's parser reads the
    # two the same way.
    # new A x  ->  (new_expression (call_expression A (arguments x)))
    def write_new_with_arguments_the_same_way!
      transform(tree, "(call_expression function: (new_expression constructor: (_) @class) arguments: (_) @arguments)") do |match|
        call = build(:call_expression, { function: match[:class] }, { arguments: match[:arguments] })
        build(:new_expression, { constructor: call })
      end
    end

    # Unwrap a value written on the line after its `=` or `:`, because
    # CoffeeScript's parser reads it as the value itself.
    # x =  (then, indented on the next line)  1  ->  x = 1
    def unwrap_a_value_written_on_the_next_line!
      each_node(tree) do |node, _|
        next unless ["assignment", "compound_assignment", "pair"].include?(node.type)

        value = node[:right] || node[:value]
        node.replace_child(value, value.named_children.first) if value&.type == "block" && value.named_children.one?
      end
    end

    ### Names ###

    # Give each parameter's name the field `name`, so that
    # representation/spec.rb can tell it from the parameter's default value.
    # (count = 0) ->  ->  (parameter name: count default: 0)
    def mark_parameter_names!
      each_node(tree) do |node, _|
        next unless node.type == "parameter"

        node.named_children.find { |child| child.field.nil? }&.field = "name"
      end
    end

    # Give a loop's index the field of its value, so that
    # representation/spec.rb can list both as the loop's variables.
    # for x, i in xs  ->  (for_expression variable: x variable: i xs ...)
    def mark_loop_variables!
      each_node(tree) do |node, _|
        next unless node.type == "for_expression"

        node.children.each { |child| child.field = "variable" if ["value", "index"].include?(child.field) }
      end
    end

    # Mark each array and object that is assigned to, or that a function or
    # loop takes apart, as a pattern, so that representation/spec.rb can list
    # the names in it.
    # [a, b] = pair  ->  (assignment (array_pattern a b) pair)
    # ({count}) ->  ->  (function (parameters (parameter (object_pattern count))) ->)
    def mark_patterns!
      each_node(tree) { |node, _| targets_of(node).each { |target| mark_pattern(target) } }
    end

    # Return the code that a node assigns to: the left of an assignment, a
    # parameter's name, a `catch`'s parameter, a loop's variables or the key
    # of a class's member.
    def targets_of(node)
      case node.type
      when "assignment" then [node[:left]]
      when "parameter" then [node[:name]]
      when "catch_clause" then [node[:parameter]].compact
      when "for_expression" then node.children.select { |child| child.field == "variable" }
      when "class_member" then [node[:key]]
      else []
      end
    end

    def mark_pattern(node)
      case node.type
      when "array" then node.type = "array_pattern"
      when "object" then node.type = "object_pattern"
      when "splat" then node.type = "rest_pattern"
      when "pair"
        node.type = "pair_pattern"
        return mark_pattern(node[:value])
      else return
      end
      node.named_children.each { |child| mark_pattern(child) }
    end

    # Mark each `key: value` directly in a class's body as a member of the
    # class, so that representation/spec.rb can list it with the other
    # definitions. A `constructor` keeps its name, because CoffeeScript
    # makes it the class's constructor.
    # class A then area: -> 1  ->  (class A (block (object (class_member area (function ...)))))
    def mark_class_members!
      each_node(tree) do |node, _|
        next unless node.type == "class" && node[:body]

        node[:body].named_children.select { |child| child.type == "object" }.each do |object|
          object.named_children.each do |pair|
            pair.type = "class_member" if pair.type == "pair" && pair[:key].text != "constructor"
          end
        end
      end
    end

    # Mark each property that an assignment, a parameter or a class sets on
    # `this`, so that representation/spec.rb can list it with the other
    # definitions.
    # @count = 0  ->  (assignment (this_property this count) 0)
    # constructor: (@count) ->  ->  (parameter (this_property this count))
    # @create: ->  ->  (class_member (this_property this create) (function ->))
    def mark_properties_set_on_this!
      each_node(tree) do |node, _|
        targets_of(node).each do |target|
          target.type = "this_property" if target.type == "member_expression" && target[:object].type == "this"
        end
      end
    end

    # Mark each property that an assignment sets on a prototype, so that
    # representation/spec.rb can list it with the other definitions.
    # A::area = -> 1  ->  (assignment (prototype_property (member_expression A prototype) area) (function ...))
    def mark_properties_set_on_a_prototype!
      prototype = '(member_expression property: (property_identifier "prototype"))'
      captured(tree, "(assignment left: (member_expression object: #{prototype}) @name)").each do |member|
        member.type = "prototype_property"
      end
    end
  end
end
