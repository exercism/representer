module Representer::Engine
  # Each exercise's rules are a class that subclasses this one, in the
  # language's `analysis/` folder (see Analysis). Each rule starts with a
  # condition written as code patterns (see CodePattern), and its block
  # says what to do when the condition holds:
  #
  #   class Leap < Representer::Engine::AnalysisRules
  #     within "def self.leap?({{...}}); {{...}}; end" do
  #       uses("Date.leap?") { actionable "ruby.leap.std_lib" }
  #     end
  #   end
  #
  # The rules run in the order they are written, on the analysis's tree of
  # the solution's main file, and the analysis returns every comment they
  # add. A block is plain Ruby run on the rules, so it can hold more rules,
  # which run only when its condition holds. docs/dsl.md describes
  # every verb.
  class AnalysisRules
    include Mandate
    include TreeHelpers

    initialize_with :tree, :source

    VERBS = %i[uses uses_all missing within first_of].freeze

    TYPES = %w[essential actionable informative celebratory].freeze

    # A first_of block, which holds once one of its rules holds.
    FirstOf = Struct.new(:held)

    class << self
      # Keep each rule written at the top of the class, to run on every
      # solution in order.
      VERBS.each do |verb|
        define_method(verb) { |*codes, **options, &block| rules << [verb, codes, options, block] }
      end

      def rules = @rules ||= []

      # The Spec of the language, such as Ruby::Common::Spec for
      # Ruby::Analysis::TwoFer.
      def language = Representer::Engine.language_module(self)::Common::Spec
    end

    def call
      @comments = []
      @scope = tree
      @bindings = {}
      self.class.rules.each { |verb, codes, options, block| send(verb, *codes, **options, &block) }
      @comments
    end

    private
    ### Conditions ###

    # Run the block if the scope has a match of one of the codes, or more
    # than more_than matches of them in all. A match inside another match
    # doesn't count, so an `elsif` counts as part of its `if`. The block
    # can use the first match's placeholders.
    def uses(codes, more_than: 0, &block)
      rule do
        found = matches(codes)
        outermost(found.map(&:first)).size > more_than && run(block, bindings: found.first.last)
      end
    end

    # Run the block if the scope has a match of every one of the codes. A
    # word used in two of them must match the same code in both.
    def uses_all(codes, &block)
      rule do
        bindings = codes.reduce(@bindings) { |bound, code| bound && matches(code, bound).first&.last }
        bindings && run(block, bindings:)
      end
    end

    # Run the block if the scope has no match of any of the codes.
    def missing(codes, &block)
      rule { matches(codes).empty? && run(block) }
    end

    # Run the block once for each match of the codes in the scope, with the
    # match as the scope. The rules in the block then only look inside the
    # match, and can use its placeholders.
    def within(codes, &block)
      rule do
        found = matches(codes)
        found.each { |node, bindings| run(block, scope: node, bindings:) }
        found.any?
      end
    end

    # Run only the first rule in the block whose condition holds.
    def first_of(&block)
      rule do
        outer = @first_of
        @first_of = FirstOf.new(false)
        instance_exec(&block)
        @first_of.held
      ensure
        @first_of = outer
      end
    end

    # Check the rule's condition, unless an earlier rule in the same
    # first_of held. The condition runs the rule's block if it holds.
    def rule
      return if @first_of&.held

      held = yield
      @first_of.held = true if held && @first_of
    end

    # Run the block with the scope and bindings given, outside any first_of.
    def run(block, scope: @scope, bindings: @bindings)
      outer = [@scope, @bindings, @first_of]
      @scope = scope
      @bindings = bindings
      @first_of = nil
      instance_exec(&block) if block
      true
    ensure
      @scope, @bindings, @first_of = outer
    end

    # Each node in the scope that matches one of the codes, with its
    # bindings.
    def matches(codes, bindings = @bindings)
      patterns = Array(codes).map { |code| CodePattern[self.class.language, code] }
      found = []
      @scope.each_descendant do |node|
        patterns.each do |pattern|
          next unless Representer::Engine.could_match?(pattern, node.type)

          matched = pattern.match(node, bindings)
          next unless matched

          found << [node, matched]
          break
        end
      end
      found
    end

    def outermost(nodes)
      nodes.reject { |node| nodes.any? { |other| !other.equal?(node) && inside?(node, other) } }
    end

    def inside?(node, other)
      found = false
      other.each_descendant { |descendant| found ||= descendant.equal?(node) }
      found
    end

    ### Comments ###

    # Add a comment of this type, such as `essential "ruby.leap.std_lib"`.
    # A param can name a placeholder, and then gives its code:
    # name_variable: "{{name}}"  ->  name_variable: "name"
    TYPES.each do |type|
      define_method(type) do |key, **params|
        comment = { comment: key, params: params.transform_values { |value| fill_in(value) }, type: }
        comment.delete(:params) if params.empty?
        @comments << comment unless @comments.include?(comment)
      end
    end

    def fill_in(value)
      return value unless value.is_a?(String)

      value.gsub(CodePattern::PLACEHOLDER) { Array(@bindings.fetch(CodePattern.word(Regexp.last_match))).map { |node| text_of(node) }.join(", ") }
    end

    ### Layout ###

    # Whether the main file is indented in steps of this many spaces (see
    # IndentedInSteps).
    def indented_in_steps_of?(width) = IndentedInSteps.(source, width)
  end
end
