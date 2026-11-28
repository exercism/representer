module Inspector::Engine
  # A code pattern is a pattern written as code in the language itself,
  # such as Ruby's `require "{{_}}"`. A language lists its imports and its
  # Normalise rules as code patterns, so each one reads as the code it is
  # about.
  #
  # A pattern matches code exactly. A node matches if it has the pattern's
  # type and its children match the pattern's children one for one, with
  # nothing left over. So `f(1)` matches `f(1)`, and doesn't match
  # `f(1, 2)`, `x.f(1)` or `f(1) { }`.
  #
  # Placeholders stand for the code that can vary:
  #
  # - `{{x}}` matches exactly one item (one node, one argument, one
  #   statement) and binds it as x.
  # - `{{_}}` matches exactly one item and binds nothing.
  # - `{{...rest}}` matches zero or more items in a row and binds them all
  #   as rest, so a `rewrite`'s `as:` code can write them back.
  # - `{{...}}` matches zero or more items and binds nothing.
  #
  # So `f(1, {{...}})` matches `f(1)`, `f(1, 2)` and `f(1, 2, 3)`. The same
  # rules apply in every list: statements in a body, arguments, parameters,
  # array items and class members. A list placeholder in a field, such as
  # Go's `var {{...}} int`, takes the children in that field.
  #
  # Many grammars leave out a list's node when the list is empty, as Ruby's
  # leaves out the parameters of `def f`. A list node in the pattern that
  # holds only `{{...}}` placeholders therefore also matches no node, so
  # `def f({{...}}); {{...}}; end` matches `def f; end`.
  #
  # If the grammar reads a placeholder as something other than a name, the
  # placeholder matches one leaf of that kind. So `"{{_}}"` (in quotes)
  # matches one string without interpolation.
  #
  # Some grammars wrap each item of a list in a node of its own, such as
  # PHP's and C#'s `argument`. A placeholder that is the whole of such an
  # item matches whole items: `f({{x}})` matches `f($a)` with `$a` as x,
  # and `f({{...x}})` matches `f()` and `f($a, $b)`. Each matched item is
  # unwrapped if it holds only one node, and the `as:` code wraps each one
  # again.
  #
  # A `$word` is real code in Ruby, PHP, Perl, Bash, jq and JavaScript
  # templates, so placeholders use braces.
  #
  # The engine parses the code with the language's grammar and runs the
  # language's GenerateAST stage on it, so the pattern has the same shape
  # as a solution's tree. A raw pattern skips GenerateAST, for the
  # snippet, which works on the grammar's own tree.
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
  # of any node. In a run, `{{x}}` and `{{_}}` match one child, and a list
  # placeholder matches as few children as it can. A run pattern can only
  # be dropped (see TreeHelpers#drop).
  class CodePattern
    PLACEHOLDER = /\{\{(\.\.\.)?([A-Za-z_]\w*)?\}\}/
    MARK = "{{pattern}}".freeze

    # Each `{{_}}` and `{{...}}` becomes `anything1__`, `anything2__` and so
    # on, so that no `as:` code can copy what it matched.
    ANONYMOUS = "anything".freeze

    # An Any is a placeholder. It matches any node if its type is nil, and
    # otherwise a leaf of its type. A list one (many) matches any number of
    # items in a row.
    Any = Struct.new(:word, :type, :many)

    # An Items is a placeholder that is the whole of a list item wrapped in
    # a node of its own, such as PHP's `argument`. It matches one item of
    # its branch's type, or any number of them in a row if it is a list
    # one (many).
    Items = Struct.new(:word, :branch, :many, :wrappers)

    Leaf = Struct.new(:type, :text, :named)

    # A Branch matches a node whose children match its children, which are
    # [field, element] pairs.
    Branch = Struct.new(:type, :children)

    # A Run matches a run of consecutive children, which match its
    # children, which are [field, element] pairs.
    Run = Struct.new(:children) do
      def type = nil
    end

    # The word of a placeholder matched by PLACEHOLDER, such as `rest` for
    # `{{...rest}}`, or nil for `{{_}}` and `{{...}}`.
    def self.word(match)
      word = match[2]
      word unless word == "_"
    end

    # Compiling a pattern parses code, so this returns a cached pattern.
    def self.[](language, code, inside: nil, raw: false)
      (@cache ||= {})[[language, code, inside, raw]] ||= new(language, code, inside:, raw:)
    end

    attr_reader :code

    def initialize(language, code, inside: nil, raw: false)
      @language = language
      @code = code
      @raw = raw
      @words = {}
      @anonymous = Set.new
      @lists = Set.new
      @node = parse(inside)
      @root = compile(@node)
    end

    def type = @root.type

    # Returns every way the pattern matches the node. Each is a Hash from
    # each placeholder's word to its match. A list placeholder matches a
    # list of nodes. A word used more than once must match the same code
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
        found << (index...stop) if stop && stop > index
        index = stop && stop > index ? stop : index + 1
      end
      found
    end

    # Returns the field and type of the pattern's last child with nothing in
    # it, such as the `{ }` of `if ({{_}}) { }`, or nil.
    def last_empty_child
      return nil unless @root.is_a?(Branch)

      field, child = @root.children.reverse.find { |_, element| element.is_a?(Branch) && element.children.empty? }
      [field, child.type] if child
    end

    # Returns the field of the pattern's child that holds the placeholder
    # with this word, such as `consequence` for the `{{body}}` of
    # `if ({{_}}) {{body}}`, or nil.
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
          @capitalised = capitalised
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
    rescue Inspector::CannotRepresent
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
    # and `{{...file}}` become `file__`, or `File__` when capitalised. A
    # language can give another suffix (see Representation.placeholder_suffix).
    # Each `{{_}}` and `{{...}}` gets a word of its own, such as `anything1__`.
    def spell(text, capitalised)
      count = 0
      text.gsub(PLACEHOLDER) do
        match = Regexp.last_match
        raise ArgumentError, "The placeholder {{}} in #{code.inspect} needs a word, _ or ..." unless match[1] || match[2]

        word = CodePattern.word(match)
        unless word
          word = "#{ANONYMOUS}#{count += 1}"
          @anonymous << word
        end
        @lists << word if match[1]
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
        type = representation&.names&.key?(node.type) ? nil : node.type
        return Any.new(word, type, @lists.include?(word))
      end
      return Leaf.new(node.type, node.named? ? node.text : nil, node.named?) if node.leaf?

      return Any.new(anonymous_list_word(node), nil, true) if !node.equal?(@node) && made_of_anonymous_lists?(node)
      return compile(node.children.first) if built_around_a_placeholder?(node)

      branch = Branch.new(node.type, node.children.map { |child| [child.field, compile(child)] })
      types = wrapper_types(node)
      return branch unless types

      word = placeholder_word(innermost(node))
      Items.new(word, branch, @lists.include?(word), types)
    end

    # Returns the placeholder's word if the node only wraps a placeholder
    # that names any code, and adds no code of its own, as PHP's `argument`
    # wraps `$a` in `f($a)`. The wrapper can wrap another wrapper, as D's
    # `imported` wraps a `module_fqn` around the name.
    def wrapped_placeholder_word(node)
      wrapper_types(node) && placeholder_word(innermost(node))
    end

    # The types of the wrappers from the node down to the placeholder, or
    # nil if the node isn't a wrapper.
    def wrapper_types(node)
      return nil unless node.children.one? && node.span && !representation&.names&.key?(node.type)

      child = node.children.first
      return nil unless child.span == node.span

      word = placeholder_word(child)
      return [node.type] if word && representation&.names&.key?(child.type)

      inner = !child.leaf? && wrapper_types(child)
      [node.type, *inner] if inner
    end

    def innermost(node) = node.leaf? ? node : innermost(node.children.first)

    # Whether GenerateAST built the node around a capitalised placeholder,
    # as Erlang's wraps each variable in a `variable` node. The placeholder
    # then stands for the node, so it still matches any code.
    def built_around_a_placeholder?(node)
      @capitalised && node.span.nil? && node.children.one? && placeholder_word(node.children.first)
    end

    # Whether the node holds two or more `{{...}}` and nothing else but
    # tokens, such as Erlang's `{{...}}/{{...}}`. Such an item stands for
    # any number of items, for a list where the grammar can't read
    # `{{...}}` alone as an item.
    def made_of_anonymous_lists?(node)
      leaves = []
      node.each_descendant { |descendant| leaves << descendant if descendant.leaf? && descendant.named? }
      words = leaves.map { |leaf| placeholder_word(leaf) }
      words.size > 1 && words.all? { |word| @anonymous.include?(word) && @lists.include?(word) }
    end

    def anonymous_list_word(node)
      node.each_descendant { |descendant| return placeholder_word(descendant) if descendant.leaf? && descendant.named? }
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
    # bindings. A list placeholder tries the fewest children first.
    def match_run(elements, children, index, bindings, &found)
      return yield(index, bindings) if elements.empty?

      (field, element), *rest = elements
      if field.nil? && list?(element)
        (index..children.size).each do |stop|
          bound = bind(bindings, element, children[index...stop])
          match_run(rest, children, stop, bound, &found) if bound
        end
        return
      end
      return if index >= children.size
      return unless field.nil? || children[index].field == field

      match_element(element, children[index], bindings) { |matched| match_run(rest, children, index + 1, matched, &found) }
    end

    def match_element(element, node, bindings, &found)
      case element
      when Run
        raise ArgumentError, "The code pattern #{code.inspect} is several top-level items, so it can only be dropped"
      when Any
        return unless element.type.nil? || (node.leaf? && node.type == element.type)

        bound = bind(bindings, element, element.many ? [node] : node)
        yield(bound) if bound
      when Leaf
        yield(bindings) if leaf_matches?(element, node)
      when Branch
        match_children(element.children, node.children, 0, bindings, &found) if node.named? && !node.leaf? && node.type == element.type
      when Items
        return unless node.named? && node.type == element.branch.type

        bound = bind(bindings, element, element.many ? [node] : node)
        yield(bound) if bound
      end
    end

    def list?(element) = element.is_a?(Any) || element.is_a?(Items) ? element.many : false

    def leaf_matches?(element, node)
      node.leaf? && node.named? == element.named && node.type == element.type && (!element.named || node.text == element.text)
    end

    # Matches the pattern's children against the node's children from the
    # index, one for one, and yields the bindings if no child is left over.
    def match_children(elements, children, index, bindings, &found)
      if elements.empty?
        yield(bindings) if index == children.size
        return
      end

      (field, element), *rest = elements
      return match_list(field, element, rest, children, index, bindings, &found) if list?(element)

      skip_optional(elements, children, index, bindings, &found)
      child = children[index]

      # A child the pattern gives no field can have one in the code, as the
      # body of Ruby's `def f = x` has and the body of `def f; x; end` hasn't.
      return unless child && (field.nil? || child.field == field)

      match_element(element, child, bindings) { |matched| match_children(rest, children, index + 1, matched, &found) }
    end

    # Matches a list placeholder against each run of the children from the
    # index that it can take, the fewest first, and the rest of the
    # pattern against the children after the run.
    def match_list(field, element, rest, children, index, bindings, &found)
      stop = index
      stop += 1 while stop < children.size && takes?(field, element, children[stop])
      (index..stop).each do |last|
        bound = bind(bindings, element, children[index...last])
        match_children(rest, children, last, bound, &found) if bound
      end
    end

    # Whether a list placeholder in the field can take the child. A typed
    # placeholder takes only leaves of its type.
    def takes?(field, element, child)
      return false unless child.field == field

      !(element.is_a?(Any) && element.type) || (child.leaf? && child.type == element.type)
    end

    # Matches the rest of the pattern without its next element if that is
    # optional, or without a token and the empty list or optional element
    # after it. So Haskell's `import {{...}} as {{...}}` also matches
    # `import Data.List`, and `f(1, {{...}})` matches `f(1)` in a grammar
    # that keeps the commas.
    def skip_optional(elements, children, index, bindings, &found)
      skipped = optional?(*elements.first) ? 1 : 0
      skipped = 2 if skipped.zero? && token?(elements.first.last) && elements[1] && skippable?(*elements[1])
      return if skipped.zero?

      bound = bind_nothing(elements[skipped - 1].last, bindings)
      match_children(elements.drop(skipped), children, index, bound, &found) if bound
    end

    def skippable?(field, element) = list?(element) || optional?(field, element)

    def token?(element) = element.is_a?(Leaf) && !element.named

    # Whether the element is a node in a field that holds only list
    # placeholders and tokens, which also matches no node, as a grammar
    # leaves out an empty list. So Ruby's `else {{...}}` also matches an
    # `if` with no `else`.
    def optional?(field, element)
      field && element.is_a?(Branch) && element.children.any? { |_, child| list?(child) } &&
        element.children.all? { |_, child| list?(child) || token?(child) }
    end

    # Binds each list placeholder in the skipped element to no items.
    def bind_nothing(element, bindings)
      return bind(bindings, element, []) if list?(element)

      element.children.reduce(bindings) { |bound, (_, child)| list?(child) ? bound && bind(bound, child, []) : bound }
    end

    # Adds the placeholder's match to the bindings, or returns nil if its
    # word already matched different code. A `{{_}}` or `{{...}}` binds
    # nothing, so it never has to match another one.
    def bind(bindings, element, value)
      value = unwrap_items(element.wrappers, value) if element.is_a?(Items)
      word = element.word
      return bindings if @anonymous.include?(word)
      return bindings.merge(word => value) unless bindings.key?(word)

      SameCode.(bindings[word], value) ? bindings : nil
    end

    # Unwraps each item that is a wrapper of the type around one node, so
    # `$a` in `f($a, b: $c)` matches as `$a`, and `b: $c` stays an argument.
    # A list leaves out the tokens between the items.
    def unwrap_items(types, value)
      return unwrap_item(types, value) unless value.is_a?(Array)

      value.select(&:named?).map { |item| unwrap_item(types, item) }
    end

    def unwrap_item(types, item)
      types.each do |type|
        break unless item.type == type && item.children.one?

        item = item.children.first
      end
      item
    end

    ### Building ###

    def build_node(node, bindings)
      word = wrapped_placeholder_word(node)
      if word && bindings.key?(word) && (bindings[word].is_a?(Array) || bindings[word].type == node.type)
        return build_items(node, word, bindings)
      end

      word = placeholder_word(node)
      if word
        raise ArgumentError, "{{_}} and {{...}} in #{code.inspect} can't be copied" if @anonymous.include?(word)
        raise ArgumentError, "{{#{word}}} in #{code.inspect} matched nothing" unless bindings.key?(word)

        bound = bindings[word]
        copies = Array(bound).map { |child| Inspector::Engine.deep_copy(child).tap { |copy| copy.field = node.field } }
        return bound.is_a?(Array) ? copies : copies.first
      end

      copy = node.dup
      copy.span = nil
      copy.children = node.children.flat_map { |child| Array(build_node(child, bindings)) }
      copy
    end

    # Builds a copy of the wrapper around each item that the word matched,
    # and copies an item that is already a wrapper of the same type.
    def build_items(wrapper, word, bindings)
      raise ArgumentError, "{{_}} and {{...}} in #{code.inspect} can't be copied" if @anonymous.include?(word)

      Array(bindings[word]).map do |item|
        next Inspector::Engine.deep_copy(item).tap { |copy| copy.field = wrapper.field } if item.type == wrapper.type

        build_node(wrapper, bindings.merge(word => item))
      end
    end
  end
end
