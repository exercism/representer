# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, with one form for each spelling that R's parser reads the
# same way.
module Representer::Languages::R::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. R's parser reads `\(x)` as `function(x)`.
    # if (x) y else z  ->  (if_statement x y z)
    # \(x) x  ->  (function_definition (parameters (parameter x)) x)
    strip_tokens "function", "\\", "if", "else", "for", "in", "while", "repeat"

    # Strip the brackets, because the node types already show them.
    # f(a)  ->  (call f (arguments (argument a)))
    # m[[1]]  ->  (subset2 m (arguments (argument 1)))
    strip_tokens "(", ")", "{", "}", "[", "]", "[[", "]]"

    # Strip the `=` between a parameter and its default, because the default
    # has a field of its own. Keep it in arguments, where `switch(x, a = , b = 1)`
    # needs it.
    # function(x = 1)  ->  (parameter x 1)
    strip_tokens "=", only_in: :parameter

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (binary_operator (binary_operator a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value. R stores `1`, `1.0` and `0x1` the same
    # way, so they become the same number.
    #
    # 1.50  ->  1.5
    # 1.0  ->  1
    # 0x1F  ->  31
    # 1e3  ->  1000
    numbers_are number: :float,
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
        write_special_operators_as_their_text!
        write_right_assignments_as_left_assignments!
        write_double_stars_as_carets!
        write_missing_arguments_as_empty!
        drop_commas!
        write_pipes_as_calls!
        write_integers_as_values!
        write_strings_as_their_values!
        write_quoted_names_without_backticks!
        write_argument_names_in_quotes_as_names!
        give_assignments_a_type_of_their_own!
        give_each_assigned_field_the_field_name!
      end
    end

    private
    # Write each special operator as its text, because the grammar gives
    # every one the type `special`.
    # a %% b  ->  (binary_operator a %% b)
    # a %in% b  ->  (binary_operator a %in% b)
    def write_special_operators_as_their_text!
      captured(tree, '(binary_operator "special" @name)').each { |operator| operator.type = operator.text }
    end

    # Write each right assignment as a left assignment, because R's parser
    # reads them the same way.
    # 1 -> x  ->  x <- 1
    # 1 ->> x  ->  x <<- 1
    def write_right_assignments_as_left_assignments!
      find_all(tree, '(binary_operator ["->" "->>"] @operator)').each do |match|
        value, operator, target = match.node.children
        operator.type = operator.text = operator.text == "->" ? "<-" : "<<-"
        target.field = "lhs"
        value.field = "rhs"
        match.node.children = [target, operator, value]
      end
    end

    # Write `**` as `^`, because R's parser reads them the same way.
    # 2 ** 3  ->  2 ^ 3
    def write_double_stars_as_carets!
      captured(tree, '(binary_operator "**" @name)').each { |operator| operator.type = operator.text = "^" }
    end

    # Write each argument left out between commas as an empty argument,
    # because its place says which argument the others are.
    # m[, 1]  ->  (subset m (arguments (empty_argument) (argument 1)))
    def write_missing_arguments_as_empty!
      captured(tree, "(arguments (comma)) @name").each do |arguments|
        open, *items, close = arguments.children
        slots = [[]]
        items.each { |item| item.type == "comma" ? slots << [] : slots.last << item }
        arguments.children = [open, *slots.map { |slot| slot.first || build(:empty_argument) }, close]
      end
    end

    # Drop the commas between parameters, because they are layout.
    def drop_commas!
      drop(tree, "(comma)")
    end

    # Write each pipe as the call it makes, because R's parser reads them the
    # same way. The value goes in place of `_`, or else first.
    # x |> f(y)  ->  f(x, y)
    # x |> f(y, z = _)  ->  f(y, z = x)
    def write_pipes_as_calls!
      transform(tree, '(binary_operator lhs: (_) @value "|>" rhs: (call arguments: (arguments) @arguments) @call)') do |match|
        value = match[:value]
        arguments = match[:arguments]
        placeholder = arguments.children.find { |argument| argument.type == "argument" && placeholder?(argument[:value]) }
        if placeholder
          placeholder.replace_child(placeholder[:value], value)
        else
          arguments.children.insert(1, build(:argument, { value: }))
        end
        match[:call]
      end
    end

    def placeholder?(value) = value&.type == "identifier" && value.text == "_"

    # Write each integer as its value, keeping its `L`.
    # 0x1FL  ->  31L
    def write_integers_as_values!
      captured(tree, "(integer) @name").each do |number|
        value = Representer::Engine::Numbers.integer(number.text.chop, separator: "", prefixes: { "0x" => 16 })
        number.text = "#{value}L" if value
      end
    end

    ### Strings ###

    # Turn each string into its value, however it is quoted, and read its
    # escapes. Keep any other escape as a node of its own, so it can't make
    # two different strings the same. A raw string reads no escapes.
    #
    # 'a'  ->  "a"
    # r"(a\n)"  ->  "a\\n"
    # "a\x41"  ->  (string "a" (escape_sequence \x41))
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        raw = match.node[:open].text.match?(/\A[rR]/)
        content = match.node[:content]
        string_node(content ? content_pieces(content, raw:) : [])
      end
    end

    # Return the pieces of a string's content: text, and the escapes that
    # stay as nodes.
    def content_pieces(content, raw:)
      return [content.text] if raw || content.leaf?

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

    # Write each name in backticks without them, because R's parser reads
    # them as the same name.
    # `f`(x)  ->  f(x)
    def write_quoted_names_without_backticks!
      captured(tree, "(identifier /\\A`/) @name").each { |name| name.text = name.text[1...-1] }
    end

    # Write each argument name in quotes as a name, because R's parser
    # reads them the same way.
    # list("a" = 1)  ->  list(a = 1)
    def write_argument_names_in_quotes_as_names!
      transform(tree, "(argument name: (literal) @name)") do |match|
        match.node.tap { match.node.replace_child(match[:name], leaf(:identifier, match[:name].text)) }
      end
    end

    # Give each assignment a type of its own, so that representation/spec.rb can
    # list the names that are assigned to.
    # total <- 0  ->  (assignment total <- 0)
    def give_assignments_a_type_of_their_own!
      find_all(tree, '(binary_operator ["<-" "<<-" "="])').each { |match| match.node.type = "assignment" }
    end

    # Give the field of each `a$b` that is assigned to the field `name`, so
    # that representation/spec.rb can list it with the other names that are
    # assigned to, and leave the fields that are only read alone.
    # robot$«direction» <- "north"
    def give_each_assigned_field_the_field_name!
      captured(tree, "(assignment lhs: (extract_operator) @name)").each do |target|
        target[:rhs].field = "name" if target[:rhs]
      end
    end
  end
end
