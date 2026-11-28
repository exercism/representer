module Inspector::Engine
  # The website shows the start of each solution on its card. Each track's
  # snippet is a class called Spec in a module called Snippet, such as
  # Ruby::Snippet::Spec. It subclasses this one, and lists what to leave
  # out of the snippet (docs/snippets.md describes every declaration):
  #
  #   module Inspector::Languages::Ruby::Snippet
  #     class Spec < Inspector::Engine::Snippet
  #       remove :comments
  #       skip_at_top :require, :require_relative
  #     end
  #   end
  #
  # A language keeps its snippet in its folder (`languages/ruby/snippet/
  # spec.rb`), and the engine loads it like a stage. A track with no
  # language of its own can have a folder holding only `snippet/spec.rb`. A
  # track with no snippet of its own gets Languages::Basic::Snippet::Spec.
  #
  # The engine runs the snippet on the solution's main file (see
  # FindMainFile), with the tree from the language's grammar, before any
  # stage changes it. With a tree, FindRemovedNodes and
  # FindSkippedStatements find the code to leave out. If the track has no
  # grammar or the file doesn't parse, the rules apply to lines instead:
  # FindComments finds the comments, and SkipLines skips the lines at the
  # top and the bottom.
  #
  # Each removal cuts the bytes out of the original source (see CutRanges),
  # so the student's formatting stays. Then TidyLines drops the lines left
  # empty, and the snippet keeps the first MAX_LINES lines and cuts each
  # one after MAX_LINE_LENGTH characters. If the main file is over
  # MAX_SOLUTION_BYTES, the snippet is its first MAX_LINES lines.
  class Snippet
    include Mandate

    MAX_LINES = 15
    MAX_LINE_LENGTH = 200

    REMOVABLE = %i[comments docstrings].freeze

    extend InheritDeclarations
    declarations_in :@version, :@lines_only, :@removed, :@container_types, :@skipped_words, :@skipped_blocks,
                    :@skipped_bottom_words, :@removed_line_words, :@line_comment_markers, :@block_comment_markers

    initialize_with :track_slug, :source, :tree

    class << self
      # The snippet's version. Bump it whenever the track's snippet of any
      # solution could change, so the website knows to make them again.
      def version(number = nil) = number ? @version = number : @version || 1

      # Things to remove wherever they are: :comments, and :docstrings for a
      # language that declares docstrings_are. The language declares both in
      # its Spec.
      def remove(*things)
        unknown = things - REMOVABLE
        raise ArgumentError, "A snippet can't remove #{unknown.map(&:inspect).join(', ')}" if unknown.any?

        removed.concat(things)
      end

      # Node types that hold the rest of the file after a header line, such
      # as F#'s `module Leap`. If skip_at_top skips one, it skips only the
      # header (and its closing bracket, if it has one), and goes on with
      # the statements inside.
      def containers(*types) = container_types.concat(types.map(&:to_s))

      # Words that start the statements to skip at the top of the file, such
      # as :require or "#include". For a snippet with no grammar, a pair skips
      # a block of lines: from a line that starts with the first word to the
      # next line that holds the second (such as ABAP's
      # "CLASS" => "IMPLEMENTATION.").
      def skip_at_top(*words, **blocks)
        raise ArgumentError, "Only lines can be skipped as a block" if blocks.any? && language

        skipped_words.concat(words.map(&:to_s))
        skipped_blocks.merge!(blocks.transform_keys(&:to_s))
      end

      # For a snippet with no grammar: words that start lines to skip at the
      # bottom of the file, such as Lean's `end`.
      def skip_at_bottom(*words)
        raise ArgumentError, "Only lines can be skipped at the bottom" if language

        skipped_bottom_words.concat(words.map(&:to_s))
      end

      # For a snippet with no grammar: words that start lines to remove
      # wherever they are, such as MIPS's `.data`.
      def remove_lines(*words)
        raise ArgumentError, "Only lines can be removed by the words that start them" if language

        removed_line_words.concat(words.map(&:to_s))
      end

      # How the track's comments start, for a file that the track's Rouge
      # lexer can't read (see FindComments). A string is a line comment
      # (such as "//"), and a pair is a block comment's start and end (such
      # as "/*" => "*/").
      def comment_lines(*lines, **blocks)
        line_comment_markers.concat(lines)
        block_comment_markers.merge!(blocks.transform_keys(&:to_s))
      end

      # Applies the rules to lines, even though the language has a grammar,
      # for a grammar with no useful tree for the code at the top of a file.
      # Call it before the other rules.
      def lines_only = @lines_only = true

      # For a track with no language of its own: the track slugs that use
      # this snippet.
      def tracks(*slugs) = slugs.each { |slug| Inspector::Languages.register_snippet(slug, self) }

      def removes?(node, parent)
        (removed.include?(:comments) && comment?(node)) || (removed.include?(:docstrings) && docstring?(node, parent))
      end

      # A comment is any node with "comment" in its type, or a type listed
      # in the Spec's comments_are.
      def comment?(node) = node.type.include?("comment") || language.comment_types.include?(node.type)

      # A docstring is code listed in the Spec's docstrings_are. A snippet
      # can define this method itself, for docstrings that a code pattern
      # can't describe (as Python's does). It receives the node and its
      # parent.
      def docstring?(node, _parent) = language.docstring?(node)

      def container?(node) = container_types.include?(node.type)

      # The language whose grammar parses the solution: the Common::Spec
      # beside the snippet. It is nil for a track with no language of its
      # own, and for a snippet that works on lines only.
      def language
        return nil if @lines_only

        owner = Object.const_get(name.delete_suffix("::Snippet::Spec"))
        Inspector::Engine.language_module?(owner) ? owner::Common::Spec : nil
      end

      # Matches text that starts with one of the words, in any case (Common
      # Lisp's `(DEFPACKAGE` is `(defpackage`). If a word ends in a letter,
      # digit or underscore, it must end there, so :require doesn't match
      # `require_relative`. Returns nil if there are no words.
      def starts_with(words)
        return nil if words.empty?

        alternatives = words.map { |word| word.match?(/\w\z/) ? "#{Regexp.escape(word)}(?!\\w)" : Regexp.escape(word) }
        /\A(?:#{alternatives.join('|')})/i
      end

      def starts_with_skipped_word?(text) = (@skip_pattern ||= [starts_with(skipped_words)]).first&.match?(text)

      def removed = @removed ||= []
      def container_types = @container_types ||= []
      def skipped_words = @skipped_words ||= []
      def skipped_blocks = @skipped_blocks ||= {}
      def skipped_bottom_words = @skipped_bottom_words ||= []
      def removed_line_words = @removed_line_words ||= []
      def line_comment_markers = @line_comment_markers ||= []
      def block_comment_markers = @block_comment_markers ||= {}
    end

    def call
      return finish(source.each_line.first(MAX_LINES)) if source.bytesize > Inspector::MAX_SOLUTION_BYTES

      # If skipping leaves nothing, such as a file that only holds an empty
      # namespace, keep the containers. If that leaves nothing too, skip
      # nothing.
      lines = %i[all not_containers none].lazy.map { |skip| TidyLines.(tree ? from_tree(skip) : from_lines(skip)) }
      finish(lines.find(&:any?) || [])
    end

    private
    def rules = self.class

    def from_tree(skip)
      skipped = skip == :none ? [] : FindSkippedStatements.(rules, tree, source, containers: skip == :all)
      CutRanges.(source, skipped + FindRemovedNodes.(rules, tree))
    end

    def from_lines(skip)
      comments = rules.removed.include?(:comments) ? FindComments.(rules, track_slug, source) : []
      lines = remove_lines(CutRanges.(source, comments))
      skip == :none ? lines : SkipLines.(rules, lines)
    end

    # Removes the lines that start with one of the words given to
    # remove_lines.
    def remove_lines(lines)
      pattern = rules.starts_with(rules.removed_line_words)
      return lines unless pattern

      lines.map { |line| line unless line&.lstrip&.match?(pattern) }
    end

    # Keeps the first lines, and cuts each one after MAX_LINE_LENGTH
    # characters, keeping its line break.
    def finish(lines)
      lines = lines.first(MAX_LINES)
      lines.pop while lines.last&.strip&.empty?
      lines.map do |line|
        text = line.chomp
        text.length > MAX_LINE_LENGTH ? text[0, MAX_LINE_LENGTH] + line[text.length..] : line
      end.join
    end
  end
end
