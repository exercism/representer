# Ruby's GenerateAST stage turns tree-sitter's tree into the tree that
# Ruby's own parser (the `parser` gem, which the old representer used)
# would give. These spellings get the same tree:
#
# - Code with and without comments, layout, `;` and line breaks. The text
#   after `__END__` goes, as the parser drops it.
# - `x if y` and `if y then x end`. The same goes for `unless`, `while` and
#   `until`, except `begin ... end while x`, which runs its body first.
# - `x ? a : b` and `if x then a else b end`.
# - `elsif` and an `if` inside `else`.
# - `unless x then a else b end` and `if x then b else a end`, as the parser
#   writes every `unless` as an `if` with its branches swapped.
# - `do ... end` and `{ ... }` blocks.
# - `->(a) { a }` and `lambda { |a| a }`.
# - `and`, `or`, `not` and `&&`, `||`, `!`.
# - `def f = x` and `def f; x; end`.
# - Empty brackets and none: `def f()` and `def f`, `a.b()` and `a.b`,
#   `foo()` and `foo`. `super()` and `super` stay apart, as `super` passes
#   on the method's arguments.
# - Brackets around arguments and parameters, and brackets that only group:
#   `puts(x)` and `puts x`, `(1 + 2)` and `1 + 2`.
# - `A::b` and `A.b`, and `f.(x)` and `f.call(x)`.
# - `{a: 1}`, `{"a": 1}` and `{:a => 1}`, and `{a:}` and `{a: a}`.
# - `:"a"` and `:a`.
# - Numbers with the same value: `1_000` and `1000`, `0x1F`, `037` and
#   `31`, `1.50` and `1.5`.
# - Strings with the same value: `'a'`, `"a"`, `%q(a)`, `?a` and a heredoc.
#   A `<<~` heredoc loses the indentation that Ruby removes, and a heredoc's
#   closing name goes. Escapes in double quotes are read for `\n`, `\t`,
#   `\s`, `\e`, `\0`, `\\`, `\"`, `\'` and `\#`. Any other escape stays as
#   it is written, so it can't make two different strings the same.
# - `%w[a b]` and `["a", "b"]`, and `%i[a b]` and `[:a, :b]`.
# - `/a/` and `%r{a}`, and a regex's options in any order.
#
# These stay apart, although the parser gives them the same tree:
#
# - `|a,|` and `|a|`. The first takes an array's first element, so the
#   trailing comma becomes an `implicit_rest`, as Prism writes it.
#
# Update this list whenever the class changes.
module Representer
  module Languages
    module Ruby
      class GenerateAST
        include Mandate
        include Engine::TreeHelpers

        initialize_with :tree

        # The tokens that the node types already show. bin/draft-ast-tokens
        # drafted this list from tree-sitter-ruby's grammar, and each token
        # it marked for review was checked by hand.
        #
        # Dropped from every node: keywords and punctuation that sit in a
        # fixed place, and the ones that are only layout although the grammar
        # makes them optional or one of a choice (brackets, commas, `;`,
        # `then`, `do`, the `=` and `end` of methods, `#{` and `}`). The
        # `::` and `.` of a call go too, so `A::b` is `A.b`, but `&.` stays.
        # The string, symbol and array openers never get this far, because
        # the rules below turn those nodes into values.
        TOKENS = %w[
          -> ? BEGIN END __ENCODING__ __FILE__ __LINE__ alias begin break case class def else elsif ensure
          false for if in module next nil redo rescue retry return self super true undef unless until when
          while yield
          ( ) [ ] { } , ; : :: . = => then do end #{
        ].freeze

        # Dropped only from these nodes, because elsewhere they are
        # operators: the `<` of a superclass, the `&` of `&block`, the `*`
        # and `**` of splats, the `|` around block parameters and between
        # alternative patterns, the `^` of a pinned pattern, the `<<` of
        # `class << self`, the backticks of a subshell and the slashes of a
        # regex.
        TOKENS_IN = {
          "superclass" => %w[<], "block_argument" => %w[&], "block_parameter" => %w[&],
          "splat_argument" => %w[*], "splat_parameter" => %w[*], "rest_assignment" => %w[*],
          "hash_splat_argument" => %w[**], "hash_splat_parameter" => %w[**], "hash_splat_nil" => %w[**],
          "block_parameters" => %w[|], "alternative_pattern" => %w[|],
          "variable_reference_pattern" => %w[^], "expression_reference_pattern" => %w[^],
          "singleton_class" => %w[<<], "subshell" => %w[`], "regex" => %w[/]
        }.freeze

        # Kept in these nodes: `|a; b|` makes b a block-local variable.
        TOKENS_KEPT_IN = { "block_parameters" => %w[;] }.freeze

        # The escapes that a double-quoted string reads.
        ESCAPES = {
          "n" => "\n", "t" => "\t", "s" => " ", "e" => "\e", "0" => "\0",
          "\\" => "\\", '"' => '"', "'" => "'", "#" => "#"
        }.freeze

        # Stands for one non-text part of a heredoc while its indentation is
        # removed. Source code can't hold a NUL (see Engine.clean).
        MARK = "\0".freeze

        def call
          drop(tree, "[(comment) (uninterpreted) (empty_statement)]")
          heredocs
          strings
          numbers
          conditionals
          blocks
          methods_and_calls
          drop_tokens(tree, everywhere: TOKENS, only_in: TOKENS_IN, kept_in: TOKENS_KEPT_IN)
          unwrap(tree, "(parenthesized_statements)")
        end

        private
        ### Heredocs ###

        # A heredoc's body follows the line that starts it, so the tree has
        # the body apart from the `<<~NAME`. Each body belongs to the first
        # `<<~NAME` before it that has no body yet. The `<<~NAME` becomes
        # the string, and the body goes.
        def heredocs
          waiting = []
          pairs = []
          each_node(tree) do |node, parent|
            waiting << [node, parent] if node.type == "heredoc_beginning"
            pairs << [*waiting.shift, node] if node.type == "heredoc_body" && waiting.any?
          end
          pairs.each { |beginning, parent, body| parent.replace_child(beginning, heredoc(beginning.text, body)) }
          drop(tree, "(heredoc_body)")
        end

        def heredoc(opening, body)
          parts = body.children.reject { |part| !part.named? || part.type == "heredoc_end" }
          raw = opening.include?("'")
          pieces = parts.map { |part| part.type == "heredoc_content" ? part.text : part }
          pieces[0] = pieces[0].delete_prefix("\n") if pieces.first.is_a?(String)
          # The closing name's own indentation, in a `<<-` or `<<~` heredoc.
          pieces[-1] = pieces[-1].sub(/(?<=\n)[ \t]+\z/, "") if pieces.last.is_a?(String)
          pieces = dedent(pieces) if opening.start_with?("<<~")
          value = string_node(pieces.map { |piece| heredoc_piece(piece, raw:) })
          return value unless opening.include?("`")

          build(:subshell, *(value.type == "literal" ? [value] : value.children))
        end

        # A heredoc in single quotes reads nothing, so every part is its text.
        def heredoc_piece(piece, raw:)
          return piece if piece.is_a?(String)

          raw ? text_of(piece) : string_piece(piece, raw: false)
        end

        # Removes the indentation of the least indented line from every
        # line, as Ruby does for a `<<~` heredoc. Lines with only spaces
        # don't count, and a tab indents to the next multiple of 8.
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

        def strings
          transform(tree, '(string "\"" @quote)') do |match|
            raw = match[:quote].text.start_with?("'", "%q")
            string_node(match.node.named_children.map { |part| string_piece(part, raw:) })
          end
          transform(tree, "(character) @char") { |match| string_node([character(match.node.text[1..])]) }
          transform(tree, "(delimited_symbol) @symbol") do |match|
            symbol(string_node(match.node.named_children.map { |part| string_piece(part, raw: false) }))
          end
          transform(tree, "(hash_key_symbol) @key") { |match| leaf(:simple_symbol, ":#{match.node.text}") }
          hash_keys
          transform(tree, "(string_array) @words") do |match|
            build(:array, *match.node.named_children.map { |word| word_value(word) })
          end
          transform(tree, "(symbol_array) @words") do |match|
            build(:array, *match.node.named_children.map { |word| symbol(word_value(word)) })
          end
          regexes
        end

        # A string's text, or a node for an interpolation or an escape that
        # isn't read. A raw string (single-quoted) only reads `\\` and `\'`.
        def string_piece(part, raw:)
          case part.type
          when "string_content" then raw ? part.text.gsub(/\\([\\'])/, '\1') : part.text
          when "escape_sequence" then raw ? part.text : ESCAPES.fetch(part.text[1..], part)
          else part
          end
        end

        def character(text) = text.start_with?("\\") && text.size > 1 ? ESCAPES.fetch(text[1..], text) : text

        # A word's value, in `%w[a b]` or `%i[a b]`.
        def word_value(word) = string_node(word.children.map { |part| string_piece(part, raw: true) })

        # A string's value, from its pieces: a literal if it is all text, or
        # a string of literals and other nodes. Neighbouring text joins up.
        def string_node(pieces)
          runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
          parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
          return parts.first if parts.one? && parts.first.type == "literal"
          return literal("") if parts.empty?

          build(:string, *parts)
        end

        # The symbol with a string's value: `:"a"` is `:a`.
        def symbol(value)
          return leaf(:simple_symbol, ":#{value.text}") if value.type == "literal"

          build(:delimited_symbol, *value.children)
        end

        # `{"a": 1}` has the key `:a`, and `{a:}` is `{a: a}`.
        def hash_keys
          transform(tree, '(pair key: (_) @key ":" @colon)') do |match|
            key = match[:key]
            next nil if key.type == "simple_symbol" && match.node[:value]

            match.node.replace_child(key, symbol(key)) unless key.type == "simple_symbol"
            match.node.children << leaf(:identifier, key.text.delete_prefix(":"), field: :value) unless match.node[:value]
            match.node
          end
        end

        # A regex keeps its source text, as Ruby reads it, and its options
        # (`/a/i`) sorted, without its delimiters.
        def regexes
          transform(tree, '(regex "/" @open)') do |match|
            options = match.node.children.last.text[/[a-z]*\z/].chars.sort.uniq.join
            pieces = match.node.named_children.map { |part| part.type == "interpolation" ? part : part.text }
            value = string_node(pieces)
            parts = value.type == "literal" ? [value] : value.children
            build(:regex, *parts, (leaf(:regex_options, options) unless options.empty?))
          end
        end

        ### Numbers ###

        # A number is its value. `0d` is a decimal prefix, and a leading 0
        # makes an integer octal.
        def numbers
          prefixes = Engine::Numbers::PREFIXES.merge("0d" => 10)
          number(:integer) do |text|
            text = "0o#{text[1..]}" if text.match?(/\A0[0-7_]/)
            Engine::Numbers.integer(text, prefixes:)&.to_s
          end
          number(:float) do |text|
            value = Engine::Numbers.decimal(text)
            value && Engine::Numbers.write_decimal(value)
          end
        end

        def number(type)
          each_node(tree) do |node, _|
            next unless node.type == type.to_s && node.leaf?

            text = yield(node.text)
            node.text = text if text
          end
        end

        ### Conditionals and loops ###

        def conditionals
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
          # `begin ... end while x` runs the body before the first check.
          %w[while until].each do |loop|
            transform(tree, "(#{loop}_modifier body: (_) @body condition: (_) @condition)") do |match|
              build(loop, { condition: match[:condition] }, { body: build(:do, match[:body]) }) unless match[:body].type == "begin"
            end
          end
          # An empty `then` or `else` is the same as none.
          each_node(tree) do |node, _|
            node.children.reject! { |child| child.named? && %w[then else].include?(child.type) && child.named_children.empty? }
          end
          { "and" => "&&", "or" => "||", "not" => "!" }.each do |word, symbol|
            each_node(tree) do |node, _|
              node.type = symbol if !node.named? && node.type == word
            end
          end
        end

        ### Blocks, methods and calls ###

        # A `do` block is a `{` block, and a lambda is a call of `lambda`
        # with a block. `|a,|` keeps its trailing comma as an implicit rest.
        def blocks
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

        EMPTY_LISTS = %w[method_parameters block_parameters argument_list].freeze

        def methods_and_calls
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
          # `f.(x)` calls f's `call` method.
          transform(tree, "(call receiver: (_) !method arguments: (_) @arguments)") do |match|
            match.node.children.insert(match.node.children.index(match[:arguments]), leaf(:identifier, "call", field: :method))
            match.node
          end
          transform(tree, "(call !receiver !arguments !block method: (identifier) @name)") { |match| match[:name] }
        end
      end
    end
  end
end
