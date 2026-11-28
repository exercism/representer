# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, which reads each spelling as Lean's parser does.
module Inspector::Languages::Lean::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Lean reads `λ` the same as `fun`, `↦` the same as
    # `=>`, and `where` after `inductive` the same as no `where`. Keep the
    # kind of each definition, such as `def` or `theorem`.
    # if a then b else c  ->  (if_expression a b c)
    strip_tokens "namespace", "section", "end", "open", "import", "variable", "universe", "set_option",
                 "instance", "inductive", "where", "extends", "deriving", "termination_by", "decreasing_by",
                 "if", "then", "else", "match", "with", "do", "for", "in", "while", "repeat", "return", "try",
                 "catch", "finally", "let", "have", "show", "from", "by", "fun", "λ", "=>", "↦",
                 "syntax", "declare_syntax_cat", "macro_rules", "macro", "notation"

    # Strip the brackets, separators and marks, because they are layout or
    # the node types already show them. Lean reads `{{` the same as `⦃`.
    # f [a, b]  ->  (application f (list a b))
    strip_tokens "(", ")", "[", "]", "{", "}", "#[", "⟨", "⟩", "⦃", "⦄", "{{", "}}", "@[", "@", "↑",
                 ",", ";", ":", ":=", "|", "//", "\"", "·", "."

    # Keep the `|` and `,` between a match's patterns, because `| a, b`
    # matches two values and `| a | b` gives two patterns for one.
    keep_tokens "|", ",", in: :match_alternative

    # Keep the `:` that names a proof and the `:` of a range, because
    # `if h : a then b` and `if h then a else b` are different, and so are
    # `[a:b]` and `[:a:b]`. Keep the `let` of an `if let` for the same reason.
    keep_tokens ":", in: [:if_expression, :for_statement, :while_statement, :match_discriminant, :range]
    keep_tokens "let", in: :if_expression

    # Keep the `with` of a structure instance, because `{ p with }` copies
    # `p` and `{ p }` sets the field `p`.
    keep_tokens "with", in: :structure_instance

    # Keep the brackets that group the parts of new syntax, because
    # `("a" "b")*` and `"a" "b"*` repeat different parts.
    keep_tokens "(", ")", in: [:syntax_command, :macro]

    # Keep the arrow of a `let` and an assignment, because `x := v` binds
    # the value and `x ← v` runs it first.
    keep_tokens ":=", "←", "<-", in: [:let_statement, :assignment]

    # Write each number as its value. Lean reads `1` as a natural number and
    # `1.0` as a decimal, so the two stay apart.
    # 0x1F  ->  31
    # 1e3  ->  1000.0
    numbers_are integer: :number,
                decimal: :number

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Unwrap a block that holds one statement, because Lean reads
    # code on its own indented line the same as code on the same line.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    # def f :=\n  x  ->  def f := x
    # by\n  omega  ->  by omega
    unwrap :parenthesized_expression, :block, :tactic_block

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\\\\' => "\\",
      '\"' => '"'
    }.freeze

    # Lean reads each of these spellings of a token the same as the first.
    SPELLINGS = {
      "<-" => "←",
      "->" => "→",
      "forall" => "∀",
      "exists" => "∃"
    }.freeze

    # These constructors are in scope in every file, so a pattern that
    # names one matches the constructor and binds no variable.
    CONSTRUCTORS = ["none", "true", "false"].freeze

    DOT_SCOPES = ["parenthesized_expression", "dot_function", "tuple", "type_ascription"].freeze

    def call
      tree.tap do
        drop_the_ends_at_the_end_of_the_file!
        read_the_other_ends_as_nodes!
        write_strings_as_their_values!
        write_each_token_one_way!
        split_dotted_names!
        mark_the_code_that_defines_names!
        mark_the_brackets_around_dot_functions!
      end
    end

    private
    ### Layout ###

    # Drop the `end` lines at the end of the file, because Lean closes every
    # namespace and section at the end of the file.
    # namespace Leap ... end Leap  ->  (namespace Leap) ...
    def drop_the_ends_at_the_end_of_the_file!
      tree.children.pop while tree.children.last&.type == "end"
    end

    # Read each other `end` as a node that holds its name. The grammar's
    # `end` node has the same name as the `end` token, so the tree gives it
    # the text of a leaf as well as its children.
    # end Helpers  ->  (end Helpers)
    def read_the_other_ends_as_nodes!
      tree.children.each { |child| child.text = nil if child.type == "end" && child.children.any? }
    end

    ### Values ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same. Keep each interpolation as a node between the parts, and
    # keep the `s!` or `f!` that starts it. A character keeps its quotes, so
    # `'a'` and `"a"` stay apart.
    # "say \"hi\""  ->  say "hi"
    # s!"a{b}c"  ->  (interpolated_string s! "a" (interpolation b) "c")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") { |match| string(match.node.text[1..-2].scan(/\\.|[^\\]+/m)) }

      transform(tree, "(interpolated_string) @string") do |match|
        opener, *parts = match.node.children
        pieces = parts.flat_map { |part| ["string_content", "escape_sequence"].include?(part.type) ? [part.text] : [part] }
        runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
        values = runs.map { |run| run.first.is_a?(String) ? string(run) : run.first }
        build(:interpolated_string, token(opener.text.delete_suffix("\"")), *values)
      end
    end

    # The value of a string made of these pieces of text, with the escapes
    # it doesn't read as leaves of their own.
    def string(pieces)
      return literal(string_value(pieces)) if pieces.all? { |piece| read?(piece) }

      runs = pieces.chunk_while { |a, b| read?(a) && read?(b) }
      build(:string, *runs.map { |run| read?(run.first) ? literal(string_value(run)) : leaf(:escape, run.first) })
    end

    def read?(piece) = !piece.start_with?("\\") || ESCAPES.key?(piece)

    def string_value(pieces) = pieces.sum("") { |piece| ESCAPES.fetch(piece, piece) }

    ### Tokens ###

    # Write each token that Lean reads in two spellings in one of them.
    # x <- f  ->  x ← f
    # forall n, p n  ->  ∀ n, p n
    def write_each_token_one_way!
      each_node(tree) do |node, _|
        next unless !node.named? && SPELLINGS.key?(node.type)

        node.type = node.text = SPELLINGS[node.type]
      end
    end

    ### Brackets ###

    # Mark the brackets around each `·` as a `dot_function`, so that they
    # stay. Lean reads the code inside the nearest brackets around a `·` as
    # a function, so `(· + 1)` is a function and `((·) + 1)` isn't.
    # (· + 1)  ->  (dot_function (binary_expression (cdot) + 1))
    def mark_the_brackets_around_dot_functions!
      captured(tree, "(parenthesized_expression) @name").each do |brackets|
        brackets.type = "dot_function" if holds_a_dot?(brackets)
      end
    end

    def holds_a_dot?(node)
      node.named_children.any? do |child|
        child.type == "cdot" || (!DOT_SCOPES.include?(child.type) && holds_a_dot?(child))
      end
    end

    ### Names ###

    # Split each dotted name into its parts, so that each part can be
    # renamed on its own. Lean reads `xs.length` as the field `length` of
    # the local name `xs`, and `List.length` as `length` in the namespace
    # `List`.
    # xs.length  ->  (dotted_name xs length)
    def split_dotted_names!
      transform(tree, "(identifier) @name") do |match|
        parts = match.node.text.split(".")
        next nil if parts.one?

        build(:dotted_name, *parts.map { |part| leaf(:identifier, part) })
      end
    end

    # Give the code that defines a name a shape of its own, so that
    # representation/spec.rb can list it in names_are_defined_by.
    def mark_the_code_that_defines_names!
      put_the_namespaces_of_definitions_beside_their_names!
      mark_the_names_of_local_functions!
      mark_the_variables_that_patterns_bind!
    end

    # Put the parts of a dotted name in a definition beside each other, so
    # that the last part is the name it defines and the others are the
    # namespaces it sits in.
    # def Clock.add  ->  (definition def namespace: Clock name: add)
    def put_the_namespaces_of_definitions_beside_their_names!
      captured(tree, "[(definition name: (dotted_name) @name) (where_declaration name: (dotted_name) @name)]").each do |name|
        *namespaces, last = name.children
        namespaces.each { |part| part.field = "namespace" }
        last.field = "name"
        parent = find_parent(name)
        parent.children = parent.children.flat_map { |child| child.equal?(name) ? name.children : [child] }
      end
    end

    # Read a `let` of a name with arguments as a local function, as Lean
    # does, unless it has a `|` for the values that don't match. The name is
    # then the function it defines, and the arguments are its parameters.
    # let go n := ...  ->  (let_statement name: go parameter: n ...)
    # let some x := v | none  ->  `some x` is a pattern
    def mark_the_names_of_local_functions!
      captured(tree, "(let_statement pattern: (_) @name !alternative)").each do |pattern|
        let = find_parent(pattern)
        case pattern.type
        when "identifier"
          pattern.field = "name"
        when "application"
          function = pattern["function"]
          next unless function.type == "identifier"

          function.field = "name"
          arguments = arguments_of(pattern)
          arguments.each { |argument| argument.field = "parameter" }
          let.children = let.children.flat_map { |child| child.equal?(pattern) ? [function, *arguments] : [child] }
        end
      end
    end

    # Mark each name that a pattern or a parameter binds as a
    # `variable_pattern`. A pattern binds every name in it, apart from the
    # function of an application, which is a constructor, a dotted name, and
    # the constructors in CONSTRUCTORS.
    # def area «width» «height» := ...
    # | some «x» => x
    # fun («a», «b») => a + b
    # for «x» in xs do
    def mark_the_variables_that_patterns_bind!
      each_node(tree) do |node, _|
        pattern_roots(node).each { |root| bind(node, root) }
      end
    end

    def pattern_roots(node)
      case node.type
      when "definition", "where_declaration", "constructor", "structure", "inductive", "let_statement", "fun"
        node.children.select { |child| ["parameter", "pattern"].include?(child.field) }
      when "match_alternative", "for_statement", "if_expression", "catch_clause"
        node.children.select { |child| child.field == "pattern" }
      when "quantifier" then node.named_children.reject { |child| child.field == "body" }
      when "termination_by" then node.named_children.reject { |child| child.field == "measure" }
      else []
      end
    end

    def bind(parent, node)
      case node.type
      when "identifier"
        parent.replace_child(node, build(:variable_pattern, node)) unless CONSTRUCTORS.include?(node.text)
      when "application" then arguments_of(node).each { |argument| bind(node, argument) }
      when "type_ascription", "field_assignment" then bind(node, node["value"])
      when "named_pattern" then bind(node, node["pattern"])
      when "dotted_name", "explicit_binder", "implicit_binder", "instance_binder", "strict_implicit_binder" then nil
      else node.named_children.each { |child| bind(node, child) }
      end
    end

    def arguments_of(application) = application.children.select { |child| child.field == "argument" }

    def find_parent(target)
      each_node(tree) { |node, parent| return parent if node.equal?(target) }
    end
  end
end
