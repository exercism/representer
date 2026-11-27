module Representer::Engine
  # Finds the comments in a file with no tree, and returns their byte ranges
  # in the source. It uses the track's Rouge lexer if it has one. Otherwise
  # it uses the markers given to the snippet's comment_lines, and if there
  # are none, it finds nothing.
  #
  # With markers, a block comment must start its line. A line comment may
  # also follow code after a space, unless it might be inside a string.
  class FindComments
    include Mandate

    initialize_with :rules, :track_slug, :source

    def call
      lexer = Rouge::Lexer.find(Representer::Languages::Basic::LEXERS.fetch(track_slug, track_slug))
      lexer ? lexed(lexer) : marked
    end

    private
    # Treat preprocessor lines (such as C's #include) as code.
    def lexed(lexer)
      offset = 0
      lexer.new.lex(source).filter_map do |token, text|
        range = offset...(offset + text.bytesize)
        offset = range.end
        range if token.qualname.start_with?("Comment") && !token.qualname.start_with?("Comment.Preproc")
      end
    rescue StandardError
      # A lexer that fails on unusual code removes nothing.
      []
    end

    def marked
      ranges = []
      offset = 0
      block_end = nil
      source.each_line do |line|
        span = offset...(offset + line.bytesize)
        offset = span.end
        text = line.lstrip
        block = rules.block_comment_markers.find { |start, _| text.start_with?(start) }
        if block_end
          ranges << span
          block_end = nil if text.include?(block_end)
        elsif block
          ranges << span
          block_end = block.last unless text.delete_prefix(block.first).include?(block.last)
        elsif rules.line_comment_markers.any? { |marker| text.start_with?(marker) }
          ranges << span
        elsif (start = trailing_comment(line))
          ranges << ((span.begin + line[0, start].bytesize)...span.end)
        end
      end
      ranges
    end

    # Where a line comment starts after some code, or nil. The marker must
    # follow a space, after an even number of each kind of quote mark, so it
    # isn't inside a string.
    def trailing_comment(line)
      markers = Regexp.union(rules.line_comment_markers.map { |marker| " #{marker}" })
      line.to_enum(:scan, markers).each do
        space = Regexp.last_match.begin(0)
        return space + 1 if %w[" ' `].all? { |quote| line[0, space].count(quote).even? }
      end
      nil
    end
  end
end
