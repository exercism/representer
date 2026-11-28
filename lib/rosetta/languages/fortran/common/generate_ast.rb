# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that a Fortran compiler's parser gives, where names and
# keywords ignore case and each operator has one spelling.
module Rosetta::Languages::Fortran::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the brackets, separators and line continuations, because they
    # are layout. Fortran's parser reads `(/ 1, 2 /)` as `[1, 2]`.
    # f(a, b)  ->  (call_expression f (argument_list a b))
    # (/ 1, 2 /)  ->  (array_literal 1 2)
    strip_tokens "(", ")", "[", "]", "(/", "/)", ",", "::", ";", "&"

    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Keep `then`, because `if (a) b` and `if (a) then`
    # are different statements.
    # call f(x)  ->  (subroutine_call f (argument_list x))
    # else if (a) then  ->  (elseif_clause a then)
    strip_tokens "program", "module", "contains", "function", "subroutine", "result", "implicit", "call",
                 "if", "else", "elseif", "do", "while", "select", "case", "selectcase", "print", "read",
                 "write"

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (math_expression (math_expression a + b) * c)
    unwrap :parenthesized_expression

    # Fortran reads each of these keywords the same with or without the space.
    KEYWORD_PAIRS = {
      ["block", "data"] => "blockdata",
      ["double", "precision"] => "doubleprecision",
      ["double", "complex"] => "doublecomplex",
      ["in", "out"] => "inout",
      ["go", "to"] => "goto",
      ["else", "if"] => "elseif",
      ["else", "where"] => "elsewhere",
      ["select", "case"] => "selectcase",
      ["select", "type"] => "selecttype",
      ["select", "rank"] => "selectrank",
      ["type", "is"] => "typeis",
      ["class", "is"] => "classis"
    }.freeze

    # The end statement of a labelled loop holds its label, so it stays.
    END_STATEMENT = /\Aend_(?!do_label_loop_statement)\w*statement\z/

    RELATIONAL_OPERATORS = {
      ".eq." => "==",
      ".ne." => "/=",
      ".lt." => "<",
      ".le." => "<=",
      ".gt." => ">",
      ".ge." => ">="
    }.freeze

    def call
      tree.tap do
        write_two_word_keywords_as_one!
        drop_end_statements!
        write_strings_as_their_values!
        write_names_in_lower_case!
        write_numbers_as_values!
        write_relational_operators_as_symbols!
      end
    end

    private
    # Write each keyword that may have a space in it as one word.
    # double precision  ->  doubleprecision
    # intent(in out)  ->  intent(inout)
    def write_two_word_keywords_as_one!
      each_node(tree) do |node, _|
        next if node.leaf?

        node.children = node.children.each_with_object([]) do |child, children|
          joined = KEYWORD_PAIRS[[children.last&.type, child.type]] if !child.named? && !children.last&.named?
          joined ? children[-1] = token(joined) : children << child
        end
      end
    end

    # Drop the end statements, because the node around each one already
    # ends there, and the name after `end function` must be the function's.
    # end function hey  ->  (nothing)
    # endif  ->  (nothing)
    def drop_end_statements!
      each_node(tree) do |node, _|
        node.children = node.children.reject { |child| child.type.match?(END_STATEMENT) } unless node.leaf?
      end
    end

    # Write each string as its value, whichever quotes it uses. Fortran reads
    # a doubled quote as one quote, and the grammar gives the second one in
    # the next piece of text, so the first one goes.
    # 'it''s'  ->  "it's"
    # "say ""hi"""  ->  "say \"hi\""
    def write_strings_as_their_values!
      transform(tree, "(string_literal) @string") do |match|
        kind = match.node[:kind]
        text = match.node.children.select { |child| child.type == "string_content" }.map { |child| text_of(child) }.join
        kind ? build(:string_literal, { kind: }, literal(text)) : literal(text)
      end
    end

    # Write every name in lower case, because Fortran ignores the case of
    # names. The grammar spells the keywords in lower case already.
    # Total = SUM(Values)  ->  total = sum(values)
    # IMPLICIT NONE  ->  implicit none
    def write_names_in_lower_case!
      each_node(tree) do |node, _|
        node.text = node.text.downcase if node.named? && node.leaf? && !node.quoted
      end
    end

    # Write each number as its value. Fortran reads `1e3` and `1000.0` as the
    # same default real, and `1d3` as a double precision real, so each kind
    # of number stays apart from the others. A kind after an `_` stays as it
    # is written.
    #
    # 007  ->  7
    # 1e3  ->  1000.0
    # 1.5D0  ->  1.5d0
    # 2.0_dp  ->  (number_literal 2.0 dp)
    def write_numbers_as_values!
      each_node(tree) do |node, _|
        next unless node.type == "number_literal"

        digits = node.leaf? ? node : node.children.find { |child| child.type == "fragment" }
        digits.text = number(digits.text) || digits.text if digits
        node.children = node.children.reject { |child| child.type == "_" } unless node.leaf?
      end
    end

    def number(text)
      return text.to_i.to_s if text.match?(/\A\d+\z/)

      match = text.match(/\A(\d*\.?\d*)(?:([ed])([-+]?\d+))?\z/)
      return nil unless match

      mantissa, letter, exponent = match.captures
      value = Rosetta::Engine::Numbers.decimal(exponent ? "#{mantissa}e#{exponent}" : mantissa, separator: "")
      value && "#{Rosetta::Engine::Numbers.write_decimal(value)}#{'d0' if letter == 'd'}"
    end

    # Write each relational operator as its symbol, because Fortran reads
    # the two spellings as the same operator.
    # a .eq. b  ->  a == b
    # a .ge. b  ->  a >= b
    def write_relational_operators_as_symbols!
      captured(tree, "(relational_expression operator: _ @name)").each do |operator|
        symbol = RELATIONAL_OPERATORS[operator.type]
        operator.type = operator.text = symbol if symbol
      end
    end
  end
end
