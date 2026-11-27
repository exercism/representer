# Elixir's GenerateAST stage turns tree-sitter's tree into the tree given by
# Elixir's own parser (`Code.string_to_quoted`), which the old representer
# used. This stage gives each of these pairs the same tree:
#
# - Code with and without comments, layout and `;` gets the same tree.
# - Brackets around arguments go, and so do brackets that only group. So
#   `IO.puts(x)` is `IO.puts x`, and `(1 + 2)` is `1 + 2`.
# - `f x, do: a, else: b` gets the tree of `f x do a else b end`.
# - `Mod.f` gets the tree of `Mod.f()`, and `x.f` the tree of `x.f()`.
#   `f` and `f()` stay apart, because the parser reads `f` as a variable.
# - `[a: 1]` gets the tree of `[{:a, 1}]`, and `%{a: 1}` the tree of
#   `%{:a => 1}`. A keyword list at the end of a call's arguments gets the
#   tree of the same list in brackets, so `f(x, a: 1)` is `f(x, [a: 1])`.
# - `:"a"` gets the tree of `:a`.
# - Numbers with the same value get the same tree. So `1_000` is `1000`,
#   `0x1F` and `0b11111` are `31`, `1.50` is `1.5`, and `?a` is `97`.
# - Strings with the same value get the same tree. So `"a\nb"` is the same
#   as a heredoc that holds the same two lines, after Elixir removes the
#   indentation of the closing `"""`. This stage reads the escapes `\n`,
#   `\t`, `\r`, `\s`, `\e`, `\0`, `\\`, `\"`, `\'` and `\#`. Any other
#   escape stays as it is written, so it can't make two different strings
#   the same.
# - `''` gets the tree of `[]`.
#
# It also gives the code that defines a name a node type of its own, so
# that elixir.rb can list it in names_are_defined_by:
#
# - The name of a `defmodule` or `defprotocol` becomes a `module_name`.
#   Every module name is split into its parts, so `Foo.Bar` defines both
#   `Foo` and `Bar`.
# - The head of a `def`, `defp`, `defmacro`, `defmacrop`, `defguard`,
#   `defguardp` or `defdelegate` becomes a `function_head`.
# - The `t :: ...` of `@type`, `@typep` and `@opaque` becomes a
#   `type_definition`.
# - `@name` with no value (reading an attribute) becomes an `attribute`.
#   Elixir's own attributes, such as `@impl` and `@spec`, are only ever
#   set, so a solution only reads its own attributes.
# - Each variable bound by a pattern is wrapped in a `variable` node. The
#   patterns are a function's parameters and the left of `=`, `<-` and
#   `->`. A pinned `^x` binds nothing, and neither does `_`.
#
# Update this list whenever the class changes.
module Representer
  module Languages
    module Elixir
      class GenerateAST < Engine::GenerateAST
        # Punctuation and keywords that sit in a fixed place, so the node
        # types already show them.
        TOKENS = %w[( ) [ ] { } << >> , ; % do end fn else rescue catch after nil #{].freeze

        # The escapes that a string reads.
        ESCAPES = {
          "n" => "\n", "t" => "\t", "r" => "\r", "s" => " ", "e" => "\e", "0" => "\0",
          "\\" => "\\", '"' => '"', "'" => "'", "#" => "#"
        }.freeze

        DEFINITIONS = /\A(def|defp|defmacro|defmacrop|defguard|defguardp|defdelegate)\z/

        def call
          drop(tree, "(comment)")
          values
          unwrap(tree, "(block)")
          do_keywords
          keyword_lists
          transform(tree, "(call target: (dot right: (_)) (arguments) @arguments)") do |match|
            match.node.children.delete(match[:arguments]) if match[:arguments].named_children.empty?
            match.node
          end
          definitions
          variables
          drop_tokens(tree, everywhere: TOKENS)
        end

        private
        ### Values ###

        def values
          transform(tree, '(string quoted_start: /\A"("")?\z/ @quote)') do |match|
            parts = match.node.named_children
            parts = heredoc(parts) if match[:quote].text == '"""'
            string_node(parts)
          end
          transform(tree, "(charlist) @charlist") { |match| build(:list) if match.node.named_children.empty? }
          transform(tree, "(quoted_atom (quoted_content) @name)") do |match|
            leaf(:atom, ":#{match[:name].text}") if match.node.named_children.one? && match[:name].text.match?(/\A[a-zA-Z_]\w*[?!]?\z/)
          end
          each_node(tree) do |node, _|
            next unless node.named? && node.leaf?

            case node.type
            when "integer" then node.text = Engine::Numbers.integer(node.text)&.to_s || node.text
            when "float" then node.text = Engine::Numbers.decimal(node.text)&.then { Engine::Numbers.write_decimal(it) } || node.text
            when "char" then character(node)
            end
          end
        end

        # A heredoc's value starts on the line after its opening `"""`, and
        # loses the indentation of its closing `"""` from every line.
        def heredoc(parts)
          indent = parts.last.text[/[ \t]*\z/].size
          parts.each_with_index do |part, index|
            next unless part.type == "quoted_content"

            part.text = part.text.gsub(/\n[ \t]{0,#{indent}}/, "\n")
            part.text = part.text.delete_prefix("\n") if index.zero?
          end
        end

        # A string's value, from its parts: a literal if it is all text, or
        # a string of literals and interpolations. Neighbouring text joins up.
        def string_node(parts)
          pieces = parts.map do |part|
            case part.type
            when "quoted_content" then part.text
            when "escape_sequence" then ESCAPES.fetch(part.text[1..], part)
            else part
            end
          end
          runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
          nodes = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
          return literal("") if nodes.empty?
          return nodes.first if nodes.one? && nodes.first.type == "literal"

          build(:string, *nodes)
        end

        # `?a` is the integer 97, and `?\s` is 32.
        def character(node)
          char = node.text.delete_prefix("?")
          char = ESCAPES[char[1..]] if char.start_with?("\\") && char.size > 1
          return unless char&.size == 1

          node.type = "integer"
          node.text = char.ord.to_s
        end

        ### Keyword lists ###

        # `f x, do: a, else: b` is `f x do a else b end`.
        def do_keywords
          each_node(tree) do |call, _|
            next unless call.type == "call" && call.children.none? { |child| child.type == "do_block" }

            arguments = call.children.find { |child| child.type == "arguments" }
            keywords = arguments&.named_children&.last
            next unless keywords&.type == "keywords"

            blocks = keywords.named_children.to_h { |pair| [pair[:key]&.text&.strip, pair[:value]] }.slice("do:", "else:")
            next unless blocks["do:"]

            keywords.children.reject! { |pair| pair.named? && %w[do: else:].include?(pair[:key]&.text&.strip) }
            arguments.children.delete(keywords) if keywords.named_children.empty?
            call.children.delete(arguments) if arguments.named_children.empty?
            other = (build(:else_block, *statements(blocks["else:"])) if blocks["else:"])
            call.children << build(:do_block, *statements(blocks["do:"]), other)
          end
        end

        def statements(value) = value.type == "block" ? value.named_children : [value]

        # A keyword is a tuple of an atom and a value, and a map entry is a
        # tuple of its key and value. A keyword list outside a list or a map
        # is a list of its own.
        def keyword_lists
          transform(tree, "(pair key: (keyword) @key value: (_) @value)") do |match|
            build(:tuple, leaf(:atom, ":#{match[:key].text.strip.delete_suffix(':')}"), match[:value])
          end
          transform(tree, '(binary_operator left: (_) @key operator: "=>" right: (_) @value)') do |match|
            build(:tuple, match[:key], match[:value])
          end
          each_node(tree) do |node, _|
            node.children = node.children.flat_map do |child|
              next [child] unless child.type == "keywords"
              next child.named_children if %w[list map_content].include?(node.type)

              child.type = "list"
              [child]
            end
          end
        end

        ### Definitions ###

        def definitions
          transform(tree, "(alias) @alias") do |match|
            build(:aliases, *match.node.text.split(".").map { |part| leaf(:alias, part) })
          end
          captured(tree, "(call target: (identifier /\\A(defmodule|defprotocol)\\z/) (arguments (aliases) @name))").each do |name|
            name.type = "module_name"
          end
          captured(tree, "(call target: (identifier /#{DEFINITIONS.source}/) (arguments) @name)").each do |arguments|
            function_head(arguments)
          end
          captured(tree, <<~PATTERN).each { |definition| definition.type = "type_definition" }
            (unary_operator operand: (call target: (identifier /\\A(type|typep|opaque)\\z/)
              (arguments (binary_operator operator: "::") @name)))
          PATTERN
          transform(tree, '(unary_operator operator: "@" operand: (identifier) @name)') { |match| build(:attribute, match[:name]) }
        end

        # The head is the definition's first argument, or the left of its
        # `when`. A head with no brackets, as in `def f do`, is a bare name.
        def function_head(arguments)
          parent = arguments
          head = arguments.named_children.first
          if head.type == "binary_operator" && head[:operator].text == "when"
            parent = head
            head = head[:left]
          end
          if head.type == "call"
            head.type = "function_head"
          elsif head.type == "identifier"
            field = head.field
            parent.replace_child(head, build(:function_head, { target: head }).tap { |node| node.field = field })
          end
        end

        ### Variables ###

        def variables
          each_node(tree) do |node, _|
            if node.type == "function_head"
              node.children.each { |child| bind(child) if child.type == "arguments" }
            elsif node.type == "stab_clause" || (node.type == "binary_operator" && %w[= <-].include?(node[:operator].text))
              node.replace_child(node[:left], bind(node[:left])) if node[:left]
            end
          end
        end

        # Returns the pattern with each name bound by it wrapped in a
        # `variable` node. A function called in a pattern, the type in
        # `x::binary` and the default in `x \\ 1` bind nothing.
        def bind(pattern)
          return pattern if %w[variable dot].include?(pattern.type) || pinned?(pattern)
          return variable(pattern) if pattern.type == "identifier"

          pattern.children.map! do |child|
            skip = child.field == "target" ||
                   (pattern.type == "binary_operator" && %w[:: \\\\].include?(pattern[:operator].text) && child.field == "right")
            skip ? child : bind(child)
          end
          pattern
        end

        def variable(name)
          return name if name.text == "_"

          build(:variable, name).tap { |node| node.field = name.field }
        end

        def pinned?(node) = node.type == "unary_operator" && node[:operator].text == "^"
      end
    end
  end
end
