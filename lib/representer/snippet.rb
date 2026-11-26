module Representer
  # Makes the snippet that the website shows on a solution's card: the start
  # of the solution's main file, without its comments or the boilerplate at
  # its top. It doesn't affect the representation.
  #
  # - The main file is the first of the exercise's solution files (`files`
  #   `solution` in .meta/config.json) that the student submitted. If there
  #   is none, it is the student's first file.
  # - Comments are removed everywhere. Boilerplate, such as imports, is only
  #   skipped at the top of the file. Code is never removed.
  # - If a removal leaves a line empty, the line is dropped. So are blank
  #   lines at the top, and inside the code a run of blank lines becomes one.
  # - The snippet keeps the first MAX_LINES lines, and cuts each line after
  #   MAX_LINE_LENGTH characters.
  #
  # A language with its own class finds comments (its `comments` rules) and
  # boilerplate (its `snippet_header` rules) in the parse tree. Basic finds
  # comments with the track's Rouge lexer, and skips no boilerplate. Each one
  # is removed by its place in the source, so the student's formatting stays.
  #
  # If the main file can't be parsed, the snippet removes nothing, and is
  # just the file's first lines.
  class Snippet
    include Mandate

    # Bump this whenever the snippet of any solution could change, so the
    # website knows to make every snippet again.
    VERSION = 1

    MAX_LINES = 15
    MAX_LINE_LENGTH = 200

    initialize_with :track_slug, :solution_files, :exercise_files

    def call
      source = Engine.clean(solution_files.fetch(main_file))
      lines(source, merge(removals(source)))
    end

    private
    def language = Languages.for(track_slug)

    memoize
    def main_file = solution_paths.find { |path| solution_files.key?(path) } || solution_files.keys.min

    def solution_paths
      config = JSON.parse(exercise_files.fetch(".meta/config.json", "{}"))
      files = config["files"] if config.is_a?(Hash)
      paths = files["solution"] if files.is_a?(Hash)
      paths.is_a?(Array) ? paths : []
    rescue JSON::ParserError
      []
    end

    # The byte ranges to remove from the source.
    def removals(source)
      return [] if source.bytesize > MAX_SOLUTION_BYTES
      return Languages::Basic.comments(track_slug, source) if language == Languages::Basic

      tree = Engine::Grammar[language.grammar].parse(source, text_types: language.text_node_types)
      header(tree) + comments(tree)
    rescue CannotRepresent
      []
    end

    # The top-level nodes before the first code that isn't boilerplate.
    def header(tree)
      top_level = tree.children.flat_map { |node| matches?(language.container_rules, node) ? node.children : [node] }
      top_level.
        take_while { |node| matches?(language.header_rules, node) || matches?(language.comment_rules, node) }.
        map(&:bytes)
    end

    def comments(tree)
      found = []
      stack = [tree]
      until stack.empty?
        node = stack.pop
        next found << node.bytes if matches?(language.comment_rules, node)

        stack.concat(node.children)
      end
      found
    end

    def matches?(rules, node) = rules.any? { |rule| rule.match(node) }

    # Sorts the ranges and joins any that overlap.
    def merge(ranges)
      ranges.sort_by(&:begin).each_with_object([]) do |range, merged|
        if merged.any? && range.begin <= merged.last.end
          merged[-1] = merged.last.begin...[merged.last.end, range.end].max
        else
          merged << range
        end
      end
    end

    def lines(source, removals)
      lines = []
      offset = 0
      source.each_line do |line|
        span = offset...(offset + line.bytesize)
        offset = span.end
        removals.shift while removals.any? && removals.first.end <= span.begin
        cuts = removals.take_while { |cut| cut.begin < span.end }

        if cuts.any?
          kept = remove(line, span, cuts)
          lines << (kept.rstrip + line[/\r?\n\z/].to_s) unless kept.strip.empty?
        elsif line.strip.empty?
          lines << "\n" unless lines.empty? || lines.last == "\n"
        else
          lines << line
        end
        break if lines.size >= MAX_LINES
      end
      lines.pop while lines.last == "\n"
      lines.map { |line| shorten(line) }.join
    end

    # The parts of the line outside the cuts.
    def remove(line, span, cuts)
      kept = +""
      position = span.begin
      cuts.each do |cut|
        kept << line.byteslice((position - span.begin)...(cut.begin - span.begin)) if cut.begin > position
        position = [position, cut.end].max
      end
      kept << line.byteslice((position - span.begin)..) if position < span.end
      kept
    end

    # Cuts the line after MAX_LINE_LENGTH characters, keeping its line break.
    def shorten(line)
      text = line.chomp
      text.length > MAX_LINE_LENGTH ? text[0, MAX_LINE_LENGTH] + line[text.length..] : line
    end
  end
end
