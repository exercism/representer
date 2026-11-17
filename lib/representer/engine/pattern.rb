require "strscan"

module Representer
  module Engine
    # Tree patterns, written in a subset of tree-sitter's query syntax.
    #
    # Language classes use patterns to say which nodes a rule applies to, and
    # rewrite rules use the same syntax for templates. The syntax is:
    #
    #   (type child...)     a node of this type, whose children match the
    #                       child patterns in order (other children may sit
    #                       between them). (_) matches any named node.
    #   field: pattern      the child with this field name matches the pattern.
    #   !field              the node has no child with this field name.
    #   "text"              an anonymous token with this text, such as "=="
    #                       or "if". Inside a leaf's pattern, such as
    #                       (identifier "String"), it matches the leaf's text.
    #   /regex/             like "text", but matches a regular expression.
    #   [a b c]             any one of the patterns.
    #   _                   any node at all, named or anonymous.
    #   pattern?            the pattern may match nothing.
    #   pattern*            as a child pattern, matches every remaining child
    #                       that fits. Its captures (and those inside it)
    #                       become lists.
    #   pattern @name       captures the matched node as "name".
    #
    # Patterns match the engine's own nodes (Engine::Node), so they also see
    # changes made by earlier rewrite rules.
    module Pattern
      # In a template, @name always inserts a capture, and never captures
      # the element before it.
      def self.parse(source, template: false) = Parser.new(source, template:).parse

      # The common parts of every kind of pattern element.
      class Element
        attr_accessor :captures, :optional, :many

        def initialize
          @captures = []
          @optional = false
          @many = false
        end

        # Returns a Hash of captures if the node matches, otherwise nil.
        def match(node)
          return nil unless matches?(node)

          found = inner_captures(node)
          return nil unless found

          captures.each { |name| found[name] = node }
          found
        end

        def text_only? = false

        private
        def inner_captures(_node) = {}
      end

      # Matches any node: _
      class Wildcard < Element
        def matches?(_node) = true
      end

      # Matches an anonymous token, or a leaf's text: "==" or /\A\d+\z/
      class Text < Element
        attr_reader :value

        def initialize(value)
          super()
          @value = value
        end

        def matches?(node)
          return false unless node.leaf?

          text = node.named? ? node.text : node.type
          @value.is_a?(Regexp) ? @value.match?(text) : @value == text
        end

        def text_only? = true
      end

      # Matches any of several patterns: [a b c]
      class Alternation < Element
        attr_reader :options

        def initialize(options)
          super()
          @options = options
        end

        def matches?(node) = @options.any? { |option| option.match(node) }
        def text_only? = @options.all?(&:text_only?)

        private
        def inner_captures(node) = @options.lazy.filter_map { |option| option.match(node) }.first
      end

      # Matches a node and its children: (type field: (child) "token" !other)
      class NodePattern < Element
        attr_reader :type, :fields, :negated, :ordered, :sequence

        # sequence lists every child element with its field name (or nil), in
        # the order written, which templates need.
        def initialize(type, sequence, negated)
          super()
          @type = type
          @sequence = sequence
          @fields = sequence.select(&:first)
          @ordered = sequence.reject(&:first).map(&:last)
          @negated = negated
        end

        def matches?(node)
          type == "_" ? node.named? : node.type == type
        end

        private
        def inner_captures(node)
          return nil if negated.any? { |field| node[field] }

          found = {}
          fields.each do |field, element|
            match = node.children.lazy.select { |child| child.field == field }.filter_map { |child| element.match(child) }.first
            return nil unless match || element.optional

            found.merge!(match) if match
          end

          # In a leaf's pattern, text elements match the leaf's own text.
          if node.leaf? && ordered.any? && ordered.all?(&:text_only?)
            ordered.each do |element|
              match = element.match(node)
              return nil unless match || element.optional

              found.merge!(match) if match
            end
            return found
          end

          sequence = match_sequence(ordered, node.children, 0)
          sequence && found.merge!(sequence)
        end

        # Matches the elements against the children in order, allowing other
        # children between them, and backtracking if a later element fails.
        def match_sequence(elements, children, start)
          return {} if elements.empty?

          element, *rest = elements
          if element.many
            found = Hash.new { |hash, name| hash[name] = [] }
            element.captures.each { |name| found[name] }
            children[start..].each do |child|
              element.match(child)&.each { |name, captured| found[name].concat(Array(captured)) }
            end
            remaining = match_sequence(rest, children, start)
            return remaining && found.merge(remaining)
          end

          (start...children.size).each do |index|
            match = element.match(children[index])
            next unless match

            remaining = match_sequence(rest, children, index + 1)
            return match.merge(remaining) if remaining
          end
          element.optional ? match_sequence(rest, children, start) : nil
        end
      end

      # A capture on its own (@name), which only templates use.
      class CaptureReference < Element
        attr_reader :name

        def initialize(name)
          super()
          @name = name
        end

        def matches?(_node) = raise(ArgumentError, "@#{name} on its own can only be used in a template")
      end

      class Parser
        TOKEN = %r{\s+|;[^\n]*|"(?:[^"\\]|\\.)*"|/(?:[^/\\]|\\.)*/|[()\[\]?!*]|@[\w.]+|[\w.-]+:|[\w.-]+}

        def initialize(source, template: false)
          @source = source
          @template = template
          @tokens = []
          scanner = StringScanner.new(source)
          until scanner.eos?
            token = scanner.scan(TOKEN) or raise ArgumentError, "Can't read pattern at: #{scanner.rest[0, 20].inspect}"
            @tokens << token unless token.match?(/\A(\s|;)/)
          end
        end

        def parse
          element = parse_element
          raise ArgumentError, "Unexpected #{@tokens.first.inspect} in pattern #{@source.inspect}" unless @tokens.empty?

          element
        end

        private
        def parse_element
          token = @tokens.shift or raise ArgumentError, "Pattern ended early: #{@source.inspect}"
          element =
            case token
            when "(" then parse_node
            when "[" then parse_alternation
            when "_" then Wildcard.new
            when /\A"/ then Text.new(token[1..-2].gsub(/\\(.)/, '\1'))
            when %r{\A/} then Text.new(Regexp.new(token[1..-2]))
            when /\A@/ then return CaptureReference.new(token[1..])
            else raise ArgumentError, "Unexpected #{token.inspect} in pattern #{@source.inspect}"
            end

          element.optional = !@tokens.shift.nil? if @tokens.first == "?"
          element.many = !@tokens.shift.nil? if @tokens.first == "*"
          element.captures << @tokens.shift[1..] while !@template && @tokens.first&.start_with?("@")
          element
        end

        def parse_node
          type = @tokens.shift
          sequence = []
          negated = []
          until @tokens.first == ")"
            raise ArgumentError, "Missing ) in pattern #{@source.inspect}" if @tokens.empty?

            if @tokens.first == "!"
              @tokens.shift
              negated << @tokens.shift
            elsif @tokens.first.end_with?(":")
              sequence << [@tokens.shift.chomp(":"), parse_element]
            else
              sequence << [nil, parse_element]
            end
          end
          @tokens.shift
          NodePattern.new(type, sequence, negated)
        end

        def parse_alternation
          options = []
          options << parse_element until @tokens.first == "]"
          @tokens.shift
          Alternation.new(options)
        end
      end
    end
  end
end
