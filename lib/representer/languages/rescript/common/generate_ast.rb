# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that the ReScript compiler's parser (its Parsetree) gives.
module Representer::Languages::Rescript::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Keep `rec`, `mutable`, `private`, `async`, `export`,
    # `unpack`, `to`, `downto` and `?`, which change what the code means.
    # ReScript's parser reads `when` in a guard as `if`.
    # if a { b } else { c }  ->  (if_expression a b (else_clause c))
    strip_tokens "let", "and", "if", "when", "else", "switch", "for", "in", "while", "try", "catch", "type",
                 "module", "open", "include", "exception", "external", "assert", "lazy", "await", "as",
                 "constraint", "of", "dict", "~", "#", "..."
    strip_tokens "!", only_in: :open_statement
    strip_tokens "..", only_in: [:range_pattern, :extensible_type]
    strip_tokens "<", ">", only_in: [:type_arguments, :type_parameters, :jsx_opening_element,
                                     :jsx_closing_element, :jsx_self_closing_element, :jsx_fragment]
    strip_tokens "/", only_in: [:regex, :jsx_closing_element, :jsx_self_closing_element, :jsx_fragment]

    # Keep `module type`, which declares a module type in place of a module,
    # and the `and` and `await` that change what a module means.
    keep_tokens "type", in: :module_declaration
    keep_tokens "and", in: :module_type_constraint
    keep_tokens "await", in: :module_binding

    # Strip the brackets, separators, arrows and quotes, because they are
    # layout. Keep the `=` that sets a value, and the `.` that says whether
    # an object type is open.
    # f(x, [1, 2])  ->  (call_expression f (arguments x (array 1 2)))
    # switch x { | A => 1 }  ->  (switch_expression x (switch_match A 1))
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", ":", ".", "=", "=>", "|", "\"", "`", "$", "${"
    keep_tokens "=", in: [:mutation_expression, :type_binding, :variant_declaration, :constrain_type, :constrain_module]
    keep_tokens ".", in: [:object, :object_type]

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    # switch (x) { ... }  ->  switch x { ... }
    unwrap :parenthesized_expression,
           :parenthesized_pattern,
           :parenthesized_module_expression,
           :expression_statement

    # Write each number as its value. ReScript reads `1.` and `1e3` as
    # floats, so they stay apart from the integers. A number with a
    # suffix, such as the BigInt `10n`, keeps its text.
    #
    # 1_000  ->  1000
    # 0xFF  ->  255
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
      "\\'" => "'"
    }.freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        write_every_function_parameter_in_brackets!
        write_braces_around_one_expression_as_the_expression!
        give_each_field_of_a_record_pattern_a_node!
        write_punned_fields_and_labels_in_full!
        mark_the_code_that_defines_names!
      end
    end

    private
    ### Values ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same. A template string keeps its own node, because ReScript's
    # parser marks it as different from a string, and its text becomes
    # values between its substitutions.
    #
    # "say \"hi\""  ->  say "hi"
    # "A\x41"  ->  (string "A" \x41)
    # `a ${b}`  ->  (template_string (template_string_content "a " (template_substitution b)))
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        pieces = match.node.named_children
        next literal(string_value(pieces)) if pieces.all? { |piece| read?(piece) }

        runs = pieces.chunk_while { |a, b| read?(a) && read?(b) }
        build(:string, *runs.map { |run| read?(run.first) ? literal(string_value(run)) : leaf(:escape, run.first.text) })
      end
      transform(tree, "(fragment) @fragment") { |match| literal(match.node.text) }
    end

    def read?(piece) = piece.type == "string_fragment" || ESCAPES.key?(piece.text)

    def string_value(pieces) = pieces.sum("") { |piece| ESCAPES.fetch(piece.text, piece.text) }

    ### Functions and blocks ###

    # Write a function's one parameter in brackets, because ReScript's
    # parser gives `x => x` and `(x) => x` the same tree.
    # x => x  ->  (x) => x
    def write_every_function_parameter_in_brackets!
      find_all(tree, "(function parameter: (_) @parameter)").each do |match|
        parameters = build(:formal_parameters, build(:parameter, match[:parameter]))
        match.node.children.map! { |child| child.equal?(match[:parameter]) ? parameters : child }
        match[:parameter].field = nil
        parameters.field = "parameters"
      end
    end

    # Write braces around one expression as the expression, because
    # ReScript's parser gives `x => { x + 1 }` and `x => x + 1` the same
    # tree. The body of a `switch` case is a block too, so `| A => { 1 }`
    # and `| A => 1` are the same.
    # x => { x + 1 }  ->  x => x + 1
    def write_braces_around_one_expression_as_the_expression!
      retype(tree, sequence_expression: :block)
      transform(tree, "(block) @block") do |match|
        statements = match.node.named_children
        next unless statements.one? && statements.first.type == "expression_statement"

        expressions = statements.first.named_children
        expressions.first if expressions.one?
      end
    end

    ### Records and labels ###

    # Give each field of a record pattern a node of its own, which holds the
    # field's name and its pattern, because the grammar gives the names and
    # patterns of all the fields as one list. Write a punned field in full,
    # as ReScript's parser does.
    # {x, y: z}  ->  (record_pattern (record_pattern_field x x) (record_pattern_field y z))
    def give_each_field_of_a_record_pattern_a_node!
      captured(tree, "(record_pattern) @name").each do |pattern|
        entries = pattern.children.reject { |child| ["{", "}"].include?(child.type) }.
          slice_when { |_, child| child.type == "," }.
          map { |entry| entry.reject { |child| child.type == "," } }.
          reject(&:empty?)
        pattern.children.replace(entries.map { |entry| record_pattern_field(entry) })
      end
    end

    # { ?x }  ->  (record_pattern_field "?" name: x pattern: x)
    # { y: Some(z) }  ->  (record_pattern_field name: y pattern: Some(z))
    def record_pattern_field(entry)
      optional = entry.take_while { |child| child.type == "?" }
      name, colon, *pattern = entry.drop(optional.size)
      name = leaf(:property_identifier, text_of(name), field: :name)
      pattern = [leaf(:value_identifier, own_name(name.text))] unless colon
      pattern.find(&:named?).field = "pattern"
      build(:record_pattern_field, *optional, name, *pattern)
    end

    # Write each punned record field and labelled argument in full, as
    # ReScript's parser does.
    # {x}  ->  {x: x}
    # {?x}  ->  {x: ?x}
    # f(~x)  ->  f(~x=x)
    # f(~x?)  ->  f(~x=?x)
    def write_punned_fields_and_labels_in_full!
      captured(tree, "(record_field) @name").each do |field|
        next if field.children.any? { |child| child.type == ":" }

        name = field.named_children.first
        optional = field.children.select { |child| child.type == "?" }
        field.children.replace([name, *optional, leaf(:value_identifier, own_name(name.text))])
      end
      captured(tree, "(labeled_argument !value) @name").each do |argument|
        next if argument.children.any? { |child| child.type == "type_annotation" }

        argument.children << leaf(:value_identifier, argument[:label].text, field: :value)
      end
    end

    # Return the field's own name, without any module path before it.
    # M.x  ->  x
    def own_name(text) = text.split(".").last

    ### Names ###

    # Give the code that defines a name a shape of its own, so that
    # representation/spec.rb can list it in names_are_defined_by.
    def mark_the_code_that_defines_names!
      write_wildcards_as_wildcards!
      wrap_each_type_variable!
      put_each_defined_name_in_a_field!
    end

    # Give `_` a type of its own, because it is never a name, both in a
    # pattern and in a partial application such as `f(_, 1)`.
    # | _ => 0  ->  (switch_match (wildcard) 0)
    def write_wildcards_as_wildcards!
      each_node(tree) { |node, _| node.type = "wildcard" if node.type == "value_identifier" && node.text == "_" }
    end

    # Wrap each type variable in a `type_variable` that holds its name, so
    # that every type variable counts as defined by the solution.
    # array<'a>  ->  (generic_type array (type_arguments (type_variable 'a)))
    def wrap_each_type_variable!
      transform(tree, "(type_identifier) @variable") do |match|
        build(:type_variable, leaf(:type_variable_name, match.node.text)) if match.node.text&.start_with?("'")
      end
    end

    # Put the name in each definition in a field, so that representation/spec.rb
    # can tell it from the code beside it, such as a default value.
    # let f = (~width=size) => ...  ->  (labeled_parameter name: width size)
    # for i in 0 to n { ... }  ->  (for_expression variable: i 0 to n ...)
    def put_each_defined_name_in_a_field!
      {
        labeled_parameter: [:value_identifier, :name],
        external_declaration: [:value_identifier, :name],
        exception_declaration: [:variant_identifier, :name],
        for_expression: [:value_identifier, :variable]
      }.each do |type, (name_type, field)|
        captured(tree, "(#{type}) @name").each do |node|
          node.children.find { |child| child.type == name_type.to_s && child.field.nil? }&.field = field.to_s
        end
      end
    end
  end
end
