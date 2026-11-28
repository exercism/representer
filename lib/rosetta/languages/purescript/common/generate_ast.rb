# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that the PureScript compiler's parser gives.
module Rosetta::Languages::PureScript::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Keep `ado`, which differs from `do`, the `newtype`
    # of `derive newtype instance`, and the fixity of an operator.
    # if a then b else c  ->  (exp_if a b c)
    strip_tokens "import", "as", "hiding", "case", "of", "let", "in", "if", "then", "do", "\\", "derive",
                 "instance", "forall", "∀", "_", "@"
    strip_tokens "module", only_in: :purescript
    strip_tokens "data", only_in: :data
    strip_tokens "newtype", only_in: :newtype
    strip_tokens "type", only_in: :type_alias
    strip_tokens "class", only_in: :class_declaration
    strip_tokens "else", only_in: :exp_if
    strip_tokens "-", only_in: [:exp_negation, :pat_negation]

    # Strip the brackets, separators and arrows, because they are layout.
    # The compiler reads the Unicode spellings the same as the ASCII ones.
    # f [a, b]  ->  (exp_apply f (exp_array a b))
    # \x → x  ->  (exp_lambda (pat_name x) x)
    strip_tokens "(", ")", "[", "]", "{", "}", ";", "|", "=", ":", "::", "∷", "->", "→", "<-", "←", "=>", "⇒",
                 "<=", "⇐", "`", ".", ".."

    # Unwrap the nodes that only hold a name or a value, because the
    # compiler's parser gives the name or value itself.
    # f 1  ->  (exp_apply f 1)
    unwrap :exp_name, :exp_literal, :pat_literal

    # Write each number as its value. PureScript reads `1` as an Int and
    # `1.0` as a Number, so the two stay apart.
    #
    # 0xFF  ->  255
    # 1_000  ->  1000
    numbers_are integer: :integer,
                decimal: :number,
                prefixes: { "0x" => 16 }

    ESCAPES = {
      '\n' => "\n",
      '\r' => "\r",
      '\t' => "\t",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'"
    }.freeze

    UNICODE_OPERATORS = { "→" => "->", "⇒" => "=>" }.freeze

    BRACKETS = ["exp_parens", "pat_parens", "type_parens"].freeze

    OPERATOR_EXPRESSIONS = ["exp_infix", "pat_infix", "type_infix", "exp_section_left", "exp_section_right"].freeze

    GROUPED_BY_BRACKETS = ["exp_infix", "pat_infix", "type_infix", "exp_negation"].freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        write_booleans_as_values!
        write_unicode_type_operators_as_ascii!
        drop_the_commas_and_wheres!
        write_record_puns_in_full!
        unwrap_brackets_that_only_group!
        mark_the_code_that_defines_names!
      end
    end

    private
    ### Values ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same. A triple-quoted string has no escapes. A character keeps
    # its quotes, so `'a'` and `"a"` stay apart.
    #
    # "say \"hi\""  ->  say "hi"
    # """a\n"""  ->  a\n
    # "a\x41"  ->  (string "a" \x "41")
    def write_strings_as_their_values!
      transform(tree, "(triple_quote_string) @string") { |match| literal(match.node.text[3..-4]) }
      transform(tree, "(string) @string") do |match|
        pieces = match.node.text[1..-2].scan(/\\.|[^\\]+/m)
        next literal(string_value(pieces)) if pieces.all? { |piece| read?(piece) }

        runs = pieces.chunk_while { |a, b| read?(a) && read?(b) }
        build(:string, *runs.map { |run| read?(run.first) ? literal(string_value(run)) : leaf(:escape, run.first) })
      end
    end

    def read?(piece) = !piece.start_with?("\\") || ESCAPES.key?(piece)

    def string_value(pieces) = pieces.sum("") { |piece| ESCAPES.fetch(piece, piece) }

    # Write `true` and `false` as booleans, in a pattern as well as in an
    # expression, because PureScript reads them as keywords. The grammar
    # reads them as variables, so a pattern would define them as names.
    # Just «true» <- f x
    def write_booleans_as_values!
      each_node(tree) do |node, _|
        node.type = "boolean" if node.type == "variable" && ["true", "false"].include?(node.text)
      end
      unwrap(tree, "(pat_name (boolean))")
    end

    ### Layout ###

    # Write the Unicode arrows in types as the ASCII ones, because the
    # compiler reads them the same.
    # Int → Int  ->  Int -> Int
    def write_unicode_type_operators_as_ascii!
      each_node(tree) do |node, _|
        node.text = UNICODE_OPERATORS.fetch(node.text, node.text) if node.type == "type_operator"
      end
    end

    # Drop the commas between items and the `where` before declarations,
    # because the grammar gives them as nodes of their own.
    # [a, b]  ->  (exp_array a b)
    def drop_the_commas_and_wheres!
      drop(tree, "[(comma) (where)]")
    end

    # Write each record pun in full, because the compiler's parser reads
    # `{ x }` as `{ x: x }`, in a record and in a pattern.
    #
    # { x }  ->  { x: x }
    def write_record_puns_in_full!
      transform(tree, "(record_field (field_pun) @pun)") do |match|
        name = match[:pun].text
        build(:record_field, leaf(:field_name, name), build(:field_value, leaf(:variable, name)))
      end
      each_node(tree) do |node, _|
        next unless node.type == "pat_field" && node.named_children.one?

        attach(node, build(:pat_name, leaf(:variable, node.named_children.first.text)))
      end
    end

    ### Brackets ###

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Keep the brackets around an operator expression or a
    # negation inside an operator expression or an operator section. The
    # grammar reads every chain of operators from the left, whatever the
    # operators' fixity, so only the brackets show the grouping.
    #
    # f (g x)  ->  (exp_apply f (exp_apply g x))
    # (a + b) * c keeps its brackets
    # ((a + b) * _) keeps its brackets
    # a + (-b) keeps its brackets
    def unwrap_brackets_that_only_group!
      each_node(tree) do |node, _|
        node.children.dup.each do |child|
          inner = child
          inner = inner.named_children.first while only_groups?(node, inner)
          node.replace_child(child, inner) unless inner.equal?(child)
        end
      end
    end

    def only_groups?(parent, child)
      return false unless BRACKETS.include?(child.type) && child.named_children.one?

      inner = child.named_children.first
      !(OPERATOR_EXPRESSIONS.include?(parent.type) && GROUPED_BY_BRACKETS.include?(inner.type))
    end

    ### Names ###

    # Give the code that defines a name a shape of its own, so that
    # representation/spec.rb can list it in names_are_defined_by.
    def mark_the_code_that_defines_names!
      # Write a constructor in a pattern as the constructor, as the
      # compiler's parser does, so that only a variable in a pattern
      # defines a name.
      # case m of «Just» x -> x
      unwrap(tree, "(pat_name (constructor))")

      # Mark the name of the class in a class declaration as a
      # `class_head_name`, apart from the classes that constraints use.
      # class «Shape» a where
      captured(tree, "(class_head (class_name) @name)").each { |name| name.type = "class_head_name" }

      # Mark each type variable that a type uses as a `type_var`. Type
      # variables are always local, so each one is a name the solution
      # defines, in an instance head as well as under a `forall`.
      # instance showTree :: Show «a» => Show (Tree «a»)
      captured(tree, "(type_name (type_variable)) @name").each { |name| name.type = "type_var" }

      # Mark the operator that an operator declaration defines. Leave the
      # function it names, which the solution may not define.
      # infixl 6 add as «+++»
      captured(tree, "(operator_declaration (operator) @name)").each { |name| name.field = "operator" }

      # Leave the names of the methods in an instance, because the class
      # defines them. If the solution defines the class, its signatures
      # define the names.
      # instance showShape :: Show Shape where «show» _ = "shape"
      captured(tree, "(class_instance (function name: (_) @name))").each { |name| name.field = "method" }
    end
  end
end
