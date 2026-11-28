# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, with one form for each string and number, and a node for
# each name that the solution defines.
module Inspector::Languages::Arturo::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the brackets, quotes and colons, because the node types already
    # show them.
    # x: [a (b c)]  ->  (label x) (block a (inline b c))
    strip_tokens "[", "]", only_in: [:block, :parameters, :dictionary]
    strip_tokens "#[", only_in: :dictionary
    strip_tokens "(", ")", only_in: :inline
    strip_tokens "'", only_in: [:literal, :path_literal]
    strip_tokens ":", only_in: [:label, :path_label]
    strip_tokens "|", only_in: :interpolation
    strip_tokens '~"', '"', only_in: :template_string

    # Strip the `\` between the parts of a path. A path that starts with `\`
    # gets a type of its own first, because `\hour` means `this\hour`.
    # items\0  ->  (path items 0)
    strip_tokens "\\", only_in: [:path, :path_literal]

    # Unwrap brackets around a single value, because they only group it.
    # (x) = 1  ->  x = 1
    unwrap :inline

    # Write each number as its value. Arturo reads `0x` as hex, `0b` as binary
    # and `0o` as octal. `1` and `1.0` stay apart, because Arturo reads them as
    # an integer and a floating number.
    #
    # 0x1F  ->  31
    # 1.50  ->  1.5
    # 1e3  ->  1000.0
    numbers_are integer: :integer,
                decimal: :floating,
                prefixes: { "0x" => 16, "0b" => 2, "0o" => 8 },
                separators: []

    ITERATORS = ["loop", "map", "select", "filter", "fold", "every?", "some?", "chunk", "cluster", "collect",
                 "gather", "enumerate", "maximum", "minimum", "arrange"].freeze

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\\\\' => "\\",
      '\"' => '"'
    }.freeze

    def call
      tree.tap do
        give_each_path_from_this_a_type_of_its_own!
        mark_the_names_that_each_destructuring_label_defines!
        mark_the_names_that_each_iterator_gives_its_items!
        mark_the_type_that_each_define_defines!
        write_strings_as_their_values!
        write_template_strings_as_their_values!
        write_characters_as_their_values!
      end
    end

    private
    ### Names ###

    # Give each path that starts with `\` a type of its own, so that stripping
    # the `\` can't make `\a\b` the same as `a\b`.
    # \hour  ->  (this_path hour)
    def give_each_path_from_this_a_type_of_its_own!
      each_node(tree) do |node, _|
        node.type = "this_path" if node.type == "path" && !node.children.first.named?
      end
    end

    # Put the block of names before each `:` in a node of its own, so that
    # representation/spec.rb can rename them.
    # [a b]: f x  ->  (destructuring_label a b) f x
    def mark_the_names_that_each_destructuring_label_defines!
      each_container do |container|
        pairs = container.children.each_cons(2).select do |names, colon|
          names.type == "block" && colon.type == "symbol" && colon.text == ":"
        end
        pairs.each do |names, colon|
          container.replace_child(names, build(:destructuring_label, *names.named_children))
          container.children.delete(colon)
        end
      end
    end

    # Mark the block of names that an iterator gives its items, so that
    # representation/spec.rb can rename them. The names are the first block
    # of words after the iterator that a block or a `->` follows. The search
    # stops at a literal word that a block or a `->` follows, because the
    # literal already defines its name, and at the first `->`, `=>` or label,
    # where the iterator has no block of names.
    # fold.with:'i xs [a b] [...]  ->  fold .with: (literal i) xs (loop_variables a b) (block ...)
    # loop xs [a b] [...]  ->  loop xs (loop_variables a b) (block ...)
    def mark_the_names_that_each_iterator_gives_its_items!
      each_container do |container|
        children = container.children
        children.each_with_index do |child, index|
          next unless child.type == "identifier" && ITERATORS.include?(child.text)

          children[(index + 1)..].each_cons(2) do |names, body|
            break if ends_the_search?(names, body)
            next unless words?(names) && body?(body)

            container.replace_child(names, build(:loop_variables, *names.named_children))
            break
          end
        end
      end
    end

    # Put the type after each `define` in a node of its own, so that
    # representation/spec.rb can rename it.
    # define :robot [...]  ->  define (type_definition :robot) (block ...)
    def mark_the_type_that_each_define_defines!
      each_container do |container|
        container.children.each_cons(2) do |define, type|
          next unless define.type == "identifier" && define.text == "define" && type.type == "type"

          container.replace_child(type, build(:type_definition, type))
        end
      end
    end

    def ends_the_search?(node, body)
      (node.type == "literal" && body?(body)) || ["label", "destructuring_label"].include?(node.type) ||
        (node.type == "symbol" && ["->", "=>"].include?(node.text))
    end

    def words?(node)
      node.type == "block" && node.named_children.any? && node.named_children.all? { |name| name.type == "identifier" }
    end

    def body?(node) = node.type == "block" || (node.type == "symbol" && node.text == "->")

    def each_container(&)
      containers = []
      each_node(tree) { |node, _| containers << node if ["source_file", "block", "inline", "dictionary"].include?(node.type) }
      containers.each(&)
    end

    ### Strings ###

    # Turn each string in double quotes into its value, and read its escapes.
    # Keep any other escape as a node of its own, so it can't make two
    # different strings the same.
    #
    # "a\tb"  ->  "a\tb"
    # "a\d"  ->  (string "a" (escape_sequence \d))
    #
    # Turn each string in braces on one line into its value, so that `{ab}`
    # and `"ab"` are the same. Keep every other kind of string as it is
    # written, in a node of its own, because Arturo can trim the margin of
    # its lines.
    #
    # {ab}  ->  "ab"
    # {:a\d:}  ->  (string "{:a\\d:}")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        text = match.node.text
        next quoted_string_node(text[1...-1]) if text.start_with?('"')

        value = text[/\A\{(?!:)([^\n\\{}]*)\}\z/, 1]
        value ? literal(value) : build(:string, literal(text))
      end
    end

    def quoted_string_node(text)
      pieces = text.scan(/\\.|[^\\]+/m).map do |piece|
        piece.start_with?("\\") ? ESCAPES.fetch(piece) { leaf(:escape_sequence, piece) } : piece
      end
      string_node(pieces)
    end

    # Turn the text of each template string into its value, and keep the
    # code between each pair of `|`.
    # ~"|h|:00\n"  ->  (template_string (interpolation h) ":00\n")
    def write_template_strings_as_their_values!
      captured(tree, "(template_string) @name").each do |template|
        pieces = template.children.map do |piece|
          case piece.type
          when "string_content" then piece.text
          when "escape_sequence" then ESCAPES.fetch(piece.text, piece)
          else piece
          end
        end
        template.children = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }.map do |run|
          run.first.is_a?(String) ? literal(run.join) : run.first
        end
      end
    end

    # Write each character as its value, and read its escape.
    # '\n'  ->  (char "\n")
    def write_characters_as_their_values!
      transform(tree, "(char) @char") do |match|
        value = match.node.text[1...-1]
        build(:char, literal(ESCAPES.fetch(value, value)))
      end
    end

    # Build a string's value from its pieces: a literal if it is all text, or
    # a string of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end
  end
end
