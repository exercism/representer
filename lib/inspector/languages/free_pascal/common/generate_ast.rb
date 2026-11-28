# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Free Pascal's own parser gives, where names and
# keywords ignore case.
module Inspector::Languages::FreePascal::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the brackets, separators and other punctuation, because they are
    # layout. A `;` before `end` makes no difference to Free Pascal's parser.
    # f(a, b);  ->  (exprCall f (exprArgs a b))
    # begin a; end  ->  (block a)
    strip_tokens "(", ")", "[", "]", ",", ";", ":", ".", "..", ":="

    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Keep the keywords that tell two programs apart, such
    # as `to` and `downto`, `function` and `procedure`, and `var` and `const`
    # before a parameter.
    # if a then b else c  ->  (ifElse a b c)
    # while a do b  ->  (while a b)
    strip_tokens "unit", "program", "library", "interface", "implementation", "initialization", "finalization",
                 "uses", "begin", "end", "if", "then", "for", "while", "do", "repeat", "until", "case", "of",
                 "with", "try", "raise", "goto", "label", "inherited"

    # Strip these keywords only from the nodes listed, because elsewhere they
    # tell two programs apart.
    # var x: integer;  ->  (declVars (declVar x (type (typeref integer))))
    # const c = 1;  ->  (declConsts (declConst c (defaultValue 1)))
    # type t = integer;  ->  (declTypes (declType t (type (typeref integer))))
    # for x in xs do  ->  (foreach x xs)
    # on e: exception do  ->  (exceptionHandler e (typeref exception))
    # TBox<T>  ->  (genericTpl tbox (genericArgs (genericArg t)))
    strip_tokens "var", only_in: :declVars
    strip_tokens "const", only_in: :declConsts
    strip_tokens "type", only_in: :declTypes
    strip_tokens "=", only_in: [:declType, :defaultValue]
    strip_tokens "in", only_in: :foreach
    strip_tokens "else", only_in: :ifElse
    strip_tokens "on", only_in: :exceptionHandler
    strip_tokens "property", only_in: :declProp
    strip_tokens "<", ">", only_in: [:genericTpl, :exprTpl, :typerefTpl]

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (exprBinary (exprBinary a + b) * c)
    unwrap :exprParens

    # Write each number as its value. Free Pascal reads `$`, `%` and `&` as
    # hexadecimal, binary and octal, and keeps an integer apart from a real.
    # $FF  ->  255
    # 1.50  ->  1.5
    numbers_are integer: :literalNumber,
                decimal: :literalNumber,
                prefixes: { "$" => 16, "%" => 2, "&" => 8 },
                separators: []

    # A string is a run of quoted pieces and character codes, such as
    # `'a'#10'b'`.
    STRING_PIECE = /'((?:[^']|'')*)'|#(\d+)|#\$(\h+)/
    STRING = /\A(?:#{STRING_PIECE})+\z/

    def call
      tree.tap do
        write_keywords_as_tokens!
        write_negative_numbers_as_negations!
        write_strings_as_their_values!
        write_names_in_lower_case!
      end
    end

    private
    # Write each keyword and operator as a token in lower case. The grammar
    # gives each one a node of its own, such as `kBegin`, which holds the
    # text as it is written. Free Pascal reads `otherwise` in a `case` as
    # `else`.
    # BEGIN  ->  begin
    # otherwise  ->  else
    def write_keywords_as_tokens!
      each_node(tree) do |node, _|
        next if node.leaf?

        node.children = node.children.map do |child|
          next child unless keyword?(child)

          text = child.type == "kOtherwise" ? "else" : text_of(child).downcase
          token(text).tap { |keyword| keyword.field = child.field }
        end
      end
    end

    def keyword?(node) = node.named? && node.type.match?(/\Ak[A-Z]/)

    # Write a negative number as `-` before the number, because Free Pascal's
    # parser reads the sign as an operator either way.
    # -1  ->  (exprUnary - 1)
    def write_negative_numbers_as_negations!
      transform(tree, "(literalNumber) @number") do |match|
        number = match.node
        next unless number.leaf? && number.text.start_with?("-")

        build(:exprUnary, { operator: token("-") }, { operand: leaf(:literalNumber, number.text.delete_prefix("-")) })
      end
    end

    # Write each string as its value. Free Pascal reads a doubled quote as
    # one quote, and `#65` and `#$41` as the character `A`, so `'A'` and
    # `#65` are the same constant. A string with a character code above 127
    # keeps its text, because its value depends on the string type.
    # 'it''s'  ->  "it's"
    # 'a'#10'b'  ->  "a\nb"
    def write_strings_as_their_values!
      transform(tree, "(literalString) @string") do |match|
        value = string_value(match.node.text)
        literal(value) if value
      end
    end

    def string_value(text)
      return nil unless text&.match?(STRING)

      pieces = text.scan(STRING_PIECE).map do |quoted, decimal, hexadecimal|
        next quoted.gsub("''", "'") if quoted

        code = decimal ? decimal.to_i : hexadecimal.to_i(16)
        return nil if code > 127

        code.chr
      end
      pieces.join
    end

    # Write every name in lower case, because Free Pascal ignores the case
    # of names.
    # Result := IntToStr(Year)  ->  result := inttostr(year)
    def write_names_in_lower_case!
      each_node(tree) do |node, _|
        node.text = node.text.downcase if node.type == "identifier" && node.leaf?
      end
    end
  end
end
