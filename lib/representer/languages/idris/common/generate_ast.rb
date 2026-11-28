# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, which reads each spelling as Idris's parser does.
module Representer::Languages::Idris::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Idris reads `Show a where` the same as
    # `implementation Show a where`, and `\ case` the same as `\case`.
    # if a then b else c  ->  (exp_if a (exp_then b) (exp_else c))
    strip_tokens "module", "import", "data", "record", "constructor", "interface", "implementation", "namespace",
                 "mutual", "if", "then", "else", "case", "of", "let", "in", "do", "with", "rewrite", "%default",
                 "\\", "\\case", "`"

    # Strip the brackets, separators and arrows, because they are layout or
    # the node types already show them. Idris reads explicit braces and
    # semicolons the same as indentation, and `←` the same as `<-`. Keep
    # `:=`, `$=`, `|` and the arrows of a type, which tell programs apart.
    # f [a, b]  ->  (exp_name f) (exp_list a , b)
    strip_tokens "(", ")", "[", "]", "{", "}", "[|", "|]", ";", "\n", "", "=", "=>", "⇒", "<-", "←", "\\{"

    # Keep the arrows in a type, because `Eq a => a` and `Eq a -> a` are
    # different types.
    keep_tokens "=>", "⇒", in: :arrow_separator

    # Write each number as its value. Idris reads `1` as any number and
    # `1.0` as a Double, so the two stay apart.
    # 0x1F  ->  31
    # 1.0e3  ->  1000.0
    numbers_are integer: :integer,
                decimal: :number,
                prefixes: { "0x" => 16, "0o" => 8, "0b" => 2 }

    # Unwrap the nodes around a literal, because the literal's type already
    # shows what it is.
    # (literal 1)  ->  1
    unwrap :literal, :pat_literal

    # Unwrap the names of interfaces and records, so that the name sits in
    # its definition's `name` field.
    # (interface_name Sized)  ->  Sized
    unwrap :interface_name, :record_name

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\\\\' => "\\",
      '\"' => '"'
    }.freeze

    BRACKETS = ["exp_parens", "pat_parens"].freeze
    APPLICATIONS = ["patterns", "implementation_head"].freeze
    SEPARATORS = ["comma", "tuple_operator", "arrow_separator", "colon"].freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        mark_the_code_that_defines_names!
        drop_the_colons_and_wheres!
        write_brackets_in_types_as_expressions!
        unwrap_brackets_that_only_group!
      end
    end

    private
    ### Values ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same. Keep each interpolation as a node between the parts. A
    # character keeps its quotes, so `'a'` and `"a"` stay apart.
    # "say \"hi\""  ->  say "hi"
    # "a\{b}c"  ->  (string "a" (interpolation b) "c")
    def write_strings_as_their_values!
      transform(tree, "[(string) (pat_string)] @string") do |match|
        parts = match.node.children.reject { |child| ["\"", "\\{", "}"].include?(child.type) }
        values = parts.flat_map { |part| part.type == "fragment" ? string_parts(part.text) : [part] }
        values = values.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }.map do |run|
          run.first.is_a?(String) ? literal(run.join) : run.first
        end
        next literal("") if values.empty?
        next values.first if values.one? && values.first.quoted

        build(:string, *values)
      end
    end

    # Split the text of a string into its value, as Strings, and the escapes
    # it doesn't read, as leaves.
    def string_parts(text)
      text.scan(/\\.|[^\\]+/m).map do |piece|
        next piece unless piece.start_with?("\\")

        ESCAPES.fetch(piece) { leaf(:escape, piece) }
      end
    end

    ### Names ###

    # Give the code that defines a name a shape of its own, so that
    # representation/spec.rb can list it in names_are_defined_by.
    def mark_the_code_that_defines_names!
      mark_the_constructors_in_patterns!
      mark_the_constructors_of_data_types!
      mark_the_type_variables!
    end

    # Mark each capitalised name in a pattern as a `pat_constructor`, because
    # Idris reads it as a constructor, such as `Nothing`, and only a lower
    # case name as a variable that the pattern binds.
    # f «Nothing» = 0
    def mark_the_constructors_in_patterns!
      captured(tree, "(pat_name (caname)) @name").each { |name| name.type = "pat_constructor" }
    end

    # Mark the name at the start of each constructor of a data type as a
    # `data_constructor`. The constructors follow `=` and `|`.
    # data Shape = «Circle» Double | «Square» Double
    def mark_the_constructors_of_data_types!
      captured(tree, "(data) @name").each do |data|
        data.children.each_cons(2) do |before, child|
          next unless ["=", "|"].include?(before.type) && !before.named? && child.type == "exp_name"

          child.type = "data_constructor"
        end
      end
    end

    # Mark each lower case name in a type that isn't the head of an
    # application as a `type_variable`, because Idris binds such a name as
    # an implicit argument. The types are in signatures and in the heads of
    # interfaces.
    # length : List «a» -> Nat
    # index : Vect «n» «a» -> «a»
    def mark_the_type_variables!
      captured(tree, "[(signature) (interface_head)] @name").each do |type|
        each_node(type) do |node, parent|
          next unless node.type == "exp_name" && node.named_children.map(&:type) == ["loname"]
          next if applied?(node, parent)

          node.type = "type_variable"
        end
      end
    end

    # Whether the name is the head of an application, such as `length` in
    # `Vect (length xs) a`, which is a function and not a variable.
    def applied?(node, parent)
      siblings = parent.named_children
      index = siblings.index { |sibling| sibling.equal?(node) }
      before = index.zero? ? nil : siblings[index - 1]
      after = siblings[index + 1]
      (before.nil? || separator?(before)) && !after.nil? && !separator?(after)
    end

    def separator?(node) = SEPARATORS.include?(node.type) || ["operator", "auto", "quantity"].include?(node.type)

    ### Layout ###

    # Drop the colon of each signature and the `where` before a block of
    # declarations, because they sit in a fixed place.
    # area : Shape -> Double  ->  (signature area (exp_name Shape) ...)
    def drop_the_colons_and_wheres!
      drop(tree, "[(colon) (where)]")
    end

    ### Brackets ###

    # Give the brackets in a type the type of the brackets in an expression,
    # because Idris reads types as expressions. Keep the brackets that name
    # an argument, such as `(n : Nat)`. The grammar reads some brackets at
    # the end of a file as a type.
    # (List a) -> b  ->  (exp_parens List a) -> b
    def write_brackets_in_types_as_expressions!
      captured(tree, "(type_parens) @name").each do |brackets|
        brackets.type = "exp_parens" if brackets.named_children.none? { |child| child.type == "type_var" }
      end
    end

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. A pair of brackets only groups if it holds one item, or if it
    # holds a whole expression, such as the body of a function or one item
    # of a list. Keep the brackets of an operator section, such as `(+ 1)`,
    # and the brackets of each argument in a function's patterns or an
    # implementation's head, such as `Show (Tree a)`.
    # f (x) = (g x)  ->  f x = g x
    # if (a == b) then c else d  ->  if a == b then c else d
    # [(f x), y]  ->  [f x, y]
    def unwrap_brackets_that_only_group!
      each_node(tree) do |node, _|
        node.children = node.children.flat_map do |child|
          only_groups?(node, child) ? spliced(child) : [child]
        end
      end
    end

    def only_groups?(parent, child)
      return false unless BRACKETS.include?(child.type)

      inner = child.named_children
      return false if inner.empty? || inner.any? { |item| SEPARATORS.include?(item.type) }
      return inner.first.type != "operator" if inner.one?
      return false if APPLICATIONS.include?(parent.type) || [inner.first, inner.last].any? { |item| item.type == "operator" }

      whole_item?(parent, child)
    end

    # Whether the brackets are the only code between the separators around
    # them, among the children of the parent with the same field.
    def whole_item?(parent, child)
      items = parent.children.reject { |sibling| !sibling.named? && ["(", ")"].include?(sibling.type) }
      items = items.select { |sibling| sibling.field == child.field }
      index = items.index { |sibling| sibling.equal?(child) }
      before = index.zero? ? nil : items[index - 1]
      after = items[index + 1]
      [before, after].all? { |item| item.nil? || !item.named? || SEPARATORS.include?(item.type) }
    end

    # The brackets' children, each with the brackets' field, so that they
    # take the brackets' place. The children are unwrapped again if they
    # are brackets too.
    def spliced(brackets)
      brackets.children.select(&:named?).flat_map do |child|
        child.field = brackets.field
        only_groups?(brackets, child) ? spliced(child) : [child]
      end
    end
  end
end
