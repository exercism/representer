# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, with one form for each spelling that AWK's parser reads the
# same way.
module Representer::Languages::Awk::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. AWK reads `func` as `function`.
    # func f(x) { return x }  ->  (function_definition f (parameter_list x) (statement_list (return_statement x)))
    strip_tokens "function", "func", "if", "else", "while", "do", "for", "in", "switch", "case", "default",
                 "break", "continue", "next", "nextfile", "exit", "return", "delete", "print", "printf", "getline",
                 "include", "load", "namespace", "nsinclude"

    # Strip the brackets, separators, line breaks and other marks, because
    # they are layout. AWK's parser reads `print(a, b)` as `print a, b`.
    # print(a, b);  ->  (print_statement (output_arguments a b))
    # x ? y : z  ->  (conditional_expression x y z)
    # $1  ->  (field_reference 1)
    strip_tokens "(", ")", "{", "}", "[", "]", ",", ";", "\n", "?", ":", "::", "@", "_", "$"

    # Keep the `;` in a `for` header, because they show which of its three
    # parts are empty.
    # for (;i < 3;)  ->  (for_statement ; (binary_expression i < 3) ;)
    keep_tokens ";", in: :for_statement

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value. AWK stores every number as a float, so
    # `1.0` and `1` are the same. AWK reads `0x` and a leading `0` in the
    # program's text as hexadecimal and octal, and has no digit separators.
    #
    # 0x1F  ->  31
    # 011  ->  9
    # 1.50  ->  1.5
    # 1e3  ->  1000
    numbers_are number: :number,
                prefixes: { "0x" => 16, "0" => 8 },
                separators: []

    BUILTIN_VARIABLES = [
      "ARGC", "ARGV", "CONVFMT", "ENVIRON", "FILENAME", "FNR", "FS", "NF", "NR", "OFMT", "OFS", "ORS", "RLENGTH",
      "RS", "RSTART", "SUBSEP", "ARGIND", "BINMODE", "ERRNO", "FIELDWIDTHS", "FPAT", "FUNCTAB", "IGNORECASE", "LINT",
      "PREC", "PROCINFO", "ROUNDMODE", "RT", "SYMTAB", "TEXTDOMAIN"
    ].freeze

    # Each of these builtins fills the arrays, or changes the variable, at
    # these argument positions, counted from 0.
    # split(s, «parts», ",", «separators»)
    # gsub(/a/, "b", «word»)
    ARGUMENTS_FILLED = {
      "split" => [1, 3],
      "patsplit" => [1, 3],
      "match" => [2],
      "asort" => [0, 1],
      "asorti" => [0, 1],
      "sub" => [2],
      "gsub" => [2]
    }.freeze

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\\\\' => "\\",
      '\"' => '"'
    }.freeze

    BODIES = ["consequence", "alternative", "body"].freeze

    def call
      tree.tap do
        drop_line_continuations!
        drop_empty_statements!
        write_strings_as_their_values!
        give_builtin_variables_a_type_of_their_own!
        mark_the_arguments_that_builtins_fill!
        give_length_without_brackets_its_brackets!
        write_blocks_as_statement_lists!
        put_the_statements_of_inner_blocks_into_their_list!
        write_every_body_as_a_statement_list!
      end
    end

    private
    # Drop each `\` at the end of a line, because AWK reads the next line as
    # part of the same line, even inside a string.
    # x = 1 + \<newline>2  ->  x = 1 + 2
    def drop_line_continuations!
      drop(tree, "(line_continuation)")
    end

    # Drop each empty statement, because AWK's parser skips a lone `;`.
    # x = 1;;  ->  x = 1
    def drop_empty_statements!
      drop(tree, "(empty_statement)")
    end

    ### Strings ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a node of its own, so it can't make two different strings
    # the same.
    #
    # "say \"hi\""  ->  say "hi"
    # "a\101"  ->  (string "a" (escape_sequence \101))
    # @include "utils"  ->  (include_directive "utils")
    def write_strings_as_their_values!
      transform(tree, "[(string) (directive_string)] @string") do |match|
        pieces = match.node.named_children.map do |piece|
          piece.type == "escape_sequence" ? ESCAPES.fetch(piece.text, piece) : piece.text
        end
        string_node(pieces)
      end
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end

    ### Names ###

    # Give AWK's own variables a type of their own. AWK defines them, so
    # assigning to one doesn't define a name.
    # FS = ":"  ->  (assignment_expression (builtin_variable FS) = ":")
    def give_builtin_variables_a_type_of_their_own!
      find_all(tree, "(identifier) @name").each do |match|
        match.node.type = "builtin_variable" if BUILTIN_VARIABLES.include?(match.node.text)
      end
    end

    # Give each argument that a builtin fills or changes the field `filled`,
    # so that representation/spec.rb can list it with the other names that are
    # assigned to.
    # split(s, «parts», ",")
    # gsub(/a/, "b", «word»)
    def mark_the_arguments_that_builtins_fill!
      find_all(tree, "(function_call name: (builtin_function) arguments: (argument_list)) @call").each do |match|
        arguments = match.node[:arguments].named_children
        ARGUMENTS_FILLED.fetch(match.node[:name].text, []).each { |index| arguments[index]&.field = "filled" }
      end
    end

    ### Calls and bodies ###

    # Give a bare `length` an empty list of arguments, because AWK's parser
    # reads `length` as `length()`.
    # length  ->  (function_call length (argument_list))
    def give_length_without_brackets_its_brackets!
      find_all(tree, "(function_call !arguments) @call").each do |match|
        match.node.children << build(:argument_list).tap { |list| list.field = "arguments" }
      end
    end

    # Write each block as the list of statements inside it, because AWK's
    # parser reads a block as its statements.
    # { a; b }  ->  (statement_list a b)
    # {}  ->  (statement_list)
    def write_blocks_as_statement_lists!
      transform(tree, "(block) @block") do |match|
        (match.node[:body] || build(:statement_list)).tap { |list| list.field = match.node.field }
      end
    end

    # Put the statements of a block inside a list of statements into that
    # list, because AWK's parser joins them into one list.
    # { a; { b; c } }  ->  (statement_list a b c)
    def put_the_statements_of_inner_blocks_into_their_list!
      transform(tree, "(statement_list) @list") do |match|
        match.node.children = match.node.children.flat_map do |child|
          child.type == "statement_list" ? child.children : [child]
        end
        match.node
      end
    end

    # Write each body of an `if`, a loop or a `do` that isn't a block as a
    # list of one statement, because AWK's parser reads `if (x) y` as
    # `if (x) { y }`.
    # if (x) y  ->  (if_statement x (statement_list y))
    # if (x) y; else if (z) w  ->  (if_statement x (statement_list y) (statement_list (if_statement z ...)))
    def write_every_body_as_a_statement_list!
      each_node(tree) do |node, _|
        next unless node.type.end_with?("_statement")

        node.children.map! { |child| body?(child) ? build(:statement_list, child).tap { |list| list.field = child.field } : child }
      end
    end

    def body?(child) = BODIES.include?(child.field) && child.type != "statement_list"
  end
end
