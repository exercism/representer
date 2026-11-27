module Representer::Engine
  # A code pattern is a pattern written as code in the language itself,
  # such as Ruby's `require "{{file}}"`. A staged language lists its
  # imports and its Normalise rules as code patterns, so each one reads as
  # the code it is about.
  #
  # A `{{word}}` in the code is a placeholder:
  #
  # - It matches any code. In a list, such as a method's parameters, it
  #   matches any number of items, including none.
  # - If the grammar reads a `{{word}}` as something other than a name,
  #   the placeholder matches one node of that kind. So `"{{file}}"` (in
  #   quotes) matches one string without interpolation.
  #
  # A `$word` is real code in Ruby, PHP, Perl, Bash, jq and JavaScript
  # templates, so placeholders use braces.
  #
  # The engine parses the code with the language's grammar and runs the
  # language's GenerateAST stage on it, so the pattern has the same shape
  # as a solution's tree. A pattern matches a node of the same type if the
  # pattern's children match the node's children in order. The node may
  # have more children between and after them (such as a method's body),
  # but nothing with a field name before them (such as a call's receiver).
  # So `require "{{file}}"` matches `require "set"`, and it doesn't match
  # `Kernel.require "set"`.
  #
  # Some code doesn't parse on its own, such as Ruby's `{ |{{x}}| }`, or
  # `def {{method}}({{x}})` without its `end`. The engine then tries the
  # code in each of the language's pattern contexts (see
  # Language.pattern_contexts). A rule can also give its own context
  # with `inside:`. A context marks the code's place with `...`. The
  # pattern is the smallest node that holds all of the code, and it
  # matches that node wherever it appears. So `"*{{x}}"` inside
  # `"def f(...) end"` matches a splat parameter in a method, a block or a
  # lambda.
  #
  # If one of the grammar's keywords comes out as a name, the engine
  # rejects that parse and tries the next context. So Ruby's
  # `rescue => {{x}}` can't become a pattern match on a variable called
  # `rescue`. If the code doesn't parse in any context, the engine tries
  # every context again with each placeholder capitalised, as Ruby's
  # `class {{x}}` needs.
  class CodePattern
    PLACEHOLDER = /\{\{([A-Za-z_]\w*)\}\}/
    MARK = "...".freeze

    # An Any is a placeholder. It matches any node if its type is
    # nil, and otherwise a leaf of its type.
    Any = Struct.new(:word, :type)

    # A Leaf matches a token, or a named leaf with the same text.
    Leaf = Struct.new(:type, :text, :named)

    # A Branch matches a node whose children match its children, which are
    # [field, element] pairs.
    Branch = Struct.new(:type, :children)

    # Compiling a pattern parses code, so this returns a cached pattern.
    def self.[](language, code, inside: nil)
      (@cache ||= {})[[language, code, inside]] ||= new(language, code, inside:)
    end

    attr_reader :code

    def initialize(language, code, inside: nil)
      @language = language
      @code = code
      @words = {}
      @node = parse(inside)
      @root = compile(@node)
    end

    # The type of node that the pattern matches, or nil for any type.
    def type = @root.type

    # Returns every way the pattern matches the node. Each is a Hash from
    # each placeholder's word to its match. A placeholder in a list matches
    # a list of nodes.
    def matches(node)
      found = []
      match_element(@root, node, {}) { |bindings| found << bindings }
      found
    end

    # Returns the first way the pattern matches the node, or nil.
    def match(node)
      match_element(@root, node, {}) { |bindings| return bindings }
      nil
    end

    # Builds the pattern's code as a new tree. Each placeholder becomes a
    # copy of its match in bindings.
    def build(bindings)
      built = build_node(@node, bindings)
      return built unless built.is_a?(Array)
      return built.first if built.one?

      raise ArgumentError, "The code #{code.inspect} must build one node"
    end

    def inspect = "#<CodePattern #{code.inspect}>"

    private
    ### Parsing ###

    def parse(inside)
      contexts = inside ? [inside] : [MARK, *@language.pattern_contexts]
      [false, true].each do |capitalised|
        contexts.each do |context|
          node = parse_in(context, capitalised)
          return node if node
        end
      end
      raise ArgumentError, "The code pattern #{code.inspect} doesn't parse as #{@language.name}"
    end

    # Parses the code in the context, and returns the code's node after
    # GenerateAST, or nil if the code doesn't parse there.
    def parse_in(context, capitalised)
      before, after = context.split(MARK, 2)
      raise ArgumentError, "The context #{context.inspect} needs #{MARK} to mark the code's place" unless after

      before = spell(before, capitalised)
      fragment = spell(code.strip, capitalised)
      source = before + fragment + spell(after, capitalised)
      tree = Grammar[@language.grammar].parse(source, spans: true, **@language.parse_options)
      from = before.bytesize
      to = from + fragment.bytesize
      node = smallest_node_holding(tree, from, to)
      return nil if misread_keyword?(node)

      tree = @language.run_stage(:GenerateAST, tree)
      contains?(tree, node) ? node : node_after_generate_ast(tree, from, to)
    rescue Representer::CannotRepresent
      nil
    end

    # GenerateAST can replace the code's node, as Ruby's turns `x if y`
    # into an `if`. The code's node is then the smallest node that holds
    # all of the code's leaves.
    def node_after_generate_ast(tree, from, to)
      leaves = Set.new.compare_by_identity
      tree.each_descendant { |node| leaves << node if node.leaf? && node.span && node.span.begin >= from && node.span.end <= to }
      node = tree
      while (child = node.children.find { |candidate| leaves.all? { |leaf| contains?(candidate, leaf) } })
        node = child
      end
      return node unless leaves.empty? || placeholder_word(node)

      raise ArgumentError, "#{@language.name}'s GenerateAST leaves too little of the code pattern #{code.inspect} to match"
    end

    # Writes each placeholder as a name that the grammar accepts: `{{file}}`
    # becomes `file__`, or `File__` when capitalised.
    def spell(text, capitalised)
      text.gsub(PLACEHOLDER) do
        word = Regexp.last_match(1)
        spelling = "#{capitalised ? word[0].upcase + word[1..] : word}__"
        @words[spelling] = word
        spelling
      end
    end

    def smallest_node_holding(tree, from, to)
      node = tree
      while (child = node.children.find { |candidate| candidate.named? && candidate.span.begin <= from && candidate.span.end >= to })
        node = child
      end
      node
    end

    def misread_keyword?(node)
      keywords = Grammar[@language.grammar].keywords
      misread = false
      node.each_descendant do |descendant|
        misread ||= descendant.named? && descendant.leaf? && descendant.type != descendant.text &&
                    keywords.include?(descendant.text)
      end
      misread
    end

    def contains?(tree, node)
      found = false
      tree.each_descendant { |descendant| found ||= descendant.equal?(node) }
      found
    end

    # Returns the placeholder's word if the leaf is a placeholder, such as
    # `x` for `@x__` or `:x__`.
    def placeholder_word(node)
      return nil unless node.named? && node.leaf?

      @words[node.text.sub(/\A\W+/, "")]
    end

    def compile(node)
      word = placeholder_word(node)
      if word
        return Any.new(word, @language.names.key?(node.type) ? nil : node.type)
      end
      return Leaf.new(node.type, node.named? ? node.text : nil, node.named?) if node.leaf?

      Branch.new(node.type, node.children.map { |child| [child.field, compile(child)] })
    end

    ### Matching ###

    def match_element(element, node, bindings, &found)
      case element
      when Any
        yield(bindings.merge(element.word => node)) if element.type.nil? || (node.leaf? && node.type == element.type)
      when Leaf
        yield(bindings) if leaf_matches?(element, node)
      when Branch
        match_children(element.children, node, 0, nil, bindings, &found) if node.named? && !node.leaf? && node.type == element.type
      end
    end

    def leaf_matches?(element, node)
      node.leaf? && node.named? == element.named && node.type == element.type && (!element.named || node.text == element.text)
    end

    # Matches the pattern's children against the node's children from
    # start, in order. first is the index of the first matched child. A
    # placeholder in a list waits as pending, and takes the children up to
    # the next match.
    def match_children(elements, node, start, first, bindings, pending = nil, &found)
      children = node.children
      if elements.empty?
        bindings = bindings.merge(pending => children[start..]) if pending
        yield(bindings) unless labelled_before?(children, first)
        return
      end

      (field, element), *rest = elements
      if field.nil? && element.is_a?(Any) && element.type.nil?
        bindings = bindings.merge(pending => []) if pending
        return match_children(rest, node, start, first, bindings, element.word, &found)
      end

      (start...children.size).each do |index|
        next unless field.nil? || children[index].field == field

        with_pending = pending ? bindings.merge(pending => children[start...index]) : bindings
        match_element(element, children[index], with_pending) do |matched|
          match_children(rest, node, index + 1, first || index, matched, &found)
        end
      end
    end

    def labelled_before?(children, first)
      first && children[0...first].any? { |child| child.named? && child.field }
    end

    ### Building ###

    def build_node(node, bindings)
      word = placeholder_word(node)
      if word
        raise ArgumentError, "{{#{word}}} in #{code.inspect} matched nothing" unless bindings.key?(word)

        bound = bindings[word]
        return bound.map { |child| Representer::Engine.deep_copy(child) } if bound.is_a?(Array)

        return Representer::Engine.deep_copy(bound).tap { |copy| copy.field = node.field }
      end

      copy = node.dup
      copy.span = nil
      copy.children = node.children.flat_map { |child| Array(build_node(child, bindings)) }
      copy
    end
  end
end
