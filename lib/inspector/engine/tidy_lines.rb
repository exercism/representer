module Inspector::Engine
  # Tidies a snippet's lines after the cuts. It drops the nil lines (left
  # empty by a cut) and the blank lines at the top, and turns each run of
  # blank lines into one.
  class TidyLines
    include Mandate

    initialize_with :lines

    def call
      kept = []
      lines.each do |line|
        next if line.nil?

        if line.strip.empty?
          kept << "\n" unless kept.empty? || kept.last == "\n"
        else
          kept << line
        end
      end
      kept
    end
  end
end
