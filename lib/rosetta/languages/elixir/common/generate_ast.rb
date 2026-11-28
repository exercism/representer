# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Elixir's own parser (`Code.string_to_quoted`) gives.
module Rosetta::Languages::Elixir::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # fn x -> x end  ->  (anonymous_function (stab_clause ...))
    strip_tokens "do", "end", "fn", "else", "rescue", "catch", "after", "nil"

    # Strip the brackets, commas and other punctuation, because they are layout.
    # IO.puts(x)  ->  IO.puts x
    strip_tokens "(", ")", "[", "]", "{", "}", "<<", ">>", ",", ";", "%", "\#{"

    # Write each number as its value.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 0b11111  ->  31
    # 1.50  ->  1.5
    numbers_are integer: :integer,
                decimal: :float

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\s' => " ",
      '\e' => "\e",
      '\0' => "\0",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'",
      '\#' => "#"
    }.freeze

    DEFINITIONS = /\A(def|defp|defmacro|defmacrop|defguard|defguardp|defdelegate)\z/

    def call
      tree.tap do
        write_strings_atoms_charlists_and_characters_as_values!
        unwrap_brackets_that_only_group!
        turn_do_and_else_keywords_into_a_do_block!
        write_keyword_lists_and_map_entries_in_one_shape!
        drop_empty_brackets_from_calls_on_a_module_or_value!
        mark_the_code_that_defines_names!
        mark_module_bodies_and_map_updates!
        wrap_bound_variables_in_variable_nodes!
      end
    end

    private
    ### Brackets and calls ###

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. This step runs before the steps that read a definition's
    # shape, which need the brackets gone.
    # (1 + 2)  ->  1 + 2
    def unwrap_brackets_that_only_group!
      unwrap(tree, "(block)")
    end

    # Drop empty brackets from a call on a module or value. Leave `f()` alone,
    # because the parser reads a bare `f` as a variable.
    # Mod.f()  ->  Mod.f
    # x.f()  ->  x.f
    def drop_empty_brackets_from_calls_on_a_module_or_value!
      transform(tree, "(call target: (dot right: (_)) (arguments) @arguments)") do |match|
        match.node.children.delete(match[:arguments]) if match[:arguments].named_children.empty?
        match.node
      end
    end

    ### Values ###

    # Turn each string, atom, charlist and character into its value, and read
    # the escapes of a string. Keep any other escape as it is written, so it
    # can't make two different strings the same.
    #
    # ?a  ->  97
    # a heredoc that holds two lines  ->  "a\nb"
    # :"a"  ->  :a
    # ''  ->  []
    def write_strings_atoms_charlists_and_characters_as_values!
      transform(tree, '(string quoted_start: /\A"("")?\z/ @quote)') do |match|
        parts = match.node.named_children
        parts = remove_heredoc_indentation!(parts) if match[:quote].text == '"""'
        string_node(parts)
      end
      transform(tree, "(charlist) @charlist") { |match| build(:list) if match.node.named_children.empty? }
      transform(tree, "(quoted_atom (quoted_content) @name)") do |match|
        leaf(:atom, ":#{match[:name].text}") if match.node.named_children.one? && match[:name].text.match?(/\A[a-zA-Z_]\w*[?!]?\z/)
      end
      each_node(tree) { |node, _| turn_character_into_integer!(node) if node.named? && node.leaf? && node.type == "char" }
    end

    # Start a heredoc's value on the line after its opening `"""`, and remove
    # the indentation of its closing `"""` from every line.
    def remove_heredoc_indentation!(parts)
      indent = parts.last.text[/[ \t]*\z/].size
      parts.each_with_index do |part, index|
        next unless part.type == "quoted_content"

        part.text = part.text.gsub(/\n[ \t]{0,#{indent}}/, "\n")
        part.text = part.text.delete_prefix("\n") if index.zero?
      end
    end

    # Build a string's value from its parts: a literal if it is all text, or a
    # string of literals and interpolations. Join neighbouring text.
    #
    # "a\nb" is one literal, and "a#{x}b" is a string of "a", x and "b".
    def string_node(parts)
      pieces = parts.map do |part|
        case part.type
        when "quoted_content" then part.text
        when "escape_sequence" then ESCAPES.fetch(part.text, part)
        else part
        end
      end
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      nodes = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if nodes.empty?
      return nodes.first if nodes.one? && nodes.first.type == "literal"

      build(:string, *nodes)
    end

    # Turn a character literal into the integer of its code.
    # ?a  ->  97
    # ?\s  ->  32
    def turn_character_into_integer!(node)
      char = node.text.delete_prefix("?")
      char = ESCAPES[char] if char.start_with?("\\") && char.size > 1
      return unless char&.size == 1

      node.type = "integer"
      node.text = char.ord.to_s
    end

    ### Keyword lists ###

    # Turn the `do:` and `else:` keywords of a call into a `do` block.
    # f x, do: a, else: b  ->  f x do a else b end
    def turn_do_and_else_keywords_into_a_do_block!
      each_node(tree) do |call, _|
        next unless call.type == "call" && call.children.none? { |child| child.type == "do_block" }

        arguments = call.children.find { |child| child.type == "arguments" }
        keywords = arguments&.named_children&.last
        next unless keywords&.type == "keywords"

        blocks = keywords.named_children.to_h { |pair| [pair[:key]&.text&.strip, pair[:value]] }.slice("do:", "else:")
        next unless blocks["do:"]

        keywords.children.reject! { |pair| pair.named? && ["do:", "else:"].include?(pair[:key]&.text&.strip) }
        arguments.children.delete(keywords) if keywords.named_children.empty?
        call.children.delete(arguments) if arguments.named_children.empty?
        other = (build(:else_block, *statements(blocks["else:"])) if blocks["else:"])
        call.children << build(:do_block, *statements(blocks["do:"]), other)
      end
    end

    def statements(value) = value.type == "block" ? value.named_children : [value]

    # Turn each keyword and map entry into a tuple of its key and value, and
    # wrap a keyword list that sits outside a list or a map in a list of its own.
    #
    # [a: 1]  ->  [{:a, 1}]
    # %{a: 1}  ->  %{:a => 1}
    # f(x, a: 1)  ->  f(x, [a: 1])
    def write_keyword_lists_and_map_entries_in_one_shape!
      transform(tree, "(pair key: (keyword) @key value: (_) @value)") do |match|
        build(:tuple, leaf(:atom, ":#{match[:key].text.strip.delete_suffix(':')}"), match[:value])
      end
      transform(tree, '(binary_operator left: (_) @key operator: "=>" right: (_) @value)') do |match|
        build(:tuple, match[:key], match[:value])
      end
      each_node(tree) do |node, _|
        node.children = node.children.flat_map do |child|
          next [child] unless child.type == "keywords"
          next child.named_children if ["list", "map_content"].include?(node.type)

          child.type = "list"
          [child]
        end
      end
    end

    ### Definitions ###

    # Give the code that defines a name a node type of its own, so that representation/spec.rb
    # can list it in names_are_defined_by.
    #
    # - Mark the name of a `defmodule` or `defprotocol` as a `module_name`, and
    #   split it into its parts, so `Foo.Bar` defines both `Foo` and `Bar`.
    # - Mark the head of a `def`, `defp`, `defmacro`, `defmacrop`, `defguard`,
    #   `defguardp` or `defdelegate` as a `function_head`.
    # - Mark the `t :: ...` of `@type`, `@typep` and `@opaque` as a
    #   `type_definition`.
    # - Mark `@name` with no value (reading an attribute) as an `attribute`.
    def mark_the_code_that_defines_names!
      transform(tree, "(alias) @alias") do |match|
        build(:aliases, *match.node.text.split(".").map { |part| leaf(:alias, part) })
      end
      captured(tree, "(call target: (identifier /\\A(defmodule|defprotocol)\\z/) (arguments (aliases) @name))").each do |name|
        name.type = "module_name"
      end
      captured(tree, "(call target: (identifier /#{DEFINITIONS.source}/) (arguments) @name)").each do |arguments|
        mark_function_head!(arguments)
      end
      captured(tree, <<~PATTERN).each { |definition| definition.type = "type_definition" }
        (unary_operator operand: (call target: (identifier /\\A(type|typep|opaque)\\z/)
          (arguments (binary_operator operator: "::") @name)))
      PATTERN
      transform(tree, '(unary_operator operator: "@" operand: (identifier) @name)') { |match| build(:attribute, match[:name]) }
    end

    # Mark the head of a definition as a `function_head`. The head is the first
    # argument, or the left of its `when`. A head with no brackets, as in
    # `def f do`, is a bare name.
    def mark_function_head!(arguments)
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

    ### Containers ###

    # Give two containers a node type of their own, so that Normalise and
    # Reorder can tell them apart.
    #
    # - Mark the body of a `defmodule`, `defprotocol` or `defimpl` as a
    #   `module_body`, so it differs from a function's `do_block`.
    # - Mark the entries after the `|` of `%{map | a: 1}` as a `map_update`.
    def mark_module_bodies_and_map_updates!
      captured(tree, "(call target: (identifier /\\A(defmodule|defprotocol|defimpl)\\z/) (do_block) @name)").each do |body|
        body.type = "module_body"
      end
      captured(tree, '(map_content (binary_operator operator: "|" right: (list) @name))').each do |entries|
        entries.type = "map_update"
      end
    end

    ### Variables ###

    # Wrap each variable bound by a pattern in a `variable` node, so that
    # representation/spec.rb can list it in names_are_defined_by. The patterns are a
    # function's parameters and the left of `=`, `<-` and `->`. A pinned `^x`
    # binds nothing, and neither does `_`.
    def wrap_bound_variables_in_variable_nodes!
      each_node(tree) do |node, _|
        if node.type == "function_head"
          node.children.each { |child| wrap_names_bound_by_pattern!(child) if child.type == "arguments" }
        elsif node.type == "stab_clause" || (node.type == "binary_operator" && ["=", "<-"].include?(node[:operator].text))
          node.replace_child(node[:left], wrap_names_bound_by_pattern!(node[:left])) if node[:left]
        end
      end
    end

    # Return the pattern with each name bound by it wrapped in a `variable`
    # node. A function called in a pattern, the type in `x::binary` and the
    # default in `x \\ 1` bind nothing.
    def wrap_names_bound_by_pattern!(pattern)
      return pattern if ["variable", "dot"].include?(pattern.type) || pinned?(pattern)
      return variable_node_for(pattern) if pattern.type == "identifier"

      pattern.children.map! do |child|
        skip = child.field == "target" ||
               (pattern.type == "binary_operator" && ["::", "\\\\"].include?(pattern[:operator].text) && child.field == "right")
        skip ? child : wrap_names_bound_by_pattern!(child)
      end
      pattern
    end

    def variable_node_for(name)
      return name if name.text == "_"

      build(:variable, name).tap { |node| node.field = name.field }
    end

    def pinned?(node) = node.type == "unary_operator" && node[:operator].text == "^"
  end
end
