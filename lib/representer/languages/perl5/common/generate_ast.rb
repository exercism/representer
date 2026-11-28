# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, with one form for each spelling that Perl's parser reads the
# same way.
module Representer::Languages::Perl5::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Perl reads `foreach` as `for`, `m/a/` as `/a/`, and
    # `y/a/b/` as `tr/a/b/`.
    # foreach my $x (@list) { ... }  ->  (for_statement my (scalar $ x) (array @ list) (block ...))
    strip_tokens "sub", "method", "return", "package", "class", "require", "else", "elsif", "undef", "for",
                 "foreach"
    strip_tokens "m", only_in: :match_regexp
    strip_tokens "s", only_in: :substitution_regexp
    strip_tokens "tr", "y", only_in: :transliteration_expression

    # Strip the brackets, separators, arrows, quotes and other marks, because
    # they are layout or the node types already show them. Perl's parser
    # reads `f(a, b)` as `f a, b`, `a => 1` as `"a", 1`, and `$x->[0]->[1]`
    # as `$x->[0][1]`.
    # foo(1, 2);  ->  (function_call_expression (function foo) (list_expression 1 2))
    # $x ? 1 : 2  ->  (conditional_expression (scalar $ x) 1 2)
    # \@list  ->  (refgen_expression (array @ list))
    strip_tokens "(", ")", "{", "}", "[", "]", ",", "=>", ";", "->", ":", "?", "\\", "'"

    # Keep the brackets of `my ($x) = @list`, because they make it a list
    # assignment, which gives $x the first item and not the count.
    # my ($x) = @list;  ->  (variable_declaration my "(" (scalar $ x) ")")
    keep_tokens "(", ")", in: :variable_declaration

    # Keep the `;` in a C-style `for` header, because they show which of its
    # three parts are empty.
    # for (;$i < 3;) { ... }  ->  (cstyle_for_statement ; (relational_expression ...) ; (block ...))
    keep_tokens ";", in: :cstyle_for_statement

    # Keep the brackets of a slice, because `@x[0, 1]` takes items of the
    # array @x and `@x{0, 1}` takes values of the hash %x.
    # @x{0, 1}  ->  (slice_expression (slice_container_variable @ x) { (list_expression 0 1) })
    keep_tokens "[", "]", "{", "}", in: [:slice_expression, :keyval_expression]

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. The brackets that make a list stay (see make_lists_of_brackets_that_make_lists!).
    # ($a + $b) * $c  ->  (binary_expression (binary_expression (scalar $ a) + (scalar $ b)) * (scalar $ c))
    unwrap :parenthesized_expression

    # Write each statement as its expression, because Perl's parser reads a
    # block as a list of statements.
    # { $x = 1; }  ->  (block (assignment_expression (scalar $ x) = 1))
    unwrap :expression_statement

    # Write each number as its value. Perl stores an integer and a decimal in
    # different ways, so `1.0` and `1` stay apart.
    #
    # 0x1F  ->  31
    # 017  ->  15
    # 0b101  ->  5
    # 1_000  ->  1000
    # 1e3  ->  1000.0
    numbers_are integer: :number,
                decimal: :number,
                prefixes: { "0x" => 16, "0b" => 2, "0o" => 8, "0" => 8 }

    # Perl gives these names their meaning, so declaring one with `our`
    # doesn't define a name of the solution's own.
    PERLS_OWN_NAMES = ["ISA", "EXPORT", "EXPORT_OK", "EXPORT_TAGS", "VERSION", "AUTOLOAD", "DESTROY"].freeze

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\\\\' => "\\",
      '\"' => '"',
      '\$' => "$",
      '\@' => "@"
    }.freeze

    def call
      tree.tap do
        put_heredocs_in_place!
        write_pragmas_as_pragmas!
        take_the_field_off_the_version_of_a_use!
        mark_the_constants_that_use_constant_defines!
        mark_the_variables_that_are_declared!
        write_strings_as_their_values!
        write_word_lists_as_lists_of_strings!
        write_autoquoted_words_as_strings!
        write_regular_expressions_as_their_text!
        write_every_call_of_a_function_the_same_way!
        make_lists_of_brackets_that_make_lists!
      end
    end

    private
    ### Strings ###

    # Move each heredoc's body to the place of its `<<` marker, as a string,
    # because Perl's parser reads the heredoc as a string there. A `<<~`
    # heredoc loses the indentation of its closing marker from every line.
    # my $s = <<~END;\n  hi\n  END\n  ->  (assignment_expression (variable_declaration my (scalar $ s)) = "hi\n")
    def put_heredocs_in_place!
      bodies = find_all(tree, "(heredoc_content) @body").map(&:node)
      markers = []
      each_node(tree) { |node, parent| markers << [node, parent] if node.type == "heredoc_token" }
      markers.zip(bodies).each do |(marker, parent), body|
        parent.replace_child(marker, heredoc_string(marker.text, body)) if body
      end
      drop(tree, "(heredoc_content)")
    end

    def heredoc_string(marker, body)
      parts = body.children.reject { |child| child.type == "heredoc_end" }
      if marker.start_with?("<<~")
        indentation = parts.last&.text.to_s[/[ \t]*\z/]
        parts.each { |part| part.text = part.text.gsub(/^#{Regexp.escape(indentation)}/, "") if part.type == "fragment" }
      end
      string_node(parts.map { |piece| marker.match?(/\A<<~?'/) ? quoted_piece(piece) : interpolated_piece(piece) })
    end

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a node of its own, so it can't make two different strings
    # the same. Perl reads `'a'`, `"a"`, `q{a}` and `qq{a}` as the same
    # string. A string that interpolates keeps the code inside it.
    #
    # 'it\'s'  ->  "it's"
    # "\$5"  ->  "$5"
    # "Hi, $name!"  ->  (string "Hi, " (scalar $ name) "!")
    # "\x41"  ->  (string (escape_sequence \x) "41")
    def write_strings_as_their_values!
      transform(tree, "[(string_literal) (interpolated_string_literal)] @string") do |match|
        quoted = match.node.type == "string_literal"
        string_node(pieces_of(match.node[:content]).map { |piece| quoted ? quoted_piece(piece) : interpolated_piece(piece) })
      end
    end

    # Return the pieces of a string's content. The grammar gives content
    # with no escapes or code in it as one leaf.
    def pieces_of(content)
      return [] unless content

      content.leaf? ? [leaf(:fragment, content.text)] : content.children
    end

    def quoted_piece(piece)
      return piece.text.delete_prefix("\\") if piece.type == "escaped_delimiter" || piece.text == '\\\\'
      return piece if piece.named? && piece.type != "fragment"

      piece.text
    end

    def interpolated_piece(piece)
      return piece.text.delete_prefix("\\") if piece.type == "escaped_delimiter"
      return ESCAPES.fetch(piece.text, piece) if piece.type == "escape_sequence"
      return piece if piece.named? && piece.type != "fragment"

      piece.text
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and nodes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end

    # Write each word list as a list of strings, because Perl's parser reads
    # `qw(a b)` as `("a", "b")`. In a list, the words join the list.
    # qw(a b)  ->  (list_expression "a" "b")
    # qw(a)  ->  "a"
    # ("x", qw(a b))  ->  (list_expression "x" "a" "b")
    def write_word_lists_as_lists_of_strings!
      lists = []
      each_node(tree) { |node, parent| lists << [node, parent] if node.type == "quoted_word_list" }
      lists.each do |list, parent|
        words = pieces_of(list[:content]).sum("", &:text).split.map { |word| literal(word) }
        if parent.type == "list_expression"
          parent.children[parent.children.index { |child| child.equal?(list) }, 1] = words
        else
          parent.replace_child(list, words.one? ? words.first : build(:list_expression, *words))
        end
      end
    end

    # Write each word that `=>` or a hash subscript quotes as a string,
    # because Perl's parser reads it as one.
    # (a => 1)  ->  (list_expression "a" 1)
    # $h{key}  ->  (hash_element_expression (container_variable $ h) "key")
    def write_autoquoted_words_as_strings!
      transform(tree, "(autoquoted_bareword) @word") { |match| literal(text_of(match.node)) }
    end

    # Write each regular expression, transliteration and replacement as its
    # text, because Perl's parser keeps them as text. The code they
    # interpolate stays code. Perl reads the flags in any order.
    #
    # m{\d+}i  ->  (match_regexp "\d+" "i")
    # s/a/$b/gx  ->  (substitution_regexp s "a" (replacement (scalar $ b)) "gx")
    # tr/a-z/A-Z/  ->  (transliteration_expression tr "a-z" (replacement "A-Z"))
    def write_regular_expressions_as_their_text!
      transform(tree, "[(regexp_content) (transliteration_content) (replacement)] @content") do |match|
        pieces = pieces_of(match.node).map { |piece| piece.named? && !piece.leaf? ? piece : piece.text }
        node = string_node(pieces)
        match.node.type == "replacement" ? build(:replacement, node) : node
      end
      each_node(tree) do |node, _|
        node.text = node.text.chars.sort.join if node.type.end_with?("_modifiers") && node.leaf?
      end
    end

    ### Calls ###

    # Write every call of a function the same way, with or without brackets,
    # because Perl's parser reads `f(x)` as `f x`.
    # print("hi")  ->  (function_call_expression (function print) "hi")
    def write_every_call_of_a_function_the_same_way!
      retype(tree, ambiguous_function_call_expression: :function_call_expression)
    end

    # Write a list in brackets that Perl reads as a list as a list, so the
    # brackets don't unwrap. The brackets on the left of `=` make a list
    # assignment, and the brackets on the left of `x` repeat a list.
    # ($x) = @list  ->  (assignment_expression (list (scalar $ x)) = (array @ list))
    # (0) x 3  ->  (binary_expression (list 0) x 3)
    def make_lists_of_brackets_that_make_lists!
      each_node(tree) do |node, _|
        left = node[:left]
        next unless left&.type == "parenthesized_expression"
        next unless node.type == "assignment_expression" || node[:operator]&.type == "x"

        left.type = "list"
      end
    end

    ### Names ###

    # Give each `use` of a pragma a type of its own. Perl's pragmas have names
    # in lower case, and change how Perl reads the code around them, so
    # representation/spec.rb drops only the modules and the pragmas that can't
    # change a passing solution.
    # use feature 'say';  ->  (pragma_statement use (package feature) "say")
    # use List::Util 'sum';  ->  (use_statement use (package List::Util) "sum")
    def write_pragmas_as_pragmas!
      find_all(tree, "(use_statement module: (package) @module) @use").each do |match|
        match.node.type = "pragma_statement" if match.captures["module"].text.match?(/\A[a-z]/)
      end
    end

    # Take the field off the version that a `use` asks for, so that
    # representation/spec.rb's `use {{Module}} {{...}}` also matches
    # `use List::Util 1.45 qw(sum);`. A code pattern can't hold a
    # placeholder where Perl expects a version.
    # use List::Util 1.45;  ->  (use_statement use (package List::Util) 1.45)
    def take_the_field_off_the_version_of_a_use!
      find_all(tree, "(use_statement version: (_) @version)").each do |match|
        match.captures["version"].field = nil
      end
    end

    # Give each name that `use constant` defines the type of a function name,
    # and the field `constant`, so that representation/spec.rb can list it with
    # the other definitions. Perl reads `use constant PI => 3` as a function
    # called PI.
    # use constant PI => 3.14;  ->  (pragma_statement use (package constant) (list_expression «PI» 3.14))
    # use constant { A => 1, B => 2 };  ->  (... (anonymous_hash_expression (list_expression «A» 1 «B» 2)))
    def mark_the_constants_that_use_constant_defines!
      find_all(tree, '(pragma_statement module: (package "constant")) @use').each do |match|
        list = match.node.named_children[1]
        list = list.named_children.first if list&.type == "anonymous_hash_expression"
        next unless list&.type == "list_expression"

        list.children.each_cons(2) do |name, arrow|
          next unless name.type == "autoquoted_bareword" && name.leaf? && arrow.type == "=>"

          name.type = "function"
          name.field = "constant"
        end
      end
    end

    # Give the name of each variable that `my`, `our`, `state`, `field`, a
    # `for` loop or a signature declares the field `declared`, so that
    # representation/spec.rb can list it as a definition.
    # my ($x, @y) = @_;  ->  my ($«x», @«y») = @_;
    # for my ($k, $v) (%h) { ... }  ->  for my ($«k», $«v») (%h) { ... }
    # sub f ($n, $m = 1) { ... }  ->  sub f ($«n», $«m» = 1) { ... }
    def mark_the_variables_that_are_declared!
      declared = find_all(tree, "[(variable_declaration) (for_statement)] @declaration").flat_map do |match|
        match.node.children.select { |child| ["variable", "variables"].include?(child.field) }
      end
      parameters = find_all(tree, "[(mandatory_parameter) (optional_parameter) (slurpy_parameter)] @parameter")
      declared += parameters.map { |match| match.node.named_children.first }
      declared.each do |variable|
        name = variable&.children&.find { |child| child.type == "varname" && child.leaf? }
        name.field = "declared" if name && !PERLS_OWN_NAMES.include?(name.text)
      end
    end
  end
end
