# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that SQLite's own parser gives.
module Rosetta::Languages::Sqlite::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. write_keywords_in_lower_case! turns each keyword into
    # a token first.
    # UPDATE t SET a = 1 WHERE b  ->  (update (relation t) (assignment a 1) (where b))
    strip_tokens "select", "from", "where", "set", "with", "as", "by", "group", "order", "partition", "having",
                 "limit", "case", "end", "begin", "join", "over", "create", "table", "view", "trigger", "index",
                 "drop", "alter", "add", "column"
    strip_tokens "update", only_in: :update
    strip_tokens "insert", "into", only_in: :insert
    strip_tokens "delete", only_in: :delete
    strip_tokens "values", only_in: :values
    strip_tokens "cast", only_in: :cast
    strip_tokens "pragma", only_in: :pragma_statement
    strip_tokens "and", only_in: :between_expression

    # Strip `RECURSIVE`, `INNER` and `OUTER`, because SQLite's parser reads
    # `WITH RECURSIVE` as `WITH`, `INNER JOIN` as `JOIN` and `LEFT OUTER JOIN`
    # as `LEFT JOIN`.
    strip_tokens "recursive"
    strip_tokens "inner", "outer", only_in: :join

    # Strip the brackets, commas and semicolons, because they are layout.
    # f(a, b);  ->  (invocation f a b)
    strip_tokens "(", ")", ",", ";"

    # Strip the marks that sit in a fixed place, because the node types
    # already show them.
    # t.a  ->  (field t a)
    strip_tokens ".", only_in: [:field, :all_fields]
    strip_tokens "=", only_in: :assignment

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value. SQLite reads a number with an exponent
    # as a real number, so `1e3` is `1000.0`, and reads `0x` before a
    # hexadecimal integer.
    #
    # 0x1F  ->  31
    # 1e3  ->  1000.0
    # .50  ->  0.5
    numbers_are integer: :literal,
                decimal: :literal,
                prefixes: { "0x" => 16 }

    OPERATORS = { "==" => "=", "<>" => "!=" }.freeze

    KEYWORDS = { "temporary" => "temp" }.freeze

    def call
      tree.tap do
        write_keywords_in_lower_case!
        write_every_operator_the_same_way!
        write_literals_as_their_values!
        write_identifiers_the_same_way!
        mark_the_names_that_definitions_define!
      end
    end

    private
    # Turn each keyword into a token in lower case, because SQLite reads
    # keywords in any case. Write `TEMPORARY` as `TEMP`, because SQLite's
    # parser reads them as the same keyword.
    # SELECT  ->  select
    # TEMPORARY  ->  temp
    def write_keywords_in_lower_case!
      each_node(tree) do |node, _|
        node.children.map! do |child|
          next child unless child.type.start_with?("keyword_") && child.leaf?

          text = child.text.downcase
          token(KEYWORDS.fetch(text, text)).tap { |keyword| keyword.field = child.field }
        end
      end
    end

    # Write each operator with two spellings in one way, because SQLite's
    # tokenizer reads `==` as `=` and `<>` as `!=`.
    # a == b  ->  a = b
    # a <> b  ->  a != b
    def write_every_operator_the_same_way!
      each_node(tree) do |node, parent|
        parent.replace_child(node, token(OPERATORS[node.text])) if !node.named? && OPERATORS.key?(node.text)
      end
    end

    ### Values ###

    # Turn each string into its value, and write each other literal in lower
    # case, because SQLite reads `NULL`, `TRUE` and the digits of a blob in
    # any case. A double-quoted string is a name if the table has a column
    # with that name, so it becomes the same node as a double-quoted name
    # (see write_identifiers_the_same_way!).
    #
    # 'it''s'  ->  "it's"
    # NULL  ->  null
    # X'FF'  ->  x'ff'
    # "a"  ->  (quoted_identifier "a")
    def write_literals_as_their_values!
      each_node(tree) do |node, parent|
        next unless node.type == "literal" && node.leaf? && !node.quoted

        text = node.text
        if text.start_with?("'")
          parent.replace_child(node, literal(text[1...-1].gsub("''", "'")))
        elsif text.start_with?('"')
          parent.replace_child(node, quoted_identifier(text))
        elsif text.match?(/\A(null|true|false|x'\h*')\z/i)
          node.text = text.downcase
        end
      end
    end

    # Write each name in lower case, because SQLite reads names in any case,
    # and drop the backticks around a name, because they make no difference.
    # A double-quoted name keeps its case and gets a node of its own, because
    # SQLite reads it as a string if no column has that name.
    #
    # Total  ->  total
    # `total`  ->  total
    # "total"  ->  (quoted_identifier "total")
    def write_identifiers_the_same_way!
      each_node(tree) do |node, parent|
        next unless node.type == "identifier" && node.leaf?

        text = node.text
        if text.start_with?('"')
          parent.replace_child(node, quoted_identifier(text))
        else
          node.text = text.delete("`").tr("A-Z", "a-z")
        end
      end
    end

    def quoted_identifier(text) = build(:quoted_identifier, literal(text[1...-1].gsub('""', '"')))

    ### Names ###

    # Write the table, view or trigger that a statement creates as the name
    # in its field `name`, so that representation/spec.rb can list the nodes
    # that define it. The grammar gives that name the same node as every use
    # of a table.
    # CREATE TABLE «results» (a INT)  ->  (create_table results (column_definitions ...))
    def mark_the_names_that_definitions_define!
      each_node(tree) do |node, _|
        next unless ["create_table", "create_view", "create_trigger"].include?(node.type)

        reference = node.children.find { |child| child.type == "object_reference" }
        name = reference&.named_children
        next unless name&.one? && name.first.type == "identifier"

        node.replace_child(reference, name.first).field = "name"
      end
    end
  end
end
