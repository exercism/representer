module Representer
  # The base class for every language with its own representer. Each
  # subclass describes its language with the rules below, and the engine
  # (Engine::Represent) applies them.
  #
  # A language's representation is its syntax tree, written out as an
  # s-expression after these steps:
  #
  # 1. Parse each file with the language's tree-sitter grammar. If that
  #    fails, the solution gets the Basic representation instead.
  # 2. Drop: remove nodes and tokens that carry no meaning, such as comments
  #    and brackets (the tree's shape already says what they group).
  # 3. Rewrite: turn different spellings of the same code into one, such as
  #    `x if y` into a block `if`.
  # 4. Rename: replace each name the student chose with a placeholder, and
  #    keep every name with a meaning outside the solution (library names,
  #    names the tests use, names the language calls itself).
  #
  # CONTRIBUTING.md explains how to add a language.
  class Language
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
      # Called by Representer when it picks a language for a track.
      def call(solution_files, exercise_files) = Engine::Represent.(self, solution_files, exercise_files)

      ### Setup ###

      # The track slugs this class represents.
      def tracks(*slugs)
        slugs.each { |slug| Languages.register(slug, self) }
      end

      # The representer version for this language. Bump it whenever the
      # output for any solution changes, including a change to Basic, which
      # this language falls back to. Versions start at 2, because the old
      # per-track representers all reported 1.
      def version(number = nil)
        return @version unless number
        raise ArgumentError, "A version must be from 2 to 32767" unless (2..32_767).cover?(number)

        @version = number
      end

      # The grammar's name in grammars.yml.
      def grammar(name = nil) = name ? @grammar = name : @grammar

      # The file extensions of the language's source files. Exercise files
      # with other extensions (such as .meta/config.json) are ignored.
      def extensions(*list) = list.empty? ? @extensions : @extensions = list

      # The leaf types that hold names, which the rename rules may rename.
      # A keyword gives a prefix that is not part of the name, such as Ruby's
      # `simple_symbol: ":"` for `:name`.
      def names(*types, **prefixed)
        return @names if types.empty? && prefixed.empty?

        @names = types.to_h { |type| [type.to_s, ""] }.merge(prefixed.transform_keys(&:to_s))
      end

      # Starts with all of another language's rules and names, for a language
      # that is a superset of it (such as TypeScript from JavaScript). Call it
      # before the language's own rules, which are added to the copied ones.
      def inherit(parent)
        @names = parent.names.dup
        @dropped_tokens = parent.dropped_tokens.dup
        @gap_types = parent.gap_types.dup
        @kept_names = parent.kept_names.dup
        @library_names = parent.library.dup
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

      ### Drop rules ###

      # Removes every node that matches the pattern, such as "(comment)".
      def drop(pattern, where: nil) = drop_rules << Rule.new(Engine::Pattern.parse(pattern), where)

      # Leaves these anonymous tokens out of the tree, such as "(" or ";".
      # Only drop a token if the node type already says everything it says.
      def drop_tokens(*tokens) = dropped_tokens.merge(tokens)

      ### Rewrite rules ###

      # Replaces each node that matches the pattern. Give either a template
      # (see Engine::Template) or a block, which receives the Match and
      # returns the replacement node, or nil to leave the node as it is.
      # Rules apply from the leaves up, and again to their own results.
      def rewrite(pattern, template = nil, where: nil, &block)
        raise ArgumentError, "Give a rewrite either a template or a block" unless template.nil? ^ block.nil?

        unless block
          built = Engine::Template.new(template)
          block = ->(match) { built.build(match.captures) }
        end
        rewrite_rules << Rule.new(Engine::Pattern.parse(pattern), where, block)
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

      ### Rename rules ###
      # Each pattern captures the name's leaf as @name.

      # A name the student defines for a local variable or parameter. These
      # names are renamed everywhere except after a dot (see member).
      def rename(pattern) = local_rules << Rule.new(Engine::Pattern.parse(pattern))

      # A name the student defines for a method, function, property, class or
      # constant. These names are renamed everywhere, including after a dot,
      # unless they are also library names (see library_names).
      def rename_member(pattern) = member_rules << Rule.new(Engine::Pattern.parse(pattern))

      # A name used after a dot (obj.name), or anywhere else that refers to a
      # member of some other object. It is only renamed if the solution
      # defines a member with that name.
      def member(pattern) = member_position_rules << Rule.new(Engine::Pattern.parse(pattern))

      # Names that are never renamed. Give names (such as "initialize", which
      # the language calls itself), or a pattern that captures @name (such as
      # keyword parameters, which callers use).
      def keep(*names_or_patterns)
        names_or_patterns.each do |item|
          if item.start_with?("(", "[")
            keep_rules << Rule.new(Engine::Pattern.parse(item))
          else
            kept_names << item
          end
        end
      end

      # A file of library names, one per line (the language's core and
      # standard library). If the student defines a method or property with
      # one of these names, it is kept, so `def sum(a) = a.sum` and
      # `def max(a) = a.max` stay apart.
      def library_names(path)
        @library_names = File.readlines(path, chomp: true).reject { |line| line.empty? || line.start_with?("#") }.to_set
      end

      ### Rule builders, for rewrite blocks ###

      # A new node. Children can be nodes, or field: node pairs.
      def build(type, *children)
        nodes = children.flat_map do |child|
          next [child] unless child.is_a?(Hash)

          child.map { |field, node| node.tap { node.field = field.to_s } }
        end
        Engine::Node.new(type, nodes.compact)
      end

      # A named leaf, such as an identifier.
      def leaf(type, text) = Engine::Node.leaf(type, text)

      # A literal value (such as a string's contents), which the output
      # always writes in quotes. Its type is "literal" in every language, so
      # a rule that matches the grammar's string type won't match it again.
      def literal(value) = Engine::Node.leaf("literal", value, quoted: true)

      # An anonymous token, such as "!".
      def token(text) = Engine::Node.token(text)

      def copy(node) = Engine.deep_copy(node)

      ### Read by the engine ###

      def gap_types = @gap_types ||= Set.new
      def text_node_types = @text_node_types ||= Set.new
      def drop_rules = @drop_rules ||= []
      def dropped_tokens = @dropped_tokens ||= Set.new
      def rewrite_rules = @rewrite_rules ||= []
      def local_rules = @local_rules ||= []
      def member_rules = @member_rules ||= []
      def member_position_rules = @member_position_rules ||= []
      def keep_rules = @keep_rules ||= []
      def kept_names = @kept_names ||= Set.new
      def library = @library_names || Set.new
    end
  end
end
