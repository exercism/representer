# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree of terms that Prolog's own reader (read_term) gives.
module Rosetta::Languages::Prolog::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (A + B) * C  ->  (operator_notation (operator_notation A + B) * C)
    unwrap :operator_notation

    # Write each number as its value. Prolog reads `1` as an integer and
    # `1.0` as a float, so the two stay apart.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.0e3  ->  1000.0
    numbers_are integer: :integer,
                decimal: :float_number

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'",
      "\\`" => "`"
    }.freeze

    def call
      tree.tap do
        write_empty_lists_and_braces_as_atoms!
        drop_punctuation!
        write_strings_as_their_values!
        write_quoted_atoms_without_quotes!
        write_character_codes_as_integers!
        write_each_list_with_its_tail_as_one_list!
        mark_the_head_of_each_clause!
        wrap_each_variable_in_a_variable_node!
      end
    end

    private
    # Write `[]` and `{}` as atoms, because Prolog reads them as atoms
    # however they are spaced.
    #
    # [ ]  ->  []
    def write_empty_lists_and_braces_as_atoms!
      transform(tree, "(atom [(empty_list) (empty_curly_brackets)])") do |match|
        leaf(:atom, text_of(match.node))
      end
    end

    # Drop the brackets, separators and full stops, because the node types
    # already show them. The grammar gives each one a node of its own.
    #
    # f(a, b).  ->  (clause_term (functional_notation f (arg_list a b)))
    def drop_punctuation!
      drop(tree, "[(open) (open_ct) (close) (open_list) (close_list) (open_curly) (close_curly) (end)
                   (arg_list_separator) (list_notation_separator)]")
    end

    # Turn each double-quoted string into its value, and read its escapes.
    # Keep any other escape as a leaf of its own, so it can't make two
    # different strings the same.
    #
    # "say \"hi\""  ->  say "hi"
    # "say ""hi"""  ->  say "hi"
    # "a\eb"  ->  (string "a" \e "b")
    def write_strings_as_their_values!
      transform(tree, "(double_quoted_list_notation) @string") do |match|
        pieces = pieces_of(match.node.text)
        next literal(value_of(pieces)) if pieces.all? { |piece| read?(piece) }

        runs = pieces.chunk_while { |a, b| read?(a) && read?(b) }
        build(:string, *runs.map { |run| read?(run.first) ? literal(value_of(run)) : leaf(:escape, run.first) })
      end
    end

    # Write a quoted atom without its quotes if it is the same atom, because
    # Prolog reads `'ok'` as `ok`. Keep the quotes if the atom needs them.
    #
    # 'ok'  ->  ok
    # 'Hello' keeps its quotes
    def write_quoted_atoms_without_quotes!
      captured(tree, "(atom) @name").each do |atom|
        next unless atom.text.start_with?("'")

        pieces = pieces_of(atom.text)
        next unless pieces.all? { |piece| read?(piece) }

        value = value_of(pieces)
        atom.text = value if value.match?(/\A[a-z][A-Za-z0-9_]*\z/)
      end
    end

    # Write each character code as its integer, because Prolog reads `0'a`
    # as 97.
    #
    # 0'a  ->  97
    # 0'\n  ->  10
    # 0'''  ->  39
    def write_character_codes_as_integers!
      captured(tree, "(integer) @name").each do |code|
        character = code.text[/\A0'(.+)\z/m, 1]
        character = "'" if character == "''"
        character = ESCAPES[character] if ESCAPES.key?(character)
        code.text = character.ord.to_s if character&.length == 1 && character != "\\"
      end
    end

    # Write a list with a list as its tail as one list, because Prolog reads
    # them as the same list.
    #
    # [a|[b, c]]  ->  [a, b, c]
    # [a|[]]  ->  [a]
    def write_each_list_with_its_tail_as_one_list!
      transform(tree, "(list_notation) @list") do |match|
        *items, bar, tail = match.node.children
        next unless bar&.type == "|"
        next build(:list_notation, *items, *tail.children) if tail.type == "list_notation"

        build(:list_notation, *items) if tail.type == "atom" && tail.text == "[]"
      end
    end

    # Mark the head of each clause, so that representation/spec.rb can list
    # the predicates the solution defines in names_are_defined_by. The head
    # is the whole of a fact, and the left of `:-` in a rule or of `-->` in
    # a grammar rule.
    #
    # leap(Year) :- ...  ->  (operator_notation (head leap (arg_list Year)) :- ...)
    # main :- ...  ->  (operator_notation (head main) :- ...)
    def mark_the_head_of_each_clause!
      tree.children.select { |clause| clause.type == "clause_term" }.each do |clause|
        term = clause.children.first
        parent, head = rule?(term) ? [term, term.children.first] : [clause, term]
        case head.type
        when "functional_notation" then head.type = "head"
        when "atom" then parent.replace_child(head, build(:head, { function: head }))
        end
      end
    end

    # Wrap each variable in a `variable` node, so that representation/spec.rb
    # can list it in names_are_defined_by. Every variable belongs to the
    # clause it is in. Leave `_` as it is, because each `_` is a different
    # variable.
    #
    # X = 1  ->  (operator_notation (variable X) = 1)
    def wrap_each_variable_in_a_variable_node!
      variables = []
      each_node(tree) { |node, parent| variables << [node, parent] if node.type == "variable_term" && node.text != "_" }
      variables.each { |variable, parent| parent.replace_child(variable, build(:variable, variable)) }
    end

    def rule?(term) = term.type == "operator_notation" && [":-", "-->"].include?(term[:operator]&.text)

    # Read a quote written twice, as in `'it''s'`, as the escape `\'`.
    def pieces_of(text)
      quote = text[0]
      text[1..-2].scan(/\\.?|#{quote}#{quote}|[^\\#{quote}]+/m).map { |piece| piece == quote * 2 ? "\\#{quote}" : piece }
    end

    def read?(piece) = !piece.start_with?("\\") || ESCAPES.key?(piece)

    def value_of(pieces) = pieces.sum("") { |piece| ESCAPES.fetch(piece, piece) }
  end
end
