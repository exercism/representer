module Representer::Engine
  # Skips the lines at the top of a file with no tree that start with one of
  # a snippet's skip_at_top words, and the lines at the bottom that start
  # with one of its skip_at_bottom words. Blank lines and nil lines (left
  # empty by a removal) between them go too.
  #
  # A skipped line at the top goes on through the lines after it that are
  # indented or start with a closing bracket, even past blank lines, such as
  # the names in a multi-line import. A block (see Snippet.skip_at_top) goes
  # on to the line that holds its end.
  class SkipLines
    include Mandate

    initialize_with :rules, :lines

    # The start of a line that continues a skipped line at the top.
    CONTINUATION = /\A[ \t]+\S|\A[)\]}]/

    def call = skip_bottom(lines.drop(top_count))

    private
    def top_count
      skipping = 0
      header = false
      block_end = nil
      lines.each do |line|
        if line.nil? || line.strip.empty?
          skipping += 1
        elsif block_end
          block_end = nil if line.downcase.include?(block_end.downcase)
          skipping += 1
        elsif (block = rules.skipped_blocks.find { |start, _| rules.starts_with([start]).match?(line.lstrip) })
          block_end = block.last unless line.downcase.include?(block.last.downcase)
          header = false
          skipping += 1
        elsif rules.starts_with_skipped_word?(line.lstrip) || (header && line.match?(CONTINUATION))
          header = true
          skipping += 1
        else
          break
        end
      end
      skipping
    end

    def skip_bottom(lines)
      pattern = rules.starts_with(rules.skipped_bottom_words)
      return lines unless pattern

      lines = lines.dup
      lines.pop while lines.any? && (lines.last.nil? || lines.last.strip.empty? || lines.last.match?(pattern))
      lines
    end
  end
end
