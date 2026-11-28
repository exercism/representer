# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Ruby's own parser (the `parser` gem) gives.
module Representer::Languages::Ruby::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # def f(x) ... end  ->  (method f (method_parameters x) ...)
    strip_tokens "alias", "begin", "break", "case", "class", "def", "do", "else", "elsif", "end", "ensure", "for",
                 "if", "in", "module", "next", "redo", "rescue", "retry", "return", "super", "then", "undef", "unless",
                 "until", "when", "while", "yield"

    # Strip the keywords that are values, because the node types already show them.
    # nil  ->  (nil)
    strip_tokens "false", "nil", "self", "true", "__ENCODING__", "__FILE__", "__LINE__", "BEGIN", "END"

    # Strip the brackets, commas and other punctuation, because they are layout.
    # Keep `&.`, because it differs from `.`.
    # puts(x)  ->  puts x
    # A::b  ->  A.b
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";", ":", "::", ".", "=", "=>", "->", "?", "\#{"

    # Strip these tokens only from the nodes listed, because elsewhere they are
    # operators.
    # class A < B  ->  (class A (superclass B)), and a < b keeps its `<`
    # f(&block), f(*args), f(**options)  ->  (block_argument block) ...
    # xs.map { |x| x }  ->  (block (block_parameters x) x)
    # in ^x, class << self, `ls` and /a/ lose their `^`, `<<`, backticks and slashes
    strip_tokens "<", only_in: :superclass
    strip_tokens "&", only_in: [:block_argument, :block_parameter]
    strip_tokens "*", only_in: [:splat_argument, :splat_parameter, :rest_assignment]
    strip_tokens "**", only_in: [:hash_splat_argument, :hash_splat_parameter, :hash_splat_nil]
    strip_tokens "|", only_in: [:block_parameters, :alternative_pattern]
    strip_tokens "^", only_in: [:variable_reference_pattern, :expression_reference_pattern]
    strip_tokens "<<", only_in: :singleton_class
    strip_tokens "`", only_in: :subshell
    strip_tokens "/", only_in: :regex

    # Keep the `;` in block parameters, because `|a; b|` makes b a block-local variable.
    # xs.each { |a; b| ... } keeps its `;`
    keep_tokens ";", in: :block_parameters

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (1 + 2)  ->  1 + 2
    unwrap :parenthesized_statements

    # Write each number as its value. A `0d` prefix means decimal, and a
    # leading 0 means octal.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 037  ->  31
    # 1.50  ->  1.5
    numbers_are integer: :integer,
                decimal: :float,
                prefixes: { "0x" => 16, "0o" => 8, "0b" => 2, "0d" => 10, "0" => 8 }

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\s' => " ",
      '\e' => "\e",
      '\0' => "\0",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'",
      '\#' => "#"
    }.freeze

    # Stand in for one non-text part of a heredoc while its indentation is
    # removed. Source code can't hold a NUL (see Engine.clean).
    MARK = "\0".freeze

    def call
      tree.tap do
        drop_empty_statements_and_text_after_end!
        turn_heredocs_into_strings!
        write_strings_symbols_and_word_lists_as_values!
        write_conditions_and_loops_in_one_shape!
        write_blocks_and_lambdas_in_one_shape!
        write_methods_and_calls_in_one_shape!
        mark_class_and_module_bodies!
      end
    end

    private
    # Drop empty statements and the text after `__END__`, because Ruby never runs them.
    def drop_empty_statements_and_text_after_end!
      drop(tree, "[(uninterpreted) (empty_statement)]")
    end

    ### Heredocs ###

    # Turn each heredoc into a string with the same value. Remove the indentation
    # that Ruby removes from a `<<~` heredoc, and the closing name.
    #
    # e.g. We convert:
    # x = <<~TEXT
    #   hello
    # TEXT
    #
    # internally into:
    # x = "hello\n"
    #
    # A heredoc's body follows the line that starts it, so the tree has the body
    # apart from the `<<~TEXT`. Give each body to the first `<<~TEXT` before it
    # that has no body yet.
    def turn_heredocs_into_strings!
      waiting = []
      pairs = []
      each_node(tree) do |node, parent|
        waiting << [node, parent] if node.type == "heredoc_beginning"
        pairs << [*waiting.shift, node] if node.type == "heredoc_body" && waiting.any?
      end
      pairs.each { |beginning, parent, body| parent.replace_child(beginning, heredoc_to_string(beginning.text, body)) }
      drop(tree, "(heredoc_body)")
    end

    def heredoc_to_string(opening, body)
      parts = body.children.reject { |part| !part.named? || part.type == "heredoc_end" }
      raw = opening.include?("'")
      pieces = parts.map { |part| part.type == "heredoc_content" ? part.text : part }
      pieces[0] = pieces[0].delete_prefix("\n") if pieces.first.is_a?(String)

      # Remove the closing name's own indentation, in a `<<-` or `<<~` heredoc.
      pieces[-1] = pieces[-1].sub(/(?<=\n)[ \t]+\z/, "") if pieces.last.is_a?(String)
      pieces = dedent(pieces) if opening.start_with?("<<~")
      value = string_node(pieces.map { |piece| heredoc_piece(piece, raw:) })
      return value unless opening.include?("`")

      build(:subshell, *(value.type == "literal" ? [value] : value.children))
    end

    # Keep every part of a single-quoted heredoc as its text, because it reads no escapes or interpolation.
    def heredoc_piece(piece, raw:)
      return piece if piece.is_a?(String)

      raw ? text_of(piece) : string_piece(piece, raw: false)
    end

    # Remove the indentation of the least indented line from every line, as
    # Ruby does for a `<<~` heredoc. Lines with only spaces don't count, and a
    # tab indents to the next multiple of 8.
    def dedent(pieces)
      nodes = pieces.grep_v(String)
      text = pieces.sum("") { |piece| piece.is_a?(String) ? piece : MARK }
      lines = text.split(/(?<=\n)/)
      indent = lines.reject { |line| line.match?(/\A[ \t]*\n?\z/) }.map { |line| width(line[/\A[ \t]*/]) }.min || 0
      text = lines.sum("") { |line| remove_indent(line, indent) }
      text.split(/(#{MARK})/o).reject(&:empty?).map { |piece| piece == MARK ? nodes.shift : piece }
    end

    def width(space) = space.each_char.reduce(0) { |column, char| char == "\t" ? ((column / 8) + 1) * 8 : column + 1 }

    def remove_indent(line, indent)
      removed = 0
      removed += 1 while removed < line.size && line[removed].match?(/[ \t]/) && width(line[0..removed]) <= indent
      line[removed..]
    end

    ### Strings, symbols and regexes ###

    # Turn each string, symbol and word list into its value, and read the escapes
    # of a double-quoted string. Keep any other escape as it is written, so it
    # can't make two different strings the same.
    #
    # 'a'  ->  "a"
    # %q(a)  ->  "a"
    # ?a  ->  "a"
    # :"a"  ->  :a
    # %w[a b]  ->  ["a", "b"]
    # %i[a b]  ->  [:a, :b]
    def write_strings_symbols_and_word_lists_as_values!
      transform(tree, '(string "\"" @quote)') do |match|
        raw = match[:quote].text.start_with?("'", "%q")
        string_node(match.node.named_children.map { |part| string_piece(part, raw:) })
      end
      transform(tree, "(character) @char") { |match| string_node([character(match.node.text[1..])]) }
      transform(tree, "(delimited_symbol) @symbol") do |match|
        symbol(string_node(match.node.named_children.map { |part| string_piece(part, raw: false) }))
      end
      transform(tree, "(hash_key_symbol) @key") { |match| leaf(:simple_symbol, ":#{match.node.text}") }
      write_every_hash_key_the_same_way!
      transform(tree, "(string_array) @words") do |match|
        build(:array, *match.node.named_children.map { |word| word_value(word) })
      end
      transform(tree, "(symbol_array) @words") do |match|
        build(:array, *match.node.named_children.map { |word| symbol(word_value(word)) })
      end
      write_regexes_as_source_and_sorted_options!
    end

    # Return a string part's text, or its node if it is an interpolation or an
    # escape that isn't read. A raw (single-quoted) string only reads `\\` and `\'`.
    def string_piece(part, raw:)
      case part.type
      when "string_content" then raw ? part.text.gsub(/\\([\\'])/, '\1') : part.text
      when "escape_sequence" then raw ? part.text : ESCAPES.fetch(part.text, part)
      else part
      end
    end

    def character(text) = ESCAPES.fetch(text, text)

    # Return the value of one word in `%w[a b]` or `%i[a b]`.
    def word_value(word) = string_node(word.children.map { |part| string_piece(part, raw: true) })

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and other nodes. Join neighbouring text.
    #
    # "a\nb" is one literal, and "a#{x}b" is a string of "a", x and "b".
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return parts.first if parts.one? && parts.first.type == "literal"
      return literal("") if parts.empty?

      build(:string, *parts)
    end

    # Build the symbol that has a string's value.
    # :"a"  ->  :a
    def symbol(value)
      return leaf(:simple_symbol, ":#{value.text}") if value.type == "literal"

      build(:delimited_symbol, *value.children)
    end

    # Give every hash key the same shape, and fill in a missing value.
    #
    # {"a": 1}  ->  {a: 1}
    # {:a => 1}  ->  {a: 1}
    # {a:}  ->  {a: a}
    def write_every_hash_key_the_same_way!
      transform(tree, '(pair key: (_) @key ":" @colon)') do |match|
        key = match[:key]
        next nil if key.type == "simple_symbol" && match.node[:value]

        match.node.replace_child(key, symbol(key)) unless key.type == "simple_symbol"
        match.node.children << leaf(:identifier, key.text.delete_prefix(":"), field: :value) unless match.node[:value]
        match.node
      end
    end

    # Keep a regex's source text and its options, sorted, and drop its delimiters.
    #
    # %r{a}  ->  /a/
    # /a/mi  ->  /a/im
    def write_regexes_as_source_and_sorted_options!
      transform(tree, '(regex "/" @open)') do |match|
        options = match.node.children.last.text[/[a-z]*\z/].chars.sort.uniq.join
        pieces = match.node.named_children.map { |part| part.type == "interpolation" ? part : part.text }
        value = string_node(pieces)
        parts = value.type == "literal" ? [value] : value.children
        build(:regex, *parts, (leaf(:regex_options, options) unless options.empty?))
      end
    end

    ### Conditionals and loops ###

    # Give every way of writing a condition or a loop the tree that Ruby's
    # parser gives it.
    #
    # - `x if y` becomes `if y then x end`. `unless`, `while` and `until` work
    #   the same way, except `begin ... end while x`, which runs its body before
    #   the first check.
    # - `x ? a : b` becomes `if x then a else b end`.
    # - `elsif` becomes an `if` inside `else`.
    # - `unless x then a else b end` becomes `if x then b else a end`, because
    #   the parser writes every `unless` as an `if` with swapped branches.
    # - `and`, `or` and `not` become `&&`, `||` and `!`.
    def write_conditions_and_loops_in_one_shape!
      transform(tree, "(if_modifier body: (_) @body condition: (_) @condition)",
        "(if condition: @condition consequence: (then @body))")
      transform(tree, "(unless_modifier body: (_) @body condition: (_) @condition)",
        "(unless condition: @condition consequence: (then @body))")
      transform(tree, "(conditional condition: (_) @condition consequence: (_) @then alternative: (_) @else)",
        "(if condition: @condition consequence: (then @then) alternative: (else @else))")
      transform(tree, "(elsif) @elsif") { |match| build(:else, build(:if, *match.node.named_children)) }
      transform(tree, "(unless condition: (_) @condition consequence: (then)? @then alternative: (else)? @else)") do |match|
        build(:if, { condition: match[:condition] },
          { consequence: (build(:then, *match[:else].named_children) if match[:else]) },
          { alternative: (build(:else, *match[:then].named_children) if match[:then]) })
      end

      # Leave `begin ... end while x` alone, because it runs the body before the first check.
      ["while", "until"].each do |loop|
        transform(tree, "(#{loop}_modifier body: (_) @body condition: (_) @condition)") do |match|
          build(loop, { condition: match[:condition] }, { body: build(:do, match[:body]) }) unless match[:body].type == "begin"
        end
      end

      # Drop an empty `then` or `else`.
      each_node(tree) do |node, _|
        node.children.reject! { |child| child.named? && ["then", "else"].include?(child.type) && child.named_children.empty? }
      end
      { "and" => "&&", "or" => "||", "not" => "!" }.each do |word, symbol|
        each_node(tree) do |node, _|
          node.type = symbol if !node.named? && node.type == word
        end
      end
    end

    ### Blocks, methods and calls ###

    # Give blocks and lambdas one shape, and keep the trailing comma of `|a,|`,
    # because it makes the block take an array's first element. Ruby's parser
    # drops it, so turn it into an `implicit_rest`, as Prism does.
    #
    # xs.each do |x| ... end  ->  xs.each { |x| ... }
    # ->(a) { a }  ->  lambda { |a| a }
    def write_blocks_and_lambdas_in_one_shape!
      retype(tree, do_block: :block, block_body: :body_statement)
      each_node(tree) do |node, _|
        next unless node.type == "block_parameters"

        closing = node.children.rindex { |child| !child.named? && child.type == "|" }
        comma = closing&.positive? && node.children[closing - 1]
        node.children[closing - 1] = build(:implicit_rest) if comma && !comma.named? && comma.type == ","
      end
      transform(tree, "(lambda parameters: (lambda_parameters)? @parameters body: (_) @body)") do |match|
        if match[:parameters]
          match[:parameters].type = "block_parameters"
          match[:body].children.unshift(match[:parameters])
        end
        build(:call, { method: leaf(:identifier, "lambda") }, { block: match[:body] })
      end
    end

    EMPTY_LISTS = ["method_parameters", "block_parameters", "argument_list"].freeze

    # Give methods and calls one shape. Drop empty brackets, except on `super`,
    # because `super` passes on the method's arguments and `super()` doesn't.
    #
    # def f = x  ->  def f; x; end
    # def f()  ->  def f
    # a.b()  ->  a.b
    # f.(x)  ->  f.call(x)
    def write_methods_and_calls_in_one_shape!
      transform(tree, '[(method "=" @equals body: (_) @body) (singleton_method "=" @equals body: (_) @body)]') do |match|
        match.node.children.delete(match[:equals])
        match.node.replace_child(match[:body], build(:body_statement, match[:body]))
        match.node
      end
      each_node(tree) do |node, _|
        node.children.reject! do |child|
          EMPTY_LISTS.include?(child.type) && child.named_children.empty? && node[:method]&.type != "super"
        end
      end

      # Add the missing `call` to `f.(x)`.
      transform(tree, "(call receiver: (_) !method arguments: (_) @arguments)") do |match|
        match.node.children.insert(match.node.children.index(match[:arguments]), leaf(:identifier, "call", field: :method))
        match.node
      end
      transform(tree, "(call !receiver !arguments !block method: (identifier) @name)") { |match| match[:name] }
    end

    ### Classes and modules ###

    # Mark the body of each class as a `class_body` and of each module as a
    # `module_body`, so that Normalise and Reorder can tell them apart from a
    # method's body.
    def mark_class_and_module_bodies!
      captured(tree, "(class body: (body_statement) @name)").each { |body| body.type = "class_body" }
      captured(tree, "(module body: (body_statement) @name)").each { |body| body.type = "module_body" }
    end
  end
end
