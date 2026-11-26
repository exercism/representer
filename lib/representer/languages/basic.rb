# What Basic does to the code of a track with no class of its own:
#
# - Splits the code into tokens with the track's Rouge lexer, or at
#   whitespace if the track has no lexer.
# - Drops comments, blank lines and the spaces between tokens, and keeps
#   every string as written.
# - Keeps line breaks, and keeps each line's indentation depth in
#   indentation-sensitive tracks.
# - Drops lines that are whole imports in tracks where an import is always
#   one line (such as Kotlin's `import`, OCaml's `open` and C's `#include`).
# - Drops a Haskell, PureScript or Idris import together with the more
#   indented lines that continue it.
# - Drops Erlang's `-export`, `-import` and `-include` attributes and
#   Prolog's `:- use_module` and `:- module` directives, up to the `.` that
#   ends them.
# - Drops the export list from a one-line Haskell or PureScript `module X
#   (a, b) where`.
# - Renames nothing.
# - Ignores files that aren't source files, and test and config files.
# - Writes the files one after another, sorted by their representations.
#   File names never appear.
#
# Update this list whenever the class's rules change.

require "rouge"

module Representer
  module Languages
    # The representer for every track with no class of its own. A solution
    # that its language's class can't parse gets no representation, and
    # never falls back to Basic.
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
    # - It writes no file names, and puts the files in the order of their
    #   representations.
    #
    # A token is written as it is, or in double quotes (with escapes) if it
    # holds whitespace or starts with a double quote. So the output can only be
    # read back one way, and different code can't produce the same output.
    class Basic
      include Mandate

      # The version for tracks with no class of their own. Bump it whenever
      # the output for any solution changes. Versions start at 2, because the
      # website's old basic representer reported 0.
      VERSION = 5

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

      # Statements that only make names available, by track: the first
      # word of the line that each one is on. Only tracks whose imports are
      # always one line long are listed, so a line that starts with the word
      # is always a whole import. In Haskell, PureScript and Idris an import
      # can go on over the lines below it, which are indented more.
      IMPORT_WORDS = {
        "c" => %w[#include], "d" => %w[import], "dart" => %w[import], "fortran" => %w[use USE], "groovy" => %w[import],
        "haskell" => %w[import], "idris" => %w[import], "julia" => %w[import using], "kotlin" => %w[import],
        "lean" => %w[import open], "ocaml" => %w[open], "odin" => %w[import], "purescript" => %w[import],
        "r" => %w[library], "reasonml" => %w[open], "scala" => %w[import], "sml" => %w[open], "swift" => %w[import],
        "vbnet" => %w[Imports], "vlang" => %w[import]
      }.freeze
      CONTINUED_BY_INDENTATION = %w[haskell idris purescript].to_set.freeze

      # Imports and export lists that are written as attributes or
      # directives, which end with a "." and can go on over several lines:
      # Erlang's `-export([...]).` and Prolog's `:- use_module(...).`. Each
      # starts with these two tokens.
      DIRECTIVES = {
        "erlang" => [%w[- export], %w[- export_type], %w[- import], %w[- include], %w[- include_lib]],
        "prolog" => [%w[:- use_module], %w[:- ensure_loaded], %w[:- module]]
      }.freeze

      # Tracks whose module line can list what the module exports, as in
      # `module Foo (bar, baz) where`.
      EXPORT_LISTS = %w[haskell purescript].to_set.freeze

      initialize_with :track_slug, :solution_files

      # The source files' extensions, for tracks whose Rouge lexer doesn't
      # list them or that have no lexer. Other tracks use the file names that
      # their lexer lists.
      EXTENSIONS = {
        "8th" => %w[.8th], "arm64-assembly" => %w[.s], "arturo" => %w[.art], "awk" => %w[.awk .sh],
        "ballerina" => %w[.bal], "cairo" => %w[.cairo], "euphoria" => %w[.ex .e], "futhark" => %w[.fut],
        "jq" => %w[.jq], "lfe" => %w[.lfe], "mips" => %w[.mips .asm .s], "odin" => %w[.odin], "purescript" => %w[.purs],
        "pyret" => %w[.arr], "red" => %w[.red], "roc" => %w[.roc], "uiua" => %w[.ua], "unison" => %w[.u],
        "vlang" => %w[.v], "yamlscript" => %w[.ys]
      }.freeze

      # For a track that has neither, every file is code except these.
      NOT_SOURCE = %w[.md .txt .json .yaml .yml .toml .lock .out].freeze

      # The files are written one after another, in the order of their
      # representations, so their names and order never matter. Files that
      # aren't code, such as Haskell's package.yaml, are left out.
      def call
        sources = solution_files.select { |filename, _| source_file?(filename) }
        raise CannotRepresent.new("no_source_files", "No solution file is a #{track_slug} source file") if sources.empty?

        representation = sources.values.map { |source| represent(Engine.clean(source)) }.reject(&:empty?).sort.join("\n")
        Engine::Result.new(representation:, mapping: {}, version: VERSION, representer: self.class)
      end

      def self.version = VERSION

      private
      def source_file?(filename)
        return false if Engine.test_or_config_file?(filename)

        name = File.basename(filename)
        return EXTENSIONS[track_slug].any? { |extension| name.end_with?(extension) } if EXTENSIONS.key?(track_slug)
        return lexer.filenames.any? { |glob| File.fnmatch(glob, name) } if lexer

        NOT_SOURCE.none? { |extension| name.downcase.end_with?(extension) }
      end

      memoize
      def lexer = Rouge::Lexer.find(LEXERS.fetch(track_slug, track_slug))

      def represent(source)
        lines = []
        indentation = [0]
        without_imports(line_tokens(source)).each do |indent, tokens|
          next if tokens.empty?

          depth = INDENTATION_SENSITIVE.include?(track_slug) ? depth(indentation, indent) : 0
          lines << (("  " * depth) + tokens.map { |token| token.match?(PLAIN) ? token : token.dump }.join(" "))
        end
        lines.join("\n")
      end

      # The lines, without the imports and export lists listed above.
      def without_imports(lines)
        lines = lines.reject { |_, tokens| tokens.empty? }
        kept = []
        index = 0
        while index < lines.size
          indent, tokens = lines[index]
          if IMPORT_WORDS.fetch(track_slug, []).include?(tokens.first)
            index += 1
            index += 1 while CONTINUED_BY_INDENTATION.include?(track_slug) && index < lines.size && lines[index][0] > indent
          elsif DIRECTIVES.fetch(track_slug, []).include?(tokens.first(2))
            index += 1 until index >= lines.size || lines[index][1].last.end_with?(".")
            index += 1
          else
            kept << (EXPORT_LISTS.include?(track_slug) ? [indent, without_export_list(tokens)] : [indent, tokens])
            index += 1
          end
        end
        kept
      end

      # `module Foo (bar, baz) where` is `module Foo where`, if it is on one
      # line.
      def without_export_list(tokens)
        return tokens unless tokens.first == "module" && tokens.last == "where" && tokens[2] == "("
        return tokens unless tokens[-2] == ")"

        tokens.first(2) + ["where"]
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
        return split_words(source, &block) unless lexer

        lex(lexer, source).each do |name, text|
          if name.start_with?("Literal.String")
            yield :string, text
          elsif name.start_with?("Comment") && !name.start_with?("Comment.Preproc")
            yield :gap, text.include?("\n") ? "\n" : " "
          elsif name == "Comment.Preproc" && PREPROC_LINE_COMMENTS.include?(lexer.tag)
            split_words(without_line_comments(text), &block)
          else
            split_words(text, &block)
          end
        end
      rescue StandardError
        # A lexer that fails on unusual code leaves the code split at
        # whitespace instead.
        split_words(source, &block)
      end

      # Character literals that a track's Rouge lexer misreads as the start
      # of a comment or a string: Emacs Lisp's `?;` and `?"`, and Scheme's
      # `#\;`. Without this, the lexer would drop the rest of the line as a
      # comment.
      CHARACTER_PREFIXES = { "emacs-lisp" => "?", "scheme" => "#\\" }.freeze

      # Lexes the source into [token name, text] pairs, and fixes the
      # literals that the lexer misreads. After a fix, it lexes the rest of
      # the source again, from just after the literal.
      def lex(lexer, source)
        tokens = []
        position = 0
        loop do
          restart = nil
          lexer.new.lex(source[position..]).each do |token, text|
            name = token.qualname
            literal = misread_literal(tokens, name, source, position)
            if literal
              literal_name, literal_text, lexed = literal
              tokens << [literal_name, literal_text]
              restart = position + literal_text.size - lexed
              break
            end

            tokens << [name, text]
            position += text.size
          end
          return tokens unless restart

          position = restart
        end
      end

      # The literal that starts at position, if the lexer has misread it as
      # a token of this name. Returns [name, text, the characters of text
      # already lexed], after removing those characters' tokens.
      def misread_literal(tokens, name, source, position)
        if track_slug == "haxe" && name == "Literal.String.Regex" && source[position, 2] == "~/"
          # Rouge only marks a Haxe regex's `~/`, so its body is lexed as
          # code, and `//` in it starts a comment.
          regex = source[position..][%r{\A~/(?:\\.|[^\\/\n])*/[gimsu]*}]
          return regex && ["Literal.String.Regex", regex, 0]
        end

        prefix = CHARACTER_PREFIXES[track_slug]
        return nil unless prefix && name.start_with?("Comment", "Literal.String")

        count = (1..prefix.size).find { |size| tokens.last(size).map(&:last).join == prefix }
        return nil unless count && source[position]

        tokens.pop(count)
        ["Literal.String.Char", prefix + source[position], prefix.size]
      end

      # Lexers whose preprocessor lines can end with a `//` comment, which
      # the lexer keeps as part of the line.
      PREPROC_LINE_COMMENTS = %w[c cpp objective_c].freeze

      # The text without its `//` comments. Strings and characters stay as
      # they are, so `"a//b"` is not a comment.
      def without_line_comments(text)
        text.gsub(%r{"(?:\\.|[^"\\\n])*"|'(?:\\.|[^'\\\n])*'|//[^\n]*}) { |piece| piece.start_with?("//") ? "" : piece }
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
