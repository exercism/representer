# The base class for every language written with the rule DSL. Each
# subclass describes its language with the rules below, and the engine
# (Engine::Represent) applies them. These are the languages still on the
# old structure. New languages are staged (see Engine::Language), and these
# languages will move to stages.
#
# A language's representation is its syntax tree, written out as an
# s-expression after these steps:
#
# 1. Parse each file with the language's tree-sitter grammar. If that
#    fails, the solution gets no representation.
# 2. Drop: remove nodes and tokens that carry no meaning, such as comments
#    and brackets (the tree's shape already says what they group).
# 3. Rewrite: turn different spellings of the same code into one, such as
#    `x if y` into a block `if`.
#    The files' trees are then joined into one, in an order that depends
#    only on their code, and the rewrite rules run again on the whole. A
#    file's name is never part of the representation.
# 4. Rename: replace each name the student chose with a placeholder, and
#    keep every name with a meaning outside the solution (names the
#    tests use, names the language calls itself).
#
# CONTRIBUTING.md explains how to add a language.
class Representer::Language
  Match = Struct.new(:node, :captures) do
    def [](name) = captures[name.to_s]
  end
  Rule = Struct.new(:pattern, :where, :action) do
    def match(node)
      captures = pattern.match(node)
      return nil unless captures

      match = Match.new(node, captures)
      where.nil? || where.(match) ? match : nil
    end
  end

  class << self
    include Representer::LanguageSetup

    # Called by Representer when it picks a language for a track.
    def call(solution_files, exercise_files) = Representer::Engine::Represent.(self, solution_files, exercise_files)

    # A Language is written with the rule DSL below. A staged language (see
    # Engine::Language) is written as stage classes.
    def staged? = false

    # How Engine::Grammar#parse copies a tree for this language.
    def parse_options
      { skip_tokens: dropped_tokens, kept_tokens:, text_types: text_node_types, gap_types: }
    end

    ### Setup ###
    # LanguageSetup gives tracks, version, grammar, extensions, names,
    # and fold_names.

    # Starts with all of another language's rules and names, for a language
    # that is a superset of it (such as TypeScript from JavaScript). Call it
    # before the language's own rules, which are added to the copied ones.
    def inherit(parent)
      @names = parent.names.dup
      @dropped_tokens = parent.dropped_tokens.dup
      @kept_tokens = parent.kept_tokens.transform_values(&:dup)
      @gap_types = parent.gap_types.dup
      @kept_names = parent.kept_names.dup
      @syntax_checks = parent.syntax_checks.dup
      %i[drop_rules rewrite_rules local_rules member_rules member_position_rules keep_rules].each do |rules|
        instance_variable_set("@#{rules}", parent.public_send(rules).dup)
      end
    end

    # Node types whose children don't cover all their text, such as
    # Python's string_content. Each stretch of text between the children
    # becomes a "fragment" leaf (see Engine::Grammar#parse).
    def text_between_children(*types) = gap_types.merge(types.map(&:to_s))

    # Node types that hold their whole source text as a leaf, for nodes whose
    # text isn't made of child nodes. Gleam's module path `gleam/list` is
    # one, because the tree only has its slashes as children.
    def text_nodes(*types) = text_node_types.merge(types.map(&:to_s))

    # Finds code that the grammar accepts but the language rejects, such as
    # Python 2's `print "x"`. The block receives the source and the parsed
    # tree (before any rules run), and returns a message if the code is
    # invalid. The solution then gets no representation (parse_error).
    def syntax_check(&block) = syntax_checks << block

    ### Drop rules ###

    # Removes every node that matches the pattern, such as "(comment)".
    def drop(pattern, where: nil) = drop_rules << Rule.new(Representer::Engine::Pattern.parse(pattern), where)

    # Leaves these anonymous tokens out of the tree, such as "(" or ";".
    # Only drop a token if the node type already says everything it says.
    def drop_tokens(*tokens) = dropped_tokens.merge(tokens)

    # Keeps some of the dropped tokens in nodes of one type, where they are
    # the only thing that tells two programs apart. C++ drops "[" and "]",
    # but keeps them in a delete_expression, as `delete[] p` and `delete p`
    # are different.
    def keep_tokens_in(type, *tokens) = (kept_tokens[type.to_s] ||= Set.new).merge(tokens)

    ### Rewrite rules ###

    # Replaces each node that matches the pattern. Give either a template
    # (see Engine::Template) or a block, which receives the Match and
    # returns the replacement node, or nil to leave the node as it is.
    # Rules apply from the leaves up, and again to their own results.
    def rewrite(pattern, template = nil, where: nil, &block)
      raise ArgumentError, "Give a rewrite either a template or a block" unless template.nil? ^ block.nil?

      unless block
        built = Representer::Engine::Template.new(template)
        block = ->(match) { built.build(match.captures) }
      end
      rewrite_rules << Rule.new(Representer::Engine::Pattern.parse(pattern), where, block)
    end

    # Gives nodes of one type another type, for two spellings with the same
    # meaning, such as Ruby's `do ... end` and `{ ... }` blocks.
    def retype(mapping)
      mapping.each do |from, to|
        rewrite("(#{from}) @node") { |match| match.node.tap { |node| node.type = to.to_s } }
      end
    end

    # Replaces a node that has exactly one named child with that child, for
    # brackets that only group: the tree's shape already shows the grouping.
    def unwrap(*types)
      types.each do |type|
        rewrite("(#{type}) @node", where: ->(match) { match.node.named_children.size == 1 }) do |match|
          match.node.named_children.first
        end
      end
    end

    # Writes every number leaf of these types in one canonical form. The
    # block receives the number's text and returns its canonical text, or
    # nil to keep the text as it is (see Engine::Numbers for readers). Only
    # give two spellings one form if the language reads them as the same
    # value of the same type.
    def numbers(*types, &canonical)
      types.each do |type|
        rewrite("(#{type}) @number", where: ->(match) { match.node.leaf? }) do |match|
          text = yield(match.node.text)
          !text || text == match.node.text ? nil : leaf(match.node.type, text)
        end
      end
    end

    ### Rename rules ###
    # Each pattern captures the name's leaf as @name.

    # A name the student defines for a local variable or parameter. These
    # names are renamed everywhere except after a dot (see member).
    def rename(pattern) = local_rules << Rule.new(Representer::Engine::Pattern.parse(pattern))

    # A name the student defines for a method, function, property, class or
    # constant. These names are renamed everywhere, including after a dot.
    def rename_member(pattern) = member_rules << Rule.new(Representer::Engine::Pattern.parse(pattern))

    # A name used after a dot (obj.name), or anywhere else that refers to a
    # member of some other object. It is only renamed if the solution
    # defines a member with that name.
    def member(pattern) = member_position_rules << Rule.new(Representer::Engine::Pattern.parse(pattern))

    # Names that are never renamed. Give names (such as "initialize", which
    # the language calls itself), or a pattern that captures @name (such as
    # keyword parameters, which callers use).
    def keep(*names_or_patterns)
      names_or_patterns.each do |item|
        if item.start_with?("(", "[")
          keep_rules << Rule.new(Representer::Engine::Pattern.parse(item))
        else
          kept_names << item
        end
      end
    end

    ### Rule builders, for rewrite blocks ###

    # A new node. Children can be nodes, or field: node pairs.
    def build(type, *children)
      nodes = children.flat_map do |child|
        next [child] unless child.is_a?(Hash)

        child.map { |field, node| node.tap { node.field = field.to_s } }
      end
      Representer::Engine::Node.new(type, nodes.compact)
    end

    def leaf(type, text) = Representer::Engine::Node.leaf(type, text)

    # A literal value (such as a string's contents), which the output
    # always writes in quotes. Its type is "literal" in every language, so
    # a rule that matches the grammar's string type won't match it again.
    def literal(value) = Representer::Engine::Node.leaf("literal", value, quoted: true)

    def token(text) = Representer::Engine::Node.token(text)

    def copy(node) = Representer::Engine.deep_copy(node)

    ### Read by the engine ###

    def gap_types = @gap_types ||= Set.new
    def text_node_types = @text_node_types ||= Set.new
    def syntax_checks = @syntax_checks ||= []
    def drop_rules = @drop_rules ||= []
    def dropped_tokens = @dropped_tokens ||= Set.new
    def kept_tokens = @kept_tokens ||= {}
    def rewrite_rules = @rewrite_rules ||= []
    def local_rules = @local_rules ||= []
    def member_rules = @member_rules ||= []
    def member_position_rules = @member_position_rules ||= []
    def keep_rules = @keep_rules ||= []
    def kept_names = @kept_names ||= Set.new
  end
end
