module Representer
  module Languages
    # Every step of exercism/elixir-representer is a rule here. Each rule's
    # comment says which step it replaces.
    class Elixir < Language
      tracks "elixir"
      version 6
      grammar "elixir"
      extensions ".ex", ".exs"

      # The grammar has one `identifier` type for every name. The first two
      # rewrites below move a name that the student defines for a variable to
      # the `variable` type, so that the rename rules can tell it from the
      # name of a function that the standard library defines.
      names :identifier, :variable, :alias, :alias_part

      IMPORT_KINDS = %w[alias use require import].freeze
      DEFINITIONS = /\A(def|defp|defmacro|defmacrop|defguard|defguardp|defdelegate)\z/
      TYPE_DEFINITIONS = /\A(type|typep|opaque)\z/
      SPECS = /\A(spec|callback|macrocallback)\z/
      TYPE_ATTRIBUTES = /\A(type|typep|opaque|spec|callback|macrocallback)\z/
      BLOCKS = %w[rescue catch else after].freeze

      ### Drop ###

      # Comments, and the documentation attributes (docstrings).
      drop "(comment)"
      drop "(unary_operator operator: \"@\" operand: (call target: (identifier /\\A(moduledoc|doc|typedoc)\\z/)))"

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "[", "]", "{", "}", "<<", ">>", ",", "do", "end", "fn", "else", "rescue", "catch", "after",
        "nil"

      ### Rewrite ###

      # (a + b) is a + b: the tree's shape already shows the grouping.
      unwrap :block

      # The old representer used `force_do_end_blocks`, so `if a, do: 1, else: 2`
      # and `def f(x), do: y` are the same as their do ... end forms.
      rewrite "(call (arguments (keywords) @keywords) @arguments) @call",
        where: ->(match) { Elixir.keyword_blocks?(match) } do |match|
        Elixir.expand_keyword_blocks(match.node, match[:arguments], match[:keywords])
      end

      # `a |> b` is `a |> b()`, also for `a |> Mod.b`.
      rewrite '(binary_operator operator: "|>" right: (identifier) @function)' do |match|
        call = build(:call, { target: match[:function] }, build(:arguments))
        match.node.replace_child(match[:function], call)
        match.node
      end
      rewrite '(binary_operator operator: "|>" right: (call target: (dot)) @call)', where: lambda { |match|
        Elixir.child(match[:call], "arguments").nil?
      } do |match|
        match[:call].children << build(:arguments)
        match.node
      end

      # SortImports and SortMapKeys, in one pass over the whole file, because
      # the order must not depend on the names that the solution defines (see
      # Elixir.organise).
      rewrite("(source) @root") { |match| Elixir.organise(match.node) ? match.node : nil }

      # `@optional_callbacks foo: 1` names the function foo, so the name is
      # renamed with the function.
      rewrite "(call target: (identifier /\\A(optional_callbacks|compile|dialyzer)\\z/) (arguments) @arguments)" do |match|
        Elixir.name_function_keys(match[:arguments]) ? match.node : nil
      end

      # Types are written without parentheses: `integer()` is `integer`.
      rewrite "(call target: (identifier /#{TYPE_ATTRIBUTES.source}/) (arguments) @arguments)" do |match|
        Elixir.strip_type_parentheses(match[:arguments]) ? match.node : nil
      end

      # A string is its value. Heredocs and sigils keep their structure.
      rewrite '(string quoted_start: "\\"") @string' do |match|
        parts = match.node.children.select(&:named?)
        next nil unless parts.all? { |part| %w[quoted_content escape_sequence interpolation].include?(part.type) }

        pieces = Elixir.string_parts(parts)
        next literal(pieces.first || "") if pieces.size <= 1 && !pieces.first.is_a?(Engine::Node)

        build(:string, *pieces.map { |piece| piece.is_a?(String) ? literal(piece) : piece })
      end

      # A module name with dots is one leaf in the grammar. Each part is a
      # name of its own, because a solution can rename `Foo` and `Foo.Bar`
      # separately (`alias Foo.Bar, as: B`).
      rewrite "(alias /\\./) @alias" do |match|
        build(:alias, *match[:alias].text.split(".").map { |part| leaf(:alias_part, part) })
      end

      # `user.name` reads a field, so `name` isn't the name of a function that
      # the student defined. Only a module (or `__MODULE__`) can have one.
      rewrite "(dot left: (_) @left right: (identifier) @right)",
        where: lambda { |match|
          match[:left].type != "alias" && match[:left].text != "__MODULE__" && match[:left].type != "atom"
        } do |match|
        match.node.replace_child(match[:right], leaf(:field, match[:right].text))
        match.node
      end

      # Variables: a name that a pattern or a function head defines.
      rewrite "(call target: (identifier /#{DEFINITIONS.source}/) (arguments) @arguments)" do |match|
        head = match[:arguments].named_children.first
        head = head["left"] if head&.type == "binary_operator" && head["operator"]&.text == "when"
        head_arguments = head && head.type == "call" && Elixir.child(head, "arguments")
        head_arguments && Elixir.mark_variables(head_arguments) ? match.node : nil
      end
      rewrite <<~PATTERN do |match|
        (call target: (identifier /#{TYPE_DEFINITIONS.source}/)
          (arguments (binary_operator operator: "::" left: (call (arguments) @arguments))))
      PATTERN
        Elixir.mark_variables(match[:arguments]) ? match.node : nil
      end
      rewrite '(binary_operator operator: "=" left: (_) @left)' do |match|
        Elixir.mark_variables(match[:left]) ? match.node : nil
      end
      rewrite '(binary_operator operator: "<-" left: (_) @left)' do |match|
        Elixir.mark_variables(match[:left]) ? match.node : nil
      end
      rewrite "(stab_clause left: (_) @left)" do |match|
        Elixir.mark_variables(match[:left]) ? match.node : nil
      end

      ### Rename and keep ###

      rename "(variable) @name"
      rename "(call target: (identifier /\\A(defmodule|defprotocol|defimpl)\\z/) (arguments (alias) @name))"
      rename "(call target: (identifier /\\A(defmodule|defprotocol|defimpl)\\z/) (arguments (alias (alias_part)* @name)))"
      rename "(pair key: (keyword \"as: \") value: (alias) @name)"
      rename "(unary_operator operator: \"@\" operand: (call target: (identifier) @name))"
      rename <<~PATTERN
        (unary_operator operator: "@" operand: (call target: (identifier /#{TYPE_DEFINITIONS.source}/)
          (arguments (binary_operator left: (identifier) @name))))
      PATTERN

      # Functions, macros and guards, and the names of specs and types.
      rename_member "(call target: (identifier /#{DEFINITIONS.source}/) (arguments (identifier) @name))"
      rename_member "(call target: (identifier /#{DEFINITIONS.source}/) (arguments (call target: (identifier) @name)))"
      rename_member <<~PATTERN
        (call target: (identifier /#{DEFINITIONS.source}/)
          (arguments (binary_operator operator: "when" left: (call target: (identifier) @name))))
      PATTERN
      rename_member <<~PATTERN
        (call target: (identifier /#{DEFINITIONS.source}/)
          (arguments (binary_operator operator: "when" left: (identifier) @name)))
      PATTERN
      rename_member <<~PATTERN
        (call target: (identifier /#{TYPE_DEFINITIONS.source}/)
          (arguments (binary_operator operator: "::" left: (call target: (identifier) @name))))
      PATTERN
      rename_member <<~PATTERN
        (call target: (identifier /#{SPECS.source}/)
          (arguments (binary_operator operator: "::" left: (call target: (identifier) @name))))
      PATTERN
      rename_member <<~PATTERN
        (call target: (identifier /#{TYPE_DEFINITIONS.source}/)
          (arguments (binary_operator operator: "::" left: (identifier) @name)))
      PATTERN
      rename_member <<~PATTERN
        (call target: (identifier /#{SPECS.source}/)
          (arguments (binary_operator operator: "::" left: (identifier) @name)))
      PATTERN
      rename_member <<~PATTERN
        (call target: (identifier /#{SPECS.source}/)
          (arguments (binary_operator operator: "when"
            left: (binary_operator operator: "::" left: (call target: (identifier) @name)))))
      PATTERN

      # A name after a dot refers to a function in some module, as long as the
      # rewrite above hasn't taken it for a field of a variable.
      member "(dot right: (identifier) @name)"

      # Attributes that Elixir itself reads, and the macros that define types.
      keep "moduledoc", "doc", "typedoc", "spec", "type", "typep", "opaque", "callback", "macrocallback", "behaviour",
        "impl", "compile", "deprecated", "dialyzer", "external_resource", "file", "on_definition", "on_load", "vsn",
        "derive", "enforce_keys", "optional_callbacks", "before_compile", "after_compile", "_", "__MODULE__",
        "__ENV__", "__DIR__", "__CALLER__", "__STACKTRACE__"

      library_names File.join(__dir__, "library_names", "elixir.txt")

      ESCAPES = {
        "n" => "\n", "t" => "\t", "r" => "\r", "s" => " ", "0" => "\0", "e" => "\e", "a" => "\a", "b" => "\b",
        "f" => "\f", "v" => "\v", "d" => "\x7F", "\\" => "\\", "\"" => "\"", "'" => "'", "#" => "#"
      }.freeze

      ### Helpers for the rules above ###

      def self.string_parts(parts)
        parts.each_with_object([]) do |part, pieces|
          if part.type == "interpolation"
            pieces << part
            next
          end

          text = part.type == "escape_sequence" ? decode(part.text) : part.text
          pieces.last.is_a?(String) ? pieces.last << text : pieces << text.dup
        end
      end

      # Decodes an escape. One not listed here keeps its source text, so two
      # different strings can never get the same value.
      def self.decode(escape)
        code = escape[1..]
        case code
        when /\Au\{([0-9a-fA-F]{1,6})\}\z/, /\Au([0-9a-fA-F]{4})\z/
          value = Regexp.last_match(1).to_i(16)
          value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
        when /\Ax([0-7][0-9a-fA-F]?)\z/ then Regexp.last_match(1).to_i(16).chr(Encoding::UTF_8)
        else ESCAPES.fetch(code, escape)
        end
      end

      # The first child of this type. The grammar gives some children (a
      # call's arguments and blocks) no field name.
      def self.child(node, type) = node.children.find { |child| child.type == type }

      def self.keyword_blocks?(match)
        match.node.children.none? { |child| child.type == "do_block" } &&
          block_pairs(match[:keywords]).any? { |pair| key(pair) == "do" }
      end

      def self.import?(node)
        node.type == "call" && node["target"]&.type == "identifier" && IMPORT_KINDS.include?(node["target"].text)
      end

      # The text to sort a node by. A name that the solution defines is left
      # out, because the solution's own names become placeholders, and two
      # solutions that only name things differently must be sorted the same.
      def self.key(node, defined = Set.new)
        # A quoted key (`"a b": 1`) isn't a leaf, so it is sorted by its parts below.
        return node["key"].text.strip.chomp(":") if node.type == "pair" && node["key"]&.leaf?

        parts = []
        node.each_descendant do |descendant|
          next unless descendant.leaf?

          renamed = %w[variable identifier].include?(descendant.type) || defined.include?(descendant.text)
          parts << (renamed ? "" : descendant.text.to_s)
        end
        parts.join(" ")
      end

      def self.block_pairs(keywords)
        keywords.children.select { |child| child.type == "pair" && key(child).match?(/\A(do|else|rescue|catch|after)\z/) }
      end

      # `foo a, do: b, else: c` becomes `foo a do b else c end`.
      def self.expand_keyword_blocks(call, arguments, keywords)
        pairs = block_pairs(keywords)
        values = pairs.to_h { |pair| [key(pair), pair["value"]] }
        keywords.children.reject! { |child| pairs.include?(child) }

        arguments.children.delete(keywords) unless keywords.children.any? { |child| child.type == "pair" }
        call.children.delete(arguments) if arguments.named_children.empty?

        body = statements(values["do"])
        extra = BLOCKS.select { |name| values[name] }.map do |name|
          Engine::Node.new("#{name}_block", statements(values[name]))
        end
        call.children << Engine::Node.new("do_block", body + extra).tap { |block| block.field = "do_block" }
        call
      end

      def self.statements(value)
        return [] unless value

        value.type == "block" ? value.named_children : [value]
      end

      # The module names that the solution defines.
      def self.defined_modules(root)
        defined = Set.new
        root.each_descendant do |node|
          if node.type == "call" && %w[defmodule defprotocol defimpl].include?(node["target"]&.text)
            child_arguments(node).each_descendant do |descendant|
              defined << descendant.text if descendant.leaf? && %w[alias alias_part].include?(descendant.type)
            end
          elsif node.type == "pair" && node["key"]&.text == "as: " && node["value"]&.leaf?
            defined << node["value"].text
          end
        end
        defined
      end

      # Puts the alias, use, require and import statements at the start of
      # each block in a fixed order, sorts the names in `alias X.{B, A}`, and
      # sorts the keys of maps and structs. Returns whether anything changed.
      def self.organise(root)
        before = root.inspect
        defined = defined_modules(root)
        root.each_descendant do |node|
          sort_imports(node, defined) if %w[source do_block].include?(node.type)
          sort_tuple(node, defined) if import?(node)
          sort_map_content(node) if node.type == "map_content"
        end
        root.inspect != before
      end

      def self.sort_imports(block, defined)
        run = block.children.take_while { |child| import?(child) }
        sorted = run.each_with_index.sort_by do |child, index|
          [IMPORT_KINDS.index(child["target"].text), key(child_arguments(child), defined), index]
        end
        block.children[0, run.size] = sorted.map(&:first)
      end

      def self.sort_tuple(statement, defined)
        tuple = child_arguments(statement)&.named_children&.first&.then { |dot| dot["right"] if dot.type == "dot" }
        tuple.children.sort_by!.with_index { |child, index| [key(child, defined), index] } if tuple&.type == "tuple"
      end

      def self.child_arguments(call) = child(call, "arguments") || call

      # Sorts a map's entries by key: the `%{a => 1}` entries, the `k: 1`
      # pairs, and the pairs after the `|` in `%{map | k: 1}`.
      def self.sort_map_content(content)
        content.children.sort_by!.with_index do |child, index|
          [child.type == "binary_operator" && child["operator"]&.text == "=>" ? 0 : 1, key(child["left"] || child), index]
        end
        content.children.each do |child|
          lists = [child, child["right"]].compact.select { |node| node.type == "keywords" }
          lists.each { |list| list.children.sort_by!.with_index { |pair, index| [key(pair), index] } }
        end
      end

      # Gives the keys of `name: arity` pairs the identifier type. Returns
      # whether anything changed.
      def self.name_function_keys(node)
        changed = false
        node.each_descendant do |pair|
          next unless pair.type == "pair" && pair["key"]&.type == "keyword" && pair["value"]&.type == "integer"

          pair.replace_child(pair["key"], leaf(:identifier, pair["key"].text.strip.chomp(":")))
          changed = true
        end
        changed
      end

      # `integer()` is `integer` in a type. A call to a module's function
      # (`String.t()`) keeps its parentheses. Returns whether anything changed.
      def self.strip_type_parentheses(node)
        changed = false
        node.children.map! do |child|
          changed = strip_type_parentheses(child) || changed
          next child unless child.type == "call" && child["target"]&.type == "identifier" && child.children.size == 2

          arguments = child_arguments(child)
          next child unless arguments.type == "arguments" && arguments.children.empty?

          changed = true
          child["target"].tap { |target| target.field = child.field }
        end
        changed
      end

      # Gives the names in a pattern or a function head the `variable` type.
      # A name after `^` (a value, not a new name), a function being called
      # and the type in `x::binary` are left alone. Returns whether anything
      # changed.
      def self.mark_variables(node)
        return false if node.nil?

        if node.type == "identifier"
          return false unless node.leaf?
          return false if node.text == "_" || node.text.start_with?("__")

          node.type = "variable"
          return true
        end
        return false if node.type == "unary_operator" && node.children.any? { |child| child.type == "^" }

        node.children.map { |child| marked_child?(node, child) && mark_variables(child) }.any?
      end

      def self.marked_child?(parent, child)
        return false if child.field == "target" || parent.type == "dot"
        return false if parent.type == "binary_operator" && %w[:: \\].include?(parent["operator"]&.text) && child.field == "right"

        true
      end
    end
  end
end
