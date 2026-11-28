# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that a COBOL compiler's parser gives, where names and
# keywords ignore case and each keyword has one spelling.
module Rosetta::Languages::Cobol::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the full stops and the brackets around arguments, because the
    # node types already show them. A full stop that ends a sentence in the
    # PROCEDURE DIVISION stays as a `period` node, because it ends every
    # open IF.
    # FUNCTION TRIM(X)  ->  (function_ function trim (func_args (qualified_word x)))
    strip_tokens "."
    strip_tokens "(", ")", only_in: [:func_args, :function_, :subref, :refmod]

    # Strip the `=` of COMPUTE, because COBOL reads `COMPUTE X = 1` and
    # `COMPUTE X EQUAL 1` as the same statement.
    strip_tokens "=", only_in: :compute_statement

    # Write each number as its value.
    # 007  ->  7
    # 05 X PIC 9.  ->  5 X PIC 9.
    # 1.50  ->  1.5
    numbers_are integer: [:integer, :level_number],
                decimal: :decimal,
                prefixes: {},
                separators: []

    # These leaves hold names and values. Every other leaf is a keyword.
    VALUE_LEAVES = [
      "WORD", "entry_name", "program_name", "MNEMONIC_NAME", "linage_counter", "procedure_returning",
      "integer", "decimal", "string", "x_string", "h_string", "n_string", "level_number", "level_number_88",
      "picture_x", "picture_n", "picture_9", "picture_a", "picture_edit", "fragment", "keyword"
    ].freeze

    # The grammar gives each of COBOL's spellings of these the same type.
    SPELLED_BY_TYPE = [
      "eq", "ne", "gt", "lt", "ge", "le", "HIGH_VALUE", "LOW_VALUE", "QUOTE", "SPACE", "TOK_NULL", "ZERO", "ZEROS"
    ].freeze

    PICTURES = ["picture_x", "picture_n", "picture_9", "picture_a", "picture_edit"].freeze

    # COBOL reads each of these the same as the other in its pair.
    SYNONYMS = { "ZEROS" => "ZERO" }.freeze

    # A fragment's first word is a name in these nodes, because the grammar
    # leaves the name out of its tree.
    NAMED_BY_FRAGMENT = ["paragraph_header", "section_header", "procedure_param"].freeze

    # The words that COBOL lets a statement leave out, with no change to it.
    OPTIONAL_WORDS = ["is", "are", "then"].freeze

    def call
      tree.tap do
        write_names_held_in_fragments!
        write_fragments_as_keywords!
        write_comparisons_and_figurative_constants_as_keywords!
        write_keyword_leaves_as_their_types!
        write_names_in_lower_case!
        write_pictures_the_same_way!
        write_strings_as_their_values!
      end
    end

    private
    # Write the name in each paragraph header, section header and parameter
    # as a name, because the grammar only gives its text. A paragraph or
    # section can also be named by a number.
    # MAIN-PARA.  ->  (paragraph_header (WORD main-para))
    # MAIN SECTION.  ->  (section_header (WORD main) section)
    # USING BY VALUE WS-X  ->  (procedure_param (procedure_type VALUE) (WORD ws-x))
    def write_names_held_in_fragments!
      each_node(tree) do |node, _|
        next unless NAMED_BY_FRAGMENT.include?(node.type) && node.children.first&.type != "integer"

        index = node.children.index { |child| child.type == "fragment" }
        next unless index

        name, *rest = words(node.children[index].text)
        node.children[index, 1] = [leaf(:WORD, name), (leaf(:fragment, rest.join(" ")) if rest.any?)].compact
      end
    end

    # Write the words between a node's children as keywords, one leaf for
    # each word, in lower case. COBOL reads a comma or a semicolon as a
    # space, and IS, ARE and THEN as nothing.
    # MOVE LENGTH OF X TO Y  ->  (move_statement move length of (qualified_word x) to (qualified_word y))
    def write_fragments_as_keywords!
      each_node(tree) do |node, _|
        next if node.leaf?

        node.children = node.children.flat_map do |child|
          next [child] unless child.type == "fragment"

          (words(child.text) - OPTIONAL_WORDS).map { |word| leaf(:keyword, word) }
        end
      end
    end

    # The words of a fragment, without the sequence area at the start of
    # each line after the first, and without the comment lines.
    def words(text)
      lines = text.split("\n", -1)
      later = lines.drop(1).map { |line| line[6..].to_s }.reject { |line| line.start_with?("*", "/") }
      [lines.first, *later].join(" ").downcase.tr(",;", "  ").split
    end

    # Write each comparison and figurative constant as one leaf.
    # X IS GREATER THAN Y  ->  X (gt) Y
    # X > Y  ->  X (gt) Y
    # HIGH-VALUES  ->  (HIGH_VALUE)
    def write_comparisons_and_figurative_constants_as_keywords!
      each_node(tree) do |node, _|
        next unless SPELLED_BY_TYPE.include?(node.type)

        node.children = []
        node.text = node.type
      end
    end

    # Write each keyword leaf as its type, because the grammar gives each of
    # COBOL's spellings of a keyword the same type.
    # IS NOT EQUAL TO  ->  ne
    # end-if  ->  END_IF
    # THROUGH  ->  THRU
    # ZEROS  ->  ZERO
    def write_keyword_leaves_as_their_types!
      each_node(tree) do |node, _|
        next unless node.leaf? && node.named? && !node.quoted && !VALUE_LEAVES.include?(node.type)

        node.type = SYNONYMS.fetch(node.type, node.type)
        node.text = node.type
      end
    end

    # Write every name and token in lower case, because COBOL ignores the
    # case of names and keywords. FILLER is a keyword that gives a data item
    # no name.
    # MOVE Ws-Total TO WS-RESULT  ->  move ws-total to ws-result
    # 01 FILLER PIC X.  ->  1 (FILLER) PIC X.
    def write_names_in_lower_case!
      each_node(tree) do |node, _|
        next unless node.leaf? && !node.quoted

        if !node.named?
          node.type = node.text = node.text.downcase
        elsif node.type == "entry_name" && node.text.casecmp?("filler")
          node.type = node.text = "FILLER"
        elsif ["WORD", "entry_name", "program_name", "MNEMONIC_NAME", "procedure_returning"].include?(node.type)
          node.text = node.text.downcase
        end
      end
    end

    # Write each picture in lower case, with each run of a symbol as the
    # symbol and its count, because COBOL reads the spellings as the same
    # picture.
    # PIC 9999  ->  PIC 9(4)
    # PIC X(2)X  ->  PIC x(3)
    def write_pictures_the_same_way!
      each_node(tree) do |node, _|
        next unless PICTURES.include?(node.type) && node.leaf?

        node.text = picture(node.text)
      end
    end

    def picture(text)
      symbols = text.downcase.scan(/(cr|db|[^()])(?:\((\d+)\))?/).flat_map { |symbol, count| [symbol] * (count || 1).to_i }
      symbols.chunk_while { |a, b| a == b }.map { |run| run.size == 1 ? run.first : "#{run.first}(#{run.size})" }.join
    end

    # Write each string as its value, whichever quotes it uses. COBOL reads a
    # doubled quote as one quote. A string continued onto another line keeps
    # its text.
    # 'it''s'  ->  "it's"
    # "abc"  ->  "abc"
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        text = match.node.text
        next nil if text.include?("\n")

        quote = text[0]
        literal(text[1...-1].gsub(quote * 2, quote))
      end
    end
  end
end
