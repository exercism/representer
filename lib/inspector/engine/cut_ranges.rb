module Inspector::Engine
  # Splits the source into lines, with the byte ranges cut out. A line that
  # a cut touches loses its trailing spaces, and comes back as nil if
  # nothing is left of it. The ranges can overlap and come in any order.
  class CutRanges
    include Mandate

    initialize_with :source, :ranges

    def call
      removals = merged
      offset = 0
      source.each_line.map do |line|
        span = offset...(offset + line.bytesize)
        offset = span.end
        removals.shift while removals.any? && removals.first.end <= span.begin
        cuts = removals.take_while { |range| range.begin < span.end }
        next line if cuts.empty?

        kept = keep(line, span, cuts)
        kept.strip.empty? ? nil : kept.rstrip + line[/\r?\n\z/].to_s
      end
    end

    private
    # Sorts the ranges and joins any that overlap.
    def merged
      ranges.sort_by(&:begin).each_with_object([]) do |range, merged|
        if merged.any? && range.begin <= merged.last.end
          merged[-1] = merged.last.begin...[merged.last.end, range.end].max
        else
          merged << range
        end
      end
    end

    def keep(line, span, cuts)
      kept = +""
      position = span.begin
      cuts.each do |range|
        kept << line.byteslice((position - span.begin)...(range.begin - span.begin)) if range.begin > position
        position = [position, range.end].max
      end
      kept << line.byteslice((position - span.begin)..) if position < span.end
      kept
    end
  end
end
