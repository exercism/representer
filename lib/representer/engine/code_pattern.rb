module Representer::Engine
  # A code pattern is a pattern written as code in the language itself,
  # such as Ruby's `require "{{...}}"`. A language lists its
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
  # - A `rewrite`'s `as:` code can copy the code matched by a named
  #   placeholder. `{{...}}` is a placeholder with no name, for code that
  #   nothing copies, so `require "{{...}}"` matches any require.
  # - Some grammars wrap each item of a list in a node of its own, such as
  #   PHP's and C#'s `argument`. A placeholder that is the whole of such an
  #   item matches every item of that kind in a row, and at least one, so
  #   `f({{x}})` matches all of `f($a, $b)`, and doesn't match `f()`. Its
  #   match is each item, unwrapped if the item holds only one node, and
  #   the `as:` code wraps each one again.
  #
  # A `$word` is real code in Ruby, PHP, Perl, Bash, jq and JavaScript
  # templates, so placeholders use braces.
  #
  # The engine parses the code with the language's grammar and runs the
  # language's GenerateAST stage on it, so the pattern has the same shape
  # as a solution's tree. A raw pattern skips GenerateAST, for the
  # snippet, which works on the grammar's own tree. A pattern matches a node of the same type if the
  # pattern's children match the node's children in order. The node may
  # have more children between and after them (such as a method's body),
  # but nothing with a field name before them (such as a call's receiver).
  # So `require "{{file}}"` matches `require "set"`, and it doesn't match
  # `Kernel.require "set"`.
  #
  # Some code doesn't parse on its own, such as Ruby's `{ |{{x}}| }`, or
  # `def {{method}}({{x}})` without its `end`. The engine then tries the
  # code in each of the language's pattern contexts (see
  # Representation.pattern_contexts). A rule can also give its own context
  # with `inside:`. A context marks the code's place with `{{pattern}}`. The
  # pattern is the smallest node that holds all of the code, and it
  # matches that node wherever it appears. So `"*{{x}}"` inside
  # `"def f({{pattern}}) end"` matches a splat parameter in a method, a block or a
  # lambda.
  #
  # If one of the grammar's keywords comes out as a name, the engine
  # rejects that parse and tries the next context. So Ruby's
  # `rescue => {{x}}` can't become a pattern match on a variable called
  # `rescue`. If the code doesn't parse in any context, the engine tries
  # every context again with each placeholder capitalised, as Ruby's
  # `class {{x}}` needs.
  #
  # In some grammars the file is a flat list of tokens, such as Factor's
  # `USING: kernel math ;`. Code that is several top-level items of its
  # file becomes a run pattern, which matches a run of consecutive children
  # of any node. In a run, a placeholder matches as few children as it can,
  # and a placeholder at the end of the run matches one child. A run
  # pattern can only be dropped (see TreeHelpers#drop).
  #
  # An exact pattern (exactly: true) also requires each list in the code,
  # such as a method's parameters or statements, to hold nothing besides
  # the pattern's items, and each placeholder in a list then matches one
  # item. A part that the pattern leaves out, such as a method's body,
  # can still be anything. So the exact pattern `def f({{x}}) end` matches
  # `def f(a) = a + 1`, and doesn't match `def f(a, b) = a`.
  class CodePattern
    PLACEHOLDER = /\{\{([A-Za-z_]\w*|\.\.\.)\}\}/
    MARK = "{{pattern}}".freeze

    # Each `{{...}}` becomes `anything1__`, `anything2__` and so on, so that no
    # `as:` code can copy what it matched.
    ANONYMOUS = "anything".freeze

    # An Any is a placeholder. It matches any node if its type is
    # nil, and otherwise a leaf of its type.
    Any = Struct.new(:word, :type)

    # An Items is a placeholder that is the whole of a list item wrapped in
    # a node of its own, such as PHP's `argument`. In a list, it matches
    # every item of its branch's type in a row, and at least one. In an
    # exact pattern, it matches its branch, which is one item.
    Items = Struct.new(:word, :branch)

    Leaf = Struct.new(:type, :text, :named)

    # A Branch matches a node whose children match its children, which are
    # [field, element] pairs.
    Branch = Struct.new(:type, :children)

    # A Run matches a run of consecutive children, which match its
    # children, which are [field, element] pairs.
    Run = Struct.new(:children) do
      def type = nil
    end

    # Compiling a pattern parses code, so this returns a cached pattern.
    def self.[](language, code, inside: nil, raw: false, exactly: false)
      (@cache ||= {})[[language, code, inside, raw, exactly]] ||= new(language, code, inside:, raw:, exactly:)
    end

    attr_reader :code

    def initialize(language, code, inside: nil, raw: false, exactly: false)
      @language = language
      @code = code
      @raw = raw
      @exactly = exactly
      @words = {}
      @anonymous = Set.new
      @node = parse(inside)
      @root = compile(@node)
    end

    def type = @root.type

    # Returns every way the pattern matches the node. Each is a Hash from
    # each placeholder's word to its match. A placeholder in a list matches
    # a list of nodes. A word used more than once must match the same code
    # each time (see SameCode), and so must a word already in bindings.
    def matches(node, bindings = {})
      found = []
      match_element(@root, node, bindings) { |matched| found << matched }
      found
    end

    def match(node, bindings = {})
      match_element(@root, node, bindings) { |matched| return matched }
      nil
    end

    def run? = @root.is_a?(Run)

    # Returns the index ranges of the children that match a run pattern,
    # from the first child to the last, without overlaps.
    def runs(children)
      found = []
      index = 0
      while index < children.size
        stop = run_from(children, index)
        found << (index...stop) if stop
        index = stop || (index + 1)
      end
      found
    end

    # Returns the field and type of the pattern's last child with nothing in
    # it, such as the `{ }` of `if ({{...}}) { }`, or nil.
    def last_empty_child
      return nil unless @root.is_a?(Branch)

      field, child = @root.children.reverse.find { |_, element| element.is_a?(Branch) && element.children.empty? }
      [field, child.type] if child
    end

    # Returns the field of the pattern's child that holds the placeholder
    # with this word, such as `consequence` for the `{{body}}` of
    # `if ({{...}}) {{body}}`, or nil.
    def field_holding(word)
      return nil unless @root.is_a?(Branch)

      @root.children.find { |_, element| holds_word?(element, word) }&.first
    end

    # Builds the pattern's code as a new tree. Each placeholder becomes a
    # copy of its match in bindings.
    def build(bindings)
      built = Array(@node).flat_map { |node| Array(build_node(node, bindings)) }
      return built.first if built.one?

      raise ArgumentError, "The code #{code.inspect} must build one node"
    end

    def inspect = "#<CodePattern #{code.inspect}>"

    private
    def representation = @language.representation

    ### Parsing ###

    def parse(inside)
      contexts = inside ? [inside] : [MARK, *representation&.pattern_contexts]
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
      return run_or_node(tree, from, to) if @raw

      root = tree
      tree = @language.run_stage(:GenerateAST, tree)
      return run_or_node(tree, from, to) if node.equal?(root) && tree.equal?(root)

      contains?(tree, node) ? node : node_after_generate_ast(tree, from, to)
    rescue Representer::CannotRepresent
      nil
    end

    # Returns the root's children that hold the code, if the code is
    # several of them, and otherwise the code's node.
    def run_or_node(tree, from, to)
      node = smallest_node_holding(tree, from, to)
      return node unless node.equal?(tree)

      inside = tree.children.each_index.select { |index| inside?(tree.children[index], from, to) }
      inside.size > 1 ? tree.children[inside.first..inside.last] : node
    end

    # Whether the node holds part of the code and nothing outside it.
    def inside?(node, from, to)
      spans = []
      node.each_descendant { |descendant| spans << descendant.span if descendant.leaf? && descendant.span }
      spans.any? && spans.all? { |span| span.begin >= from && span.end <= to }
    end

    # GenerateAST can replace the code's node, as Ruby's turns `x if y`
    # into an `if`. The code's node is then the smallest node that holds
    # all of the code's leaves. If that is only a placeholder, it is the
    # outermost node built by GenerateAST around it, as in Ruby's
    # `"a#{{{x}}}"`, whose string is built from new leaves.
    def node_after_generate_ast(tree, from, to)
      leaves = Set.new.compare_by_identity
      tree.each_descendant { |node| leaves << node if node.leaf? && node.span && node.span.begin >= from && node.span.end <= to }
      node = tree
      built = nil
      while (child = node.children.find { |candidate| leaves.all? { |leaf| contains?(candidate, leaf) } })
        node = child
        built ||= node if node.span.nil?
      end
      node = built if built && placeholder_word(node)
      return node unless leaves.empty? || placeholder_word(node)

      raise ArgumentError, "#{@language.name}'s GenerateAST leaves too little of the code pattern #{code.inspect} to match"
    end

    # Writes each placeholder as a name that the grammar accepts: `{{file}}`
    # becomes `file__`, or `File__` when capitalised. A language can give
    # another suffix (see Representation.placeholder_suffix). Each `{{...}}` gets a
    # word of its own, such as `anything1__`.
    def spell(text, capitalised)
      count = 0
      text.gsub(PLACEHOLDER) do
        word = Regexp.last_match(1)
        if word == "..."
          word = "#{ANONYMOUS}#{count += 1}"
          @anonymous << word
        end
        spelling = "#{capitalised ? word[0].upcase + word[1..] : word}#{suffix}"
        @words[spelling] = word
        spelling
      end
    end

    # Returns the smallest named node that holds the code. If the code is
    # one token inside a larger node, such as the `readonly` of C#'s
    # `ref readonly int`, it returns that token.
    def smallest_node_holding(tree, from, to)
      node = tree
      while (child = node.children.find { |candidate| candidate.named? && candidate.span.begin <= from && candidate.span.end >= to })
        node = child
      end
      return node if node.span.nil? || (node.span.begin == from && node.span.end == to)

      node.children.find { |candidate| !candidate.named? && candidate.span&.begin == from && candidate.span&.end == to } || node
    end

    def suffix = representation&.placeholder_suffix || "__"

    def misread_keyword?(node)
      keywords = Grammar[@language.grammar].keywords - (representation&.keywords_used_as_names || [])
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
      return Run.new(node.map { |child| [child.field, compile(child)] }) if node.is_a?(Array)

      word = placeholder_word(node)
      if word
        return Any.new(word, representation&.names&.key?(node.type) ? nil : node.type)
      end
      return Leaf.new(node.type, node.named? ? node.text : nil, node.named?) if node.leaf?

      branch = Branch.new(node.type, node.children.map { |child| [child.field, compile(child)] })
      item_word = wrapped_placeholder_word(node)
      item_word ? Items.new(item_word, branch) : branch
    end

    # Returns the placeholder's word if the node only wraps a placeholder
    # that names any code, and adds no code of its own, as PHP's `argument`
    # wraps `$a` in `f($a)`.
    def wrapped_placeholder_word(node)
      return nil unless node.field.nil? && node.children.one? && node.span

      child = node.children.first
      word = placeholder_word(child)
      word if word && child.span == node.span && !representation&.names&.key?(node.type) &&
              representation&.names&.key?(child.type)
    end

    def holds_word?(element, word)
      case element
      when Any then element.word == word
      when Branch, Run then element.children.any? { |_, child| holds_word?(child, word) }
      when Items then element.word == word || holds_word?(element.branch, word)
      else false
      end
    end

    ### Matching ###

    # Returns the index after the run that matches from the index, or nil.
    def run_from(children, index)
      match_run(@root.children, children, index, {}) { |stop, _| return stop }
      nil
    end

    # Matches the elements against the children from the index, with
    # nothing between them, and yields the index after them and the
    # bindings. A placeholder tries the fewest children first.
    def match_run(elements, children, index, bindings, &found)
      return yield(index, bindings) if elements.empty?
      return if index >= children.size

      (field, element), *rest = elements
      if field.nil? && list_placeholder?(element)
        stops = rest.empty? ? [index + 1] : (index..children.size)
        stops.each do |stop|
          bound = bind(bindings, pending_for(element), children[index...stop])
          match_run(rest, children, stop, bound, &found) if bound
        end
        return
      end
      return unless field.nil? || children[index].field == field

      match_element(element, children[index], bindings) { |matched| match_run(rest, children, index + 1, matched, &found) }
    end

    def match_element(element, node, bindings, &found)
      case element
      when Run
        raise ArgumentError, "The code pattern #{code.inspect} is several top-level items, so it can only be dropped"
      when Any
        return unless element.type.nil? || (node.leaf? && node.type == element.type)

        bound = bind(bindings, element.word, node)
        yield(bound) if bound
      when Leaf
        yield(bindings) if leaf_matches?(element, node)
      when Branch
        match_children(element.children, node, 0, nil, bindings, &found) if node.named? && !node.leaf? && node.type == element.type
      when Items
        match_element(element.branch, node, bindings, &found)
      end
    end

    # Whether the element is a placeholder that matches a run of items in a
    # list.
    def list_placeholder?(element) = (element.is_a?(Any) && element.type.nil?) || element.is_a?(Items)

    def leaf_matches?(element, node)
      node.leaf? && node.named? == element.named && node.type == element.type && (!element.named || node.text == element.text)
    end

    # Matches the pattern's children against the node's children from
    # start, in order. first is the index of the first matched child. A
    # placeholder in a list waits as pending, and takes the children up to
    # the next match. In an exact pattern, it matches one child instead.
    def match_children(elements, node, start, first, bindings, pending = nil, &found)
      children = node.children
      if elements.empty?
        bindings = bind(bindings, pending, rest_of_list(pending, children[start..])) if pending
        yield(bindings) if bindings && !labelled_before?(children, first) && !unmatched_items?(children[start..])
        return
      end

      (field, element), *rest = elements
      if !@exactly && field.nil? && list_placeholder?(element)
        bindings = bind(bindings, pending, []) if pending
        return unless bindings

        return match_children(rest, node, start, first, bindings, pending_for(element), &found)
      end

      (start...children.size).each do |index|
        break if unmatched_items?(children[start...index]) || !wrapped_items?(pending, children[start...index])
        next unless field.nil? || children[index].field == field

        with_pending = pending ? bind(bindings, pending, children[start...index]) : bindings
        next unless with_pending

        match_element(element, children[index], with_pending) do |matched|
          match_children(rest, node, index + 1, first || index, matched, &found)
        end
      end
    end

    # A placeholder in a list waits as pending until the match knows its
    # items. An Items waits as itself, so that bind can check and unwrap
    # its items.
    def pending_for(element) = element.is_a?(Items) ? element : element.word

    # Returns the children that a pending placeholder takes at the end of
    # a list. An Items takes the items of its wrapper's type, and leaves
    # any other children after them, as a node may have more children
    # after the pattern's.
    def rest_of_list(pending, children)
      pending.is_a?(Items) ? children.take_while { |child| wrapped_item?(pending, child) } : children
    end

    # Whether an Items placeholder can take all of the children. It skips
    # tokens, such as the `type` of TypeScript's `import type { T }`.
    def wrapped_items?(pending, children)
      !pending.is_a?(Items) || children.all? { |child| wrapped_item?(pending, child) }
    end

    def wrapped_item?(items, child) = !child.named? || child.type == items.branch.type

    # Adds the word's match to the bindings, or returns nil if the word
    # already matched different code. A `{{...}}` binds nothing, so it
    # never has to match the `{{...}}` of another pattern.
    def bind(bindings, word, value)
      if word.is_a?(Items)
        value = value.select(&:named?)
        return nil if value.empty? || !wrapped_items?(word, value)

        value = unwrap_items(word.branch.type, value)
        word = word.word
      end
      return bindings if @anonymous.include?(word)
      return bindings.merge(word => value) unless bindings.key?(word)

      SameCode.(bindings[word], value) ? bindings : nil
    end

    # Unwraps each item that is a wrapper of the type around one node, so
    # `$a` in `f($a, b: $c)` matches as `$a`, and `b: $c` stays an argument.
    def unwrap_items(type, items)
      items.map { |item| item.type == type && item.children.one? ? item.children.first : item }
    end

    # Whether an exact pattern would skip one of these children. Only the
    # items of a list, which have no field name, count.
    def unmatched_items?(children) = @exactly && children.any? { |child| child.field.nil? }

    def labelled_before?(children, first)
      first && children[0...first].any? { |child| child.named? && child.field }
    end

    ### Building ###

    def build_node(node, bindings)
      word = wrapped_placeholder_word(node)
      return build_items(node, word, bindings) if word && bindings[word].is_a?(Array)

      word = placeholder_word(node)
      if word
        raise ArgumentError, "{{...}} in #{code.inspect} can't be copied" if @anonymous.include?(word)
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

    # Builds a copy of the wrapper around each item that the word matched,
    # and copies an item that is already a wrapper of the same type.
    def build_items(wrapper, word, bindings)
      raise ArgumentError, "{{...}} in #{code.inspect} can't be copied" if @anonymous.include?(word)

      bindings[word].map do |item|
        next Representer::Engine.deep_copy(item).tap { |copy| copy.field = wrapper.field } if item.type == wrapper.type

        build_node(wrapper, bindings.merge(word => item))
      end
    end
  end
end
