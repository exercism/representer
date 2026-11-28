# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Reason's parser gives, which is OCaml's Parsetree.
module Rosetta::Languages::Reasonml::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Keep `rec`, `mutable`, `to`, `downto`, `+=` and
    # `!`, which change what the code means.
    # if (a) { b } else { c }  ->  (if_expression a b c)
    strip_tokens "let", "and", "if", "else", "switch", "try", "for", "in", "while", "fun", "when", "type",
                 "module", "open", "include", "exception", "external", "as", "with", "~", "...", "[%", "^",
                 ".["
    strip_tokens "?", only_in: :ternary_expression

    # Strip the brackets, separators and arrows, because they are layout.
    # Reason's parser ignores the `|` before the first constructor of a
    # type, and reads `->` as the older spelling `|.`. Keep the `=` that
    # sets a value or a label, as `:=` is kept.
    # f(x, [1, 2])  ->  (call_expression f (arguments x (list 1 2)))
    # type t = | A | B  ->  type t = A | B
    # x->f  ->  x |. f
    strip_tokens "(", ")", "[", "]", "{", "}", "[|", "|]", ",", ";", ":", ".", "=", "=>", "|", "->", "|."
    keep_tokens "=", in: [:assignment_expression, :labeled_argument, :labeled_parameter, :labeled_type]

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    # switch (x) { ... }  ->  switch x { ... }
    unwrap :parenthesized_expression,
           :parenthesized_pattern,
           :parenthesized_type,
           :module_expression,
           :module_type

    # Write a path with one part as the name itself.
    # (value_path (value_identifier x))  ->  x
    unwrap :value_path,
           :constructor_path,
           :module_path,
           :type_constructor_path

    # Write each number as its value. Reason reads `1.` and `1e3` as
    # floats, so they stay apart from the integers. A number with a type
    # suffix, such as `10L`, keeps its text.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.  ->  1.0
    numbers_are integer: :number,
                decimal: :number

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\b' => "\b",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'",
      '\ ' => " "
    }.freeze

    # A backslash at the end of a line, with the blanks after it, stands for
    # nothing, so a long string can go on over several lines.
    LINE_CONTINUATION = /\A\\\n[ \t]*\z/

    # Split a string into its escapes and the text between them.
    # "a\065\n"  ->  "a", "\065", "\n"
    PIECE = /\\(?:\d{3}|x\h{2}|o[0-3][0-7]{2}|\n[ \t]*|.)|[^\\]+/m

    STATEMENTS = ["let_declaration", "type_declaration", "module_declaration", "open_statement",
                  "exception_declaration"].freeze

    # {j|a|j}  ->  "j", "a"
    QUOTED_STRING = /\A\{([a-z]*)\|(.*)\|\1\}\z/m

    def call
      tree.tap do
        write_strings_as_their_values!
        write_operators_in_brackets_as_operators!
        write_every_function_parameter_in_brackets!
        write_braces_around_one_expression_as_the_expression!
        write_curried_functions_as_one_function!
        write_punned_labels_and_fields_in_full!
        mark_the_code_that_defines_names!
      end
    end

    private
    ### Values ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same. Reason's parser reads `{|...|}` as a string with no
    # escapes. A string quoted as `{j|...|j}` or `{js|...|js}` keeps its
    # delimiter, because BuckleScript reads those as Unicode strings, and
    # reads the `$` in a `{j|...|j}` string as a variable.
    #
    # "say \"hi\""  ->  say "hi"
    # {|say "hi"|}  ->  say "hi"
    # "a\065"  ->  (string "a" \065)
    # {j|Hi $name|j}  ->  (quoted_string j "Hi $name")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        text = match.node.text
        next quoted_string(text) if text.start_with?("{")

        pieces = text[1...-1].scan(PIECE)
        next literal(string_value(pieces)) if pieces.all? { |piece| read?(piece) }

        runs = pieces.chunk_while { |a, b| read?(a) && read?(b) }
        build(:string, *runs.map { |run| read?(run.first) ? literal(string_value(run)) : leaf(:escape, run.first) })
      end
    end

    def quoted_string(text)
      delimiter, content = text.match(QUOTED_STRING).captures
      return literal(content) if delimiter.empty?

      build(:quoted_string, leaf(:delimiter, delimiter), literal(content))
    end

    def read?(piece) = !piece.start_with?("\\") || ESCAPES.key?(piece) || piece.match?(LINE_CONTINUATION)

    def string_value(pieces) = pieces.sum("") { |piece| piece.match?(LINE_CONTINUATION) ? "" : ESCAPES.fetch(piece, piece) }

    # Write an operator in brackets as the operator, without the brackets
    # and spaces, so that it matches the operator where it is used.
    # List.fold_left(( + ), 0)  ->  (call_expression List.fold_left (arguments + 0))
    def write_operators_in_brackets_as_operators!
      transform(tree, "(parenthesized_operator) @operator") do |match|
        leaf(:operator, match.node.text.delete_prefix("(").delete_suffix(")").strip)
      end
    end

    ### Functions and blocks ###

    # Write a function's one parameter in brackets, because Reason's parser
    # gives `x => x` and `(x) => x` the same tree.
    # x => x  ->  (x) => x
    def write_every_function_parameter_in_brackets!
      find_all(tree, "(function parameter: (_) @parameter)").each do |match|
        parameters = build(:parameters, build(:parameter, match[:parameter]))
        match.node.children.map! { |child| child.equal?(match[:parameter]) ? parameters : child }
        match[:parameter].field = nil
        parameters.field = "parameters"
      end
    end

    # Write braces around one expression as the expression, because
    # Reason's parser gives `x => { x + 1 }` and `x => x + 1` the same
    # tree. The body of a `switch` case is a block too, so `| A => { 1 }`
    # and `| A => 1` are the same.
    # x => { x + 1 }  ->  x => x + 1
    def write_braces_around_one_expression_as_the_expression!
      retype(tree, sequence: :block)
      transform(tree, "(block) @block") do |match|
        statements = match.node.named_children
        statements.first if statements.one? && !STATEMENTS.include?(statements.first.type)
      end
    end

    # Write a function that returns a function as one function of all the
    # parameters, because Reason's functions are curried, and its parser
    # gives `(a, b) => e` and `a => b => e` the same tree. A return type on
    # the outer function stays where it is.
    # a => b => a + b  ->  (a, b) => a + b
    def write_curried_functions_as_one_function!
      curried = "(function !return_type parameters: (parameters (_)) body: (function parameters: (parameters (_))) @inner)"
      find_all(tree, curried).reverse_each do |match|
        outer = match.node
        inner = match[:inner]
        outer[:parameters].children.concat(inner[:parameters].named_children)
        outer.children.replace([outer[:parameters], *inner.children.reject { |child| child.equal?(inner[:parameters]) }])
      end
    end

    ### Records and labels ###

    # Write each punned label and record field in full, as Reason's parser
    # does.
    #
    # let f = (~n) => n  ->  let f = (~n as n) => n
    # f(~n)  ->  f(~n=n)
    # f(~n?)  ->  f(~n=?n)
    # {name, age: 1}  ->  {name: name, age: 1}
    # let {name} = person  ->  let {name: name} = person
    def write_punned_labels_and_fields_in_full!
      captured(tree, "(labeled_parameter) @name").each do |parameter|
        next if parameter.children.any? { |child| child.type == "as" }

        label = parameter.children.find { |child| child.type == "label" }
        parameter.children.insert(parameter.children.index(label) + 1, leaf(:value_pattern, label.text))
      end
      captured(tree, "(labeled_argument) @name").each do |argument|
        next if argument.children.any? { |child| [":", "="].include?(child.type) }

        label = argument.children.find { |child| child.type == "label" }
        argument.children.insert(argument.children.index(label) + 1, token("="))
        argument.children << leaf(:value_identifier, label.text)
      end
      captured(tree, "(record_field) @name").each do |field|
        next if field.children.any? { |child| child.type == ":" }

        field.children << leaf(:value_identifier, own_name(field))
      end
      captured(tree, "(record_pattern_field) @name").each do |field|
        next if field.children.any? { |child| child.type == ":" }

        field.children << leaf(:value_pattern, own_name(field))
      end
    end

    # Return the field's own name, without any module path before it.
    # M.x  ->  x
    def own_name(field) = field.children.find { |child| child.type == "field_identifier" }.text

    ### Names ###

    # Give the code that defines a name a shape of its own, so that
    # representation/spec.rb can list it in names_are_defined_by.
    def mark_the_code_that_defines_names!
      mark_operator_definitions_as_variables!
      wrap_each_variable_in_a_value_pattern!
      wrap_each_type_variable!
      put_each_defined_name_in_a_field!
    end

    # Mark an operator in the pattern of a `let` as a variable, because the
    # `let` defines it.
    # let (>>) = (f, g, x) => g(f(x))  ->  (let_binding pattern: (value_pattern >>) ...)
    def mark_operator_definitions_as_variables!
      find_all(tree, "(let_binding pattern: (operator) @operator)").each do |match|
        match.node.replace_child(match[:operator], build(:value_pattern, match[:operator]))
      end
    end

    # Wrap each variable in a pattern in a `value_pattern` that holds its
    # name, as Reason's parser gives a pattern that holds the name.
    # (x) => x  ->  (parameter (value_pattern x)) => x
    def wrap_each_variable_in_a_value_pattern!
      transform(tree, "(value_pattern) @pattern") do |match|
        build(:value_pattern, leaf(:value_identifier, match.node.text)) if match.node.leaf?
      end
    end

    # Wrap each type variable in a `type_variable` that holds its name, so
    # that every type variable counts as defined by the solution.
    # list('a)  ->  (applied_type list (type_variable 'a))
    def wrap_each_type_variable!
      transform(tree, "(type_variable) @variable") do |match|
        build(:type_variable, leaf(:type_variable_name, match.node.text)) if match.node.leaf?
      end
    end

    # Put the name in each definition in a field, so that
    # representation/spec.rb can tell it from the code beside it, such as a
    # type or a default value.
    # type shape = Circle(float)  ->  (variant_declaration name: Circle (variant_parameters float))
    # module Make = (X: S) => { ... }  ->  (functor parameter: X S ...)
    def put_each_defined_name_in_a_field!
      {
        labeled_parameter: [:label, :label],
        record_type_field: [:field_identifier, :name],
        variant_declaration: [:constructor, :name],
        exception_declaration: [:constructor, :name]
      }.each do |type, (name_type, field)|
        captured(tree, "(#{type}) @name").each do |node|
          node.children.find { |child| child.type == name_type.to_s }.field = field.to_s
        end
      end
      captured(tree, "(functor) @name").each do |functor|
        functor.children.each { |child| child.field = "parameter" if child.type == "module_identifier" }
      end
    end
  end
end
