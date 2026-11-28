# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, with one form for each value.
module Representer::Languages::Zig::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the brackets and other punctuation, because they are layout.
    # f(a, b);  ->  (SuffixExpr f (FnCallArguments a b))
    strip_tokens "(", ")", "{", "}", ",", ";"

    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # fn f() void {}  ->  (FnProto f (ParamDeclList) void)
    strip_tokens "fn", "test"

    # Unwrap the nodes that wrap one expression, and brackets that only
    # group, because the tree's shape shows the grouping.
    # (a + b)  ->  a + b
    unwrap :ErrorUnionExpr, :SuffixExpr, :GroupedExpr

    # Write each number as its value.
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    numbers_are integer: :INTEGER,
                decimal: :FLOAT

    ESCAPES = {
      '\n' => "\n",
      '\r' => "\r",
      '\t' => "\t",
      '\\\\' => "\\",
      "\\'" => "'",
      '\"' => '"'
    }.freeze

    def call
      tree.tap do
        drop_the_wrapper_around_each_lone_declaration_and_statement!
        write_strings_as_their_values!
        give_the_discard_its_own_type!
      end
    end

    private
    ### Declarations ###

    # Drop the `Decl` or `Statement` node around a declaration or statement
    # that has no keyword of its own, as Zig's parser does. An import is then
    # one node, which representation/spec.rb can drop whole.
    # const x = 1;  ->  (VarDecl const x = 1)
    # defer f();  ->  (Statement defer f())
    def drop_the_wrapper_around_each_lone_declaration_and_statement!
      transform(tree, "[(Decl) (Statement)]") do |match|
        children = match.node.children.reject { |child| !child.named? && child.text == ";" }
        children.first if children.one? && children.first.named?
      end
    end

    ### Values ###

    # Turn each string into its value, and read its escapes. Keep a byte
    # escape that stands for no character as a node of its own, so it can't
    # make two different strings the same.
    #
    # "a\x0Ab"  ->  "a\nb"
    # "\u{41}"  ->  "A"
    # "\xff"  ->  (STRINGLITERALSINGLE (escape_sequence \xff))
    def write_strings_as_their_values!
      transform(tree, "(STRINGLITERALSINGLE) @string") do |match|
        pieces = match.node.text[1...-1].split(/(\\(?:x\h{2}|u\{\h+\}|.))/m).reject(&:empty?)
        string_node(pieces.map { |piece| piece.start_with?("\\") ? escape(piece) : piece })
      end
    end

    # Return the text that an escape stands for, or a node for a byte escape
    # that stands for no character on its own.
    def escape(text)
      return ESCAPES.fetch(text) unless text.match?(/\A\\(x|u\{)/)

      value = text[/\h+(?=\}?\z)/].to_i(16)
      text.start_with?('\x') && value >= 0x80 ? leaf(:escape_sequence, text) : [value].pack("U")
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:STRINGLITERALSINGLE, *parts)
    end

    ### Names ###

    # Give `_` a type of its own, because it discards a value and defines no
    # name.
    # _ = x;  ->  (AssignExpr (discard _) (AssignOp =) x)
    def give_the_discard_its_own_type!
      each_node(tree) { |node, _| node.type = "discard" if node.type == "IDENTIFIER" && node.text == "_" }
    end
  end
end
