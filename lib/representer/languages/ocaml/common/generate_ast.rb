# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that the OCaml compiler's parser (its Parsetree) gives.
module Representer::Languages::OCaml::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Keep `rec`, `mutable`, `private`, `to`, `downto`,
    # `of`, `?` and `!`, which change what the code means.
    # if a then b else c  ->  (if_expression a (then_clause b) (else_clause c))
    strip_tokens "let", "in", "and", "if", "then", "else", "match", "with", "function", "fun", "when", "try",
                 "for", "do", "done", "while", "begin", "end", "type", "module", "struct", "sig", "open",
                 "include", "exception", "external", "val", "assert", "lazy", "as", "class", "object",
                 "method", "inherit", "initializer", "constraint", "new", "~"
    strip_tokens "_", only_in: :any_pattern
    strip_tokens "*", only_in: [:tuple_type, :constructor_declaration]

    # Strip the brackets, separators and arrows, because they are layout.
    # OCaml's parser ignores `;;` between top-level definitions, and the `|`
    # before the first case of a match.
    # f (x) [1; 2]  ->  (application_expression f x (list_expression 1 2))
    # match x with | A -> 1  ->  match x with A -> 1
    strip_tokens "(", ")", "[", "]", "{", "}", "[|", "|]", ";", ";;", ",", ".", ":", "=", "->", "<-", "::", "|"

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. OCaml's parser reads `begin ... end` as brackets too.
    # (a + b) * c  ->  (infix_expression (infix_expression a + b) * c)
    # begin f x end  ->  f x
    unwrap :parenthesized_expression,
           :parenthesized_pattern,
           :parenthesized_module_expression,
           :parenthesized_operator

    # Write a path with one part as the name itself.
    # (value_path (value_name x))  ->  x
    unwrap :value_path,
           :constructor_path,
           :type_constructor_path,
           :field_path,
           :module_path,
           :extended_module_path,
           :module_type_path,
           :class_path

    # Write each number as its value. OCaml reads `1e3` and `1.` as floats,
    # so they stay apart from the integers. A number with a type suffix,
    # such as `10L`, keeps its text.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.  ->  1.0
    numbers_are integer: [:number, :signed_number],
                decimal: [:number, :signed_number]

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
    PIECE = /\\(?:\d{3}|x\h{2}|o[0-3][0-7]{2}|u\{\h+\}|\n[ \t]*|.)|[^\\]+/m

    DEFINED_NAMES = {
      "constructor_declaration" => "constructor_name",
      "field_declaration" => "field_name",
      "value_specification" => "value_name",
      "external" => "value_name",
      "module_binding" => "module_name",
      "module_parameter" => "module_name",
      "module_type_definition" => "module_type_name",
      "class_binding" => "class_name",
      "method_definition" => "method_name",
      "instance_variable_definition" => "instance_variable_name",
      "parameter" => "label_name"
    }.freeze

    def call
      tree.tap do
        write_strings_and_characters_as_values!
        write_local_opens_the_same_way!
        mark_the_code_that_defines_names!
      end
    end

    private
    ### Values ###

    # Turn each string into its value, however it is quoted, and read its
    # escapes. Keep any other escape as a leaf of its own, so it can't make
    # two different strings the same.
    #
    # {|say "hi"|}  ->  "say \"hi\""
    # "a\065"  ->  (string "a" \065)
    def write_strings_and_characters_as_values!
      transform(tree, "(string) @string") do |match|
        content = match.node.named_children.first
        pieces = content ? content.text.scan(PIECE) : []
        next literal(string_value(pieces)) if pieces.all? { |piece| read?(piece) }

        runs = pieces.chunk_while { |a, b| read?(a) && read?(b) }
        build(:string, *runs.map { |run| read?(run.first) ? literal(string_value(run)) : leaf(:escape, run.first) })
      end
      transform(tree, "(quoted_string) @string") do |match|
        literal(match.node.named_children.find { |child| child.type == "quoted_string_content" }&.text.to_s)
      end
      write_characters_as_their_text!
    end

    # Write each character as its text between the quotes, in a node of its
    # own, so that `'a'` stays apart from the string `"a"` and from a value
    # called `a`.
    # 'a'  ->  (character "a")
    def write_characters_as_their_text!
      transform(tree, "(character (character_content) @content)") do |match|
        build(:character, literal(match[:content].text))
      end
    end

    def read?(piece) = !piece.start_with?("\\") || ESCAPES.key?(piece) || piece.match?(LINE_CONTINUATION)

    def string_value(pieces) = pieces.sum("") { |piece| piece.match?(LINE_CONTINUATION) ? "" : ESCAPES.fetch(piece, piece) }

    ### Opens ###

    # Write `let open M in e` as `M.(e)`, because OCaml's parser gives the
    # same tree for both. The open then stays in the code, where it changes
    # which names `e` uses, and only the opens at the top of a module count
    # as imports.
    # let open List in map f xs  ->  List.(map f xs)
    def write_local_opens_the_same_way!
      transform(tree, "(let_expression (open_module) @open body: (_) @body)") do |match|
        opened = match[:open].children.reject { |child| child.type == "open" }
        build(:local_open_expression, *opened, match[:body])
      end
    end

    ### Names ###

    # Give the code that defines a name a shape of its own, so that
    # representation/spec.rb can list it in names_are_defined_by.
    def mark_the_code_that_defines_names!
      write_punned_labels_and_fields_in_full!
      mark_the_variables_in_let_bindings!
      wrap_each_variable_in_a_value_pattern!
      wrap_each_type_variable!
      put_each_defined_name_in_a_field!
    end

    # Write each punned label and record field in full, as OCaml's parser
    # does.
    #
    # let f ~n = n  ->  let f ~n:n = n
    # f ~n  ->  f ~n:n
    # let area { width } = width  ->  let area { width = width } = width
    # { width }  ->  { width = width }
    def write_punned_labels_and_fields_in_full!
      find_all(tree, "(parameter pattern: (value_pattern) @pattern)").each do |match|
        parameter = match.node
        next unless parameter.children.any? { |child| ["~", "?"].include?(child.type) }
        next if parameter.children.any? { |child| child.type == "label_name" }

        parameter.children.insert(parameter.children.index(match[:pattern]), leaf(:label_name, match[:pattern].text))
      end
      captured(tree, "(labeled_argument !expression) @name").each do |argument|
        label = argument.children.find { |child| child.type == "label_name" }
        argument.children << leaf(:value_name, label.text, field: :expression)
      end
      captured(tree, "(field_pattern !pattern) @name").each do |field|
        field.children << leaf(:value_pattern, field_name(field), field: :pattern)
      end
      captured(tree, "(field_expression !body) @name").each do |field|
        field.children << leaf(:value_name, field_name(field), field: :body)
      end
    end

    # Return the field's own name, without any module path before it.
    def field_name(field)
      path = field.named_children.first
      path.leaf? ? path.text : path.named_children.last.text
    end

    # Mark each name in the pattern of a `let` as a variable. The grammar
    # writes a variable there as a `value_name`, and in every other pattern
    # as a `value_pattern`. An operator in brackets is a variable too.
    # let «f» x = ...
    # let («a», «b») = pair
    # let ( «+!» ) a b = ...
    def mark_the_variables_in_let_bindings!
      find_all(tree, "(let_binding pattern: (_) @pattern)").each do |match|
        pattern = match[:pattern]
        each_node(pattern) { |node, _| node.type = "value_pattern" if node.type == "value_name" }
        marked = transform(pattern, "(parenthesized_operator) @operator") { |operator| build(:value_pattern, operator.node) }
        match.node.replace_child(pattern, marked) unless marked.equal?(pattern)
      end
    end

    # Wrap each variable in a pattern in a `value_pattern` that holds its
    # name, as OCaml's parser gives a pattern that holds the name.
    # fun «x» -> x  ->  fun (value_pattern x) -> x
    def wrap_each_variable_in_a_value_pattern!
      transform(tree, "(value_pattern) @pattern") do |match|
        build(:value_pattern, leaf(:value_name, match.node.text)) if match.node.leaf?
      end
    end

    # Wrap each type variable in a `type_variable` that holds its name, so
    # that every type variable counts as defined by the solution.
    # 'a list  ->  (constructed_type (type_variable 'a) list)
    def wrap_each_type_variable!
      transform(tree, "(type_variable) @variable") do |match|
        build(:type_variable, leaf(:type_variable_name, match.node.text)) if match.node.leaf?
      end
    end

    # Put the name in each definition in the field `name`, so that
    # representation/spec.rb can tell it from the types beside it.
    # val area : int -> int  ->  (value_specification name: area (function_type int int))
    def put_each_defined_name_in_a_field!
      each_node(tree) do |node, _|
        name_type = DEFINED_NAMES[node.type]
        node.children.each { |child| child.field ||= "name" if child.type == name_type } if name_type
      end
    end
  end
end
