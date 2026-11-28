# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Erlang's own parser (erl_parse) gives.
module Representer::Languages::Erlang::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Erlang reads `-behavior` the same as `-behaviour`.
    # case X of a -> 1 end  ->  (case_expr (variable X) (cr_clause a (clause_body 1)))
    strip_tokens "begin", "case", "of", "end", "if", "receive", "after", "try", "catch", "fun", "maybe", "else",
                 "when", "module", "export", "export_type", "import", "include", "include_lib", "behaviour",
                 "behavior", "compile", "define", "undef", "ifdef", "ifndef", "elif", "endif", "record", "type",
                 "opaque", "nominal", "spec", "callback", "deprecated", "feature", "file", "optional_callbacks",
                 "export_record", "import_record", "ssr", "unit", "where"

    # Strip the brackets, separators and arrows, because they are layout.
    # The tree's shape shows the clauses of a guard, which `;` and `,` separate.
    # f(1, [2 | 3])  ->  (call f (expr_args 1 (list (pipe 2 3))))
    strip_tokens "(", ")", "[", "]", "{", "}", "<<", ">>", ",", ";", ".", "->", "#", "#_", "?", "?=", ":",
                 "=", "|", "||", "&&", "::", "..", "..."

    # Strip the `-` that starts an attribute, and keep it as an operator.
    # -module(leap).  ->  (module_attribute leap)
    strip_tokens "-"
    keep_tokens "-", in: [:binary_op_expr, :unary_op_expr, :unary_op_expr_max, :binary_op_catch_pat]

    # Strip the `/` of an arity and of a binary's types, and keep it as an operator.
    # fun f/1  ->  (internal_fun f (arity 1))
    strip_tokens "/", only_in: [:arity, :bit_type_list]

    # Keep the `::` or `:>` of an annotated variable in a type, because they
    # mean different things.
    keep_tokens "::", in: :ann_var

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (1 + 2) * 3  ->  (binary_op_expr (binary_op_expr 1 + 2) * 3)
    unwrap :paren_expr

    # Write each number as its value. Erlang reads `1` as an integer and
    # `1.0` as a float, so the two stay apart.
    #
    # 1_000  ->  1000
    # 16#FF  ->  255
    # 1.0e3  ->  1000.0
    numbers_are integer: :integer,
                decimal: :float,
                prefixes: { "2#" => 2, "8#" => 8, "10#" => 10, "16#" => 16 }

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\s' => " ",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'"
    }.freeze

    # Erlang's reserved words, which an atom can only spell in quotes.
    RESERVED_WORDS = [
      "after", "and", "andalso", "band", "begin", "bnot", "bor", "bsl", "bsr", "bxor", "case", "catch", "cond",
      "div", "else", "end", "fun", "if", "let", "maybe", "not", "of", "or", "orelse", "receive", "rem", "try",
      "when", "xor"
    ].freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        write_quoted_atoms_without_quotes!
        join_adjacent_strings!
        list_the_clauses_of_each_function_together!
        wrap_each_variable_in_a_variable_node!
      end
    end

    private
    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same. Leave a triple-quoted string as it is written.
    #
    # "say \"hi\""  ->  say "hi"
    # "a\101"  ->  (string "a" \1 "01")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        text = match.node.text
        next if text.start_with?('"""')

        pieces = pieces_of(text)
        next literal(value_of(pieces)) if pieces.all? { |piece| read?(piece) }

        runs = pieces.chunk_while { |a, b| read?(a) && read?(b) }
        build(:string, *runs.map { |run| read?(run.first) ? literal(value_of(run)) : leaf(:escape, run.first) })
      end
    end

    # Write a quoted atom without its quotes if it is the same atom, because
    # Erlang reads `'ok'` as `ok`. Keep the quotes if the atom needs them.
    #
    # 'ok'  ->  ok
    # 'hello world' keeps its quotes
    def write_quoted_atoms_without_quotes!
      captured(tree, "(atom) @name").each do |atom|
        next unless atom.text.start_with?("'")

        pieces = pieces_of(atom.text)
        next unless pieces.all? { |piece| read?(piece) }

        value = value_of(pieces)
        atom.text = value if value.match?(/\A[a-z][A-Za-z0-9_@]*\z/) && !RESERVED_WORDS.include?(value)
      end
    end

    # Write strings next to each other as one string, because Erlang's
    # parser joins them.
    #
    # "ab" "c"  ->  "abc"
    def join_adjacent_strings!
      transform(tree, "(concatables) @strings") do |match|
        parts = match.node.children
        literal(parts.sum("", &:text)) if parts.all?(&:quoted)
      end
    end

    # List the clauses of a function in one `function` node, as Erlang's
    # parser does. The grammar gives each clause a `fun_decl` of its own, and
    # a clause that ends with `;` goes on to the next one.
    #
    # e.g. We convert:
    #   f(0) -> 1;
    #   f(N) -> N.
    # internally into:
    #   (function (function_clause f ...) (function_clause f ...))
    def list_the_clauses_of_each_function_together!
      groups = tree.children.chunk_while { |a, b| clause?(a) && clause?(b) && a.children.last.type == ";" }
      tree.children = groups.map do |group|
        clause?(group.first) ? build(:function, *group.flat_map(&:named_children)) : group.first
      end
    end

    # Wrap each variable in a `variable` node, so that representation/spec.rb can
    # list it in names_are_defined_by. Every variable in an Erlang module
    # belongs to the solution. Leave `_` and the names of macros, such as
    # `?MODULE`, because they aren't variables.
    #
    # X = 1  ->  (match_expr (variable X) 1)
    def wrap_each_variable_in_a_variable_node!
      variables = []
      each_node(tree) do |node, parent|
        variables << [node, parent] if node.type == "var" && node.text != "_" && !macro_name?(node, parent)
      end
      variables.each { |var, parent| parent.replace_child(var, build(:variable, var)) }
    end

    def clause?(node) = node.type == "fun_decl"

    def macro_name?(node, parent) = node.field == "name" && ["macro_call_expr", "macro_lhs"].include?(parent.type)

    def pieces_of(text) = text[1..-2].scan(/\\.|[^\\]+/m)

    def read?(piece) = !piece.start_with?("\\") || ESCAPES.key?(piece)

    def value_of(pieces) = pieces.sum("") { |piece| ESCAPES.fetch(piece, piece) }
  end
end
