# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Pyret's own parser gives.
module Inspector::Languages::Pyret::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Keep `block:`, `check`, `examples`, `ref`, `shadow`,
    # `because`, `%` and `ascending`, which change what the code means, as
    # Pyret's parser records them.
    # fun f(x): x end  ->  (fun_expr f (fun_header (args x)) x)
    strip_tokens "fun", "lam", "method", "end", "if", "else if", "else:", "else", "ask", "then:", "otherwise:",
                 "cases", "for", "from", "when", "let", "letrec", "type-let", "var", "rec", "data", "type",
                 "newtype", "with:", "sharing:", "where:", "doc:", "table:", "row:", "load-table", "source:",
                 "sanitize", "using", "select", "sieve", "order", "extract", "transform", "extend", "of",
                 "reactor", "spy", "module", "hiding", "use", "include", "import", "provide", "provide:",
                 "provide-types", "lazy", "does-not-raise"

    # Strip the brackets, separators and arrows, because they are layout.
    # Pyret's parser ignores a `,` or `;` after the last item, and a `lam`
    # written with braces gives the same tree as one written with `lam`.
    # f(a, b)  ->  (app_expr f (app_args (comma_binops a b)))
    # {(x): x}  ->  lam(x): x end
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", ":", "::", ".", "!", "=", ":=", "->", "=>", "|",
                 "<", ">", "*"

    # Keep the `as` in a tuple binding, because `{a; b} as c` binds the whole
    # tuple to c, while `{a; b; c}` binds a third item.
    strip_tokens "as"
    keep_tokens "as", in: :tuple_binding

    # Unwrap the nodes that only wrap one child, and brackets that only
    # group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (binop_expr (binop_expr a + b) * c)
    unwrap :paren_expr,
           :provide_stmt,
           :id_expr,
           :prim_expr,
           :num_expr,
           :string_expr,
           :binding,
           :toplevel_binding,
           :let_binding,
           :type_let_bind,
           :ann

    # Write each number as its value. Pyret reads every number as an exact
    # number, so `1.0` and `1` are the same.
    # 1.50  ->  1.5
    # 1e3  ->  1000
    numbers_are number: :number

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'",
      '\`' => "`"
    }.freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        group_each_chain_of_operators!
        write_every_data_variant_the_same_way!
        mark_the_keys_of_reactors!
      end
    end

    private
    # Turn each string into its value, however it is quoted, and read its
    # escapes. Keep any other escape as a leaf of its own, so it can't make
    # two different strings the same. Pyret strips the blanks at the start
    # and end of a string in triple backticks.
    #
    # 'a'  ->  "a"
    # ```  a ```  ->  "a"
    # "a\065"  ->  (string "a" \065)
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        pieces = match.node.named_children.map { |piece| piece.type == "string_content" ? piece.text : piece }
        strip_triple_quoted_blanks!(pieces) if match.node.children.first.text == "```"
        pieces = pieces.map { |piece| piece.is_a?(String) ? piece : ESCAPES.fetch(piece.text, piece) }
        runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
        parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : leaf(:escape, run.first.text) }
        next literal("") if parts.empty?

        parts.size == 1 && parts.first.type == "literal" ? parts.first : build(:string, *parts)
      end
    end

    def strip_triple_quoted_blanks!(pieces)
      pieces[0] = pieces[0].lstrip if pieces.first.is_a?(String)
      pieces[-1] = pieces[-1].rstrip if pieces.last.is_a?(String)
      pieces.reject! { |piece| piece == "" }
    end

    # Group each chain of operators into one node for each operator, from
    # the left, as Pyret's parser does. The grammar writes the chain as a
    # flat run of operands and operators.
    # a + b + c  ->  (binop_expr (binop_expr a + b) + c)
    def group_each_chain_of_operators!
      each_node(tree) do |node, _|
        next if node.type == "binop_expr"

        while (index = node.children.index { |child| child.type == "binop" })
          left, operator, right = node.children[(index - 1)..(index + 1)]
          node.children[(index - 1)..(index + 1)] = [build(:binop_expr, left, operator, right)]
        end
      end
    end

    # Write the first variant of a data definition as any other variant,
    # because Pyret's parser ignores the `|` before it.
    # data D: | a | b end  ->  data D: a | b end
    def write_every_data_variant_the_same_way!
      retype(tree, first_data_variant: :data_variant)
    end

    # Give the keys of a reactor a type of their own, so that
    # representation/spec.rb doesn't rename them. The keys come from Pyret's
    # library.
    # reactor: «init»: 0, «on-tick»: tick end
    def mark_the_keys_of_reactors!
      captured(tree, "(reactor_expr (fields) @name)").each do |fields|
        fields.named_children.each { |field| field.named_children.first.type = "reactor_key" }
      end
    end
  end
end
