require "rouge"

module Representer
  module Languages
    # The representer for every track with no class of its own, and for any
    # solution that its language's parser can't read.
    #
    # It removes comments and formatting, and changes nothing else, so two
    # solutions only get the same representation if they differ in nothing
    # but comments and formatting:
    #
    # - It splits the code into tokens with the track's Rouge lexer, and drops
    #   the comments. A track with no lexer keeps its comments, and its code
    #   is split at whitespace.
    # - It keeps every string exactly as written, including its whitespace.
    # - It writes each line of code as its tokens with single spaces between
    #   them, and drops blank lines. Line breaks stay, because they can change
    #   the meaning (`return\nx` in JavaScript, for example).
    # - In indentation-sensitive languages, it also keeps each line's
    #   indentation depth (but not its width, so 2 and 4 spaces are the same).
    # - It renames nothing.
    #
    # A token is written as it is, or in double quotes (with escapes) if it
    # holds whitespace or starts with a double quote. So the output can only be
    # read back one way, and different code can't produce the same output.
    class Basic
      include Mandate

      # The version for tracks with no class of their own. Bump it whenever
      # the output for any solution changes. Versions start at 2, because the
      # website's old basic representer reported 0.
      VERSION = 3

      # Tracks whose slug is not the name of their Rouge lexer. Only map a
      # track to a lexer that knows its comment and string syntax exactly:
      # a lexer that mistakes code for a comment would drop that code.
      LEXERS = {
        "cfml" => "cfscript",
        "delphi" => "pascal",
        "free-pascal" => "pascal",
        "lfe" => "common_lisp",
        "perl5" => "perl",
        "pharo-smalltalk" => "smalltalk",
        "purescript" => "haskell",
        "sqlite" => "sql",
        "unison" => "haskell",
        "vbnet" => "vb",
        "x86-64-assembly" => "nasm"
      }.freeze

      # Tracks where indentation is part of the syntax.
      INDENTATION_SENSITIVE = %w[
        cobol coffeescript elm fsharp gdscript haskell idris lean moonscript nim
        purescript python roc scala unison yamlscript
      ].to_set.freeze

      PLAIN = /\A[^\s"]\S*\z/

      initialize_with :track_slug, :solution_files

      def call
        representation = solution_files.sort.map { |filename, source| represent(filename, Engine.clean(source)) }.join("\n")
        Engine::Result.new(representation:, mapping: {}, version: VERSION, representer: self.class)
      end

      def self.version = VERSION

      private
      def represent(filename, source)
        lines = ["(file #{filename.dump})"]
        indentation = [0]
        line_tokens(source).each do |indent, tokens|
          next if tokens.empty?

          depth = INDENTATION_SENSITIVE.include?(track_slug) ? depth(indentation, indent) : 0
          lines << (("  " * depth) + tokens.map { |token| token.match?(PLAIN) ? token : token.dump }.join(" "))
        end
        lines.join("\n")
      end

      # Splits the source into lines of tokens. Each line comes with the width
      # of its indentation.
      def line_tokens(source)
        lines = [[0, []]]
        glue = false # Whether the next string piece joins the previous token.

        each_token(source) do |kind, text|
          case kind
          when :string
            glue ? lines.last.last.last << text : lines.last.last << text.dup
            glue = true
          when :code
            lines.last.last << text
            glue = false
          when :gap
            glue = false
            next unless text.include?("\n")

            lines << [width(text[/[^\n]*\z/]), []]
          end
        end
        lines
      end

      # Yields each token as :string (part of a string literal), :code, or
      # :gap (whitespace or a comment). Comments only count for their line
      # breaks.
      def each_token(source, &block)
        lexer = Rouge::Lexer.find(LEXERS.fetch(track_slug, track_slug))
        return split_words(source, &block) unless lexer

        tokens = lexer.new.lex(source).to_a
        tokens.each do |token, text|
          name = token.qualname
          if name.start_with?("Literal.String")
            yield :string, text
          elsif name.start_with?("Comment") && !name.start_with?("Comment.Preproc")
            yield :gap, text.include?("\n") ? "\n" : " "
          else
            split_words(text, &block)
          end
        end
      rescue StandardError
        # A lexer that fails on unusual code leaves the code split at
        # whitespace instead.
        split_words(source, &block)
      end

      def split_words(text)
        text.scan(/\s+|\S+/) { |piece| yield piece.match?(/\A\s/) ? :gap : :code, piece }
      end

      def width(indent) = indent.each_char.sum { |char| char == "\t" ? 8 : 1 }

      # Turns an indentation width into a depth, as Python does: deeper than
      # the line above opens a level, and shallower closes levels until the
      # width matches.
      def depth(stack, width)
        stack.pop while stack.size > 1 && width < stack.last
        stack << width if width > stack.last
        stack.size - 1
      end
    end
  end
end
