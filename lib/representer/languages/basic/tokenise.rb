# Basic compares code token by token, so this command splits a file into
# lines of tokens, and drops the comments and the spaces between tokens.
# Each line comes with the width of its indentation. Lines with no code are
# left out.
#   x  =  1   -- one  ->  [0, ["x", "=", "1"]]
class Representer::Languages::Basic
  class Tokenise
    include Mandate

    initialize_with :track_slug, :source

    # Lexers whose preprocessor lines can end with a `//` comment, which the
    # lexer keeps as part of the line.
    PREPROC_LINE_COMMENTS = ["c", "cpp", "objective_c"].freeze

    def call
      lines = [[0, []]]
      glue = false # Whether the next string piece joins the previous token.

      each_token do |kind, text|
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
      lines.reject { |_, tokens| tokens.empty? }
    end

    private
    memoize
    def lexer = Representer::Languages::Basic.lexer_for(track_slug)

    # Yield each token as :string (part of a string literal), :code, or :gap
    # (whitespace or a comment). Split the code with the track's Rouge lexer,
    # or at whitespace if it has none. Keep a comment only for its line
    # breaks.
    def each_token(&block)
      return split_words(source, &block) unless lexer

      lex.each do |name, text|
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

    # Lex the source into [token name, text] pairs, and fix the literals
    # misread by the lexer. After a fix, lex the rest of the source again,
    # from just after the literal.
    def lex
      tokens = []
      position = 0
      loop do
        restart = nil
        lexer.new.lex(source[position..]).each do |token, text|
          name = token.qualname
          literal = misread_literal(tokens, name, position)
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

    # Return the literal that starts at position, if the lexer has misread it
    # as a token of this name, as [name, text, the characters of text already
    # lexed]. Remove the tokens of the characters already lexed.
    def misread_literal(tokens, name, position)
      if track_slug == "haxe" && name == "Literal.String.Regex" && source[position, 2] == "~/"
        # Rouge only marks a Haxe regex's `~/`, so its body is lexed as code,
        # and `//` in it starts a comment.
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

    # Drop the `//` comments from a preprocessor line. Keep strings and
    # characters as they are, so `"a//b"` is not a comment.
    def without_line_comments(text)
      text.gsub(%r{"(?:\\.|[^"\\\n])*"|'(?:\\.|[^'\\\n])*'|//[^\n]*}) { |piece| piece.start_with?("//") ? "" : piece }
    end

    def split_words(text)
      text.scan(/\s+|\S+/) { |piece| yield piece.match?(/\A\s/) ? :gap : :code, piece }
    end

    # Count a tab as 8 spaces.
    def width(indent) = indent.each_char.sum { |char| char == "\t" ? 8 : 1 }
  end
end
