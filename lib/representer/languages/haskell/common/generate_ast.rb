# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that GHC's parser gives.
module Representer::Languages::Haskell::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Keep `mdo`, which differs from `do`.
    # if a then b else c  ->  (conditional a b c)
    strip_tokens "module", "where", "import", "data", "class", "deriving", "default", "if", "then", "else",
                 "case", "cases", "of", "let", "in", "do", "\\", "@", "%", "export", "foreign", "group",
                 "rec", "role", "using", "via", "#)", "||", "||]"
    strip_tokens "newtype", only_in: :newtype
    strip_tokens "type", only_in: :type_synonym
    strip_tokens "instance", only_in: :instance
    strip_tokens "-", only_in: :negation
    strip_tokens "..", only_in: :arithmetic_sequence

    # Strip the brackets, separators and arrows, because they are layout.
    # GHC reads explicit braces and semicolons the same as indentation, and
    # the Unicode spellings the same as the ASCII ones.
    # f [a, b]  ->  (apply f (list a b))
    # do { a; b }  ->  (do a b)
    # a ∷ Int  ->  a :: Int
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", "|", "=", "::", "->", "<-", "=>", "`", ".", "!", "~",
                 "forall", "∷", "→", "←", "⇒", "∀"

    # Keep the commas in tuples, because `(, 1)` and `(1, )` are different
    # functions.
    keep_tokens ",", in: [:tuple, :prefix_tuple, :unboxed_tuple]

    # Write each number as its value. Haskell reads `1` as any number and
    # `1.0` as a fraction, so the two stay apart.
    #
    # 0x1F  ->  31
    # 1e3  ->  1000.0
    numbers_are integer: :integer,
                decimal: :float

    TYPE_PARTS = ["type_params", "type_patterns", "context", "data_constructors", "newtype_constructor"].freeze

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\\\\' => "\\",
      '\"' => '"'
    }.freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        write_tight_dots_as_composition!
        list_the_imports_with_the_declarations!
        unwrap_brackets_that_only_group!
        mark_the_code_that_defines_names!
      end
    end

    private
    ### Values ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same. A character keeps its quotes, so `'a'` and `"a"` stay apart.
    #
    # "say \"hi\""  ->  say "hi"
    # "a\65"  ->  (string "a" \6 "5")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        pieces = match.node.text[1..-2].scan(/\\.|[^\\]+/m)
        next literal(string_value(pieces)) if pieces.all? { |piece| read?(piece) }

        runs = pieces.chunk_while { |a, b| read?(a) && read?(b) }
        build(:string, *runs.map { |run| read?(run.first) ? literal(string_value(run)) : leaf(:escape, run.first) })
      end
    end

    def read?(piece) = !piece.start_with?("\\") || ESCAPES.key?(piece)

    def string_value(pieces) = pieces.sum("") { |piece| ESCAPES.fetch(piece, piece) }

    ### Operators ###

    # Write a dot with no spaces around it as the composition operator,
    # because GHC reads `not.isSpace` as `not . isSpace`. The grammar reads
    # it as a record field, which it only is if the module turns on
    # OverloadedRecordDot. Leave a dot before a function's arguments, as in
    # `f.g x`, because GHC reads that as `f . (g x)`.
    #
    # not.isSpace  ->  not . isSpace
    def write_tight_dots_as_composition!
      return if captured(tree, "(pragma) @name").any? { |pragma| pragma.text.include?("OverloadedRecordDot") }

      each_node(tree) do |node, _|
        node.children.dup.each do |child|
          next unless child.type == "projection" && !(node.type == "apply" && child.field == "function")

          left, right = child.named_children
          node.replace_child(child, build(:infix, { left_operand: left }, { operator: leaf(:operator, ".") },
                                          { right_operand: right.named_children.first }))
        end
      end
    end

    ### Imports ###

    # List the imports beside the declarations, as GHC's parser does, so
    # that a module with no imports has the same tree as one whose imports
    # the engine has dropped.
    def list_the_imports_with_the_declarations!
      tree.children = tree.children.flat_map { |child| child.type == "imports" ? child.children : [child] }
    end

    ### Brackets ###

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Keep the brackets around an operator expression or a
    # negation inside an operator expression. The grammar reads every chain
    # of operators from the right, and reads `-x ^ 2` as `(-x) ^ 2`, so
    # only the brackets show the grouping.
    #
    # f (g x)  ->  (apply f (apply g x))
    # (a - b) - c keeps its brackets
    # (-x) ^ 2 keeps its brackets
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
      return false unless child.type == "parens" && child.named_children.one?

      !(parent.type == "infix" && ["infix", "negation"].include?(child.named_children.first.type))
    end

    ### Names ###

    # Give the code that defines a name a shape of its own, so that
    # representation/spec.rb can list it in names_are_defined_by.
    def mark_the_code_that_defines_names!
      # Mark the name of the module as a `module_name`.
      # module «Leap» (isLeapYear) where
      captured(tree, "(header module: (module) @name)").each { |name| name.type = "module_name" }

      # Mark the head of a function defined with an operator as an
      # `infix_head`, and mark an infix data constructor as an
      # `infix_constructor`.
      # «x |> f» = f x
      # data Complex = «Double :+ Double»
      captured(tree, "(function (infix) @name)").each { |head| head.type = "infix_head" }
      captured(tree, "(data_constructor constructor: (infix) @name)").each { |name| name.type = "infix_constructor" }

      write_defined_operators_without_brackets!
      mark_the_type_variables!
      mark_the_variables_that_patterns_bind!
    end

    # Write the name in a definition as the name itself, because GHC's
    # parser gives the same name for `(|>)` and `|>`, and for `` `plus` ``
    # and `plus`.
    #
    # (|>) :: a -> (a -> b) -> b  ->  |> :: a -> (a -> b) -> b
    # x `plus` y = x + y  ->  (infix_head x plus y)
    def write_defined_operators_without_brackets!
      each_node(tree) do |node, _|
        next unless ["function", "bind", "signature", "binding_list", "infix_head"].include?(node.type)

        node.children.dup.each do |child|
          next unless ["name", "operator"].include?(child.field) && ["prefix_id", "infix_id"].include?(child.type)

          node.replace_child(child, child.named_children.first)
        end
      end
    end

    # Mark each lower case name in a type as a `type_variable`, because GHC
    # reads every such name as a type variable. The types are in
    # signatures, type synonyms, and the heads and constructors of data
    # types, classes and instances.
    # area :: «a» -> «a»
    # data Tree «a» = Leaf | Node (Tree «a») «a» (Tree «a»)
    def mark_the_type_variables!
      each_node(tree) do |node, _|
        type_roots(node).each { |root| wrap_variables(node, root, :type_variable) }
      end
    end

    def type_roots(node)
      case node.type
      when "signature", "type_synonym", "gadt_constructor" then node.children.select { |child| child.field == "type" }
      when "data_type", "newtype", "class", "instance" then node.named_children.select { |child| TYPE_PARTS.include?(child.type) }
      else []
      end
    end

    # Mark each name that a pattern binds as a `variable_pattern`, as GHC's
    # parser does. A pattern binds every lower case name in it, apart from
    # the names of record fields and the function of a view pattern.
    # area «width» «height» = ...
    # go («x»:«xs») = ...
    # case shape of Circle «r» -> ...
    def mark_the_variables_that_patterns_bind!
      each_node(tree) do |node, _|
        pattern_roots(node).each { |root| wrap_variables(node, root, :variable_pattern) }
      end
    end

    def pattern_roots(node)
      case node.type
      when "patterns" then node.named_children
      when "bind", "alternative", "generator", "pattern_guard"
        node.children.select { |child| child.field == "pattern" }
      when "infix_head" then node.children.select { |child| ["left_operand", "right_operand"].include?(child.field) }
      else []
      end
    end

    # Wrap each variable in the node in a node of the given type. Skip the
    # names of record fields, the variables already wrapped, and the
    # function of a view pattern.
    def wrap_variables(parent, node, type)
      return parent.replace_child(node, build(type, node)) if node.type == "variable" && node.leaf?
      return if ["field_name", "type_variable", "variable_pattern"].include?(node.type)

      node.named_children.each do |child|
        wrap_variables(node, child, type) unless node.type == "view_pattern" && child.field == "expression"
      end
    end
  end
end
