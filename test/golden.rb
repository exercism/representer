require "json"
require "yaml"
require "rouge"
require_relative "../lib/representer"

# The golden data set in test/golden/: real published solutions for every
# track, with the representation each one gets today and the groups they were
# in on production. test/golden/README.md describes the layout.
#
# bin/regenerate-golden writes the data, and test/golden_test.rb checks it.
module Golden
  ROOT = File.expand_path("golden", __dir__)

  Solution = Struct.new(:track, :exercise, :name, keyword_init: true) do
    def dir = File.join(ROOT, track, exercise, "solutions", name)
    def id = "#{exercise}/#{name}"
    def files = Golden.read_files(File.join(dir, "solution"))
    def representation_path = File.join(dir, "representation.txt")
    def recorded_representation = File.exist?(representation_path) ? File.read(representation_path) : nil
  end

  def self.tracks = Dir.children(ROOT).select { |name| File.directory?(File.join(ROOT, name)) }.sort

  def self.solutions(track)
    Dir.glob("*/solutions/*", base: File.join(ROOT, track)).sort.map do |path|
      exercise, _, name = path.split("/")
      Solution.new(track:, exercise:, name:)
    end
  end

  # Reads every file under the folder, keyed by its path in the folder.
  def self.read_files(dir)
    Dir.glob("**/*", File::FNM_DOTMATCH, base: dir).sort.each_with_object({}) do |path, files|
      full = File.join(dir, path)
      files[path] = File.binread(full).force_encoding(Encoding::UTF_8) if File.file?(full)
    end
  end

  def self.exercise_files(track, exercise)
    @exercise_files ||= {}
    @exercise_files[[track, exercise]] ||= read_files(File.join(ROOT, track, exercise, "exercise"))
  end

  # The text of a solution's representation.txt. It sends the request that
  # the website sends, so it gets exactly the response the website gets.
  def self.representation(solution)
    body = {
      track_slug: solution.track, exercise_slug: solution.exercise,
      solution_files: solution.files, exercise_files: exercise_files(solution.track, solution.exercise)
    }
    response = JSON.parse(Representer.process(event: { "body" => body.to_json }, context: {})[:body])
    response["representation"] ? "#{response['representation']}\n" : "unrepresentable: #{response['reason']}\n"
  rescue StandardError => e
    "error: #{e.class}: #{e.message.lines.first.strip}\n"
  end

  def self.representable?(text) = !text.start_with?("unrepresentable: ", "error: ")

  # The production groups, from groups.yml: for each exercise, the
  # solutions in each production representation.
  def self.production_groups(track)
    YAML.safe_load_file(File.join(ROOT, track, "groups.yml")).transform_values do |groups|
      groups.values.map { |names| names.map(&:to_s).sort }
    end
  end

  # Compares the groups that the representations make now with the
  # production groups, and returns every difference:
  #
  # - split: a production group whose solutions now get different
  #   representations. `solutions` lists the new groups.
  # - merge: solutions from different production groups that now get the same
  #   representation. `solutions` lists them by production group.
  # - unrepresentable: a solution that now gets no representation (or raises
  #   an error), so it is in no group at all.
  #
  # `texts` maps each solution's id ("exercise/name") to its representation
  # text.
  def self.differences(track, texts)
    production_groups(track).sort.flat_map do |exercise, groups|
      text = ->(name) { texts.fetch("#{exercise}/#{name}") }
      broken = groups.flatten.reject { |name| representable?(text.(name)) }
      old_group = groups.each_with_index.flat_map { |names, index| names.map { |name| [name, index] } }.to_h
      live = groups.flatten - broken

      splits = groups.filter_map do |names|
        parts = (names - broken).group_by(&text).values
        { "kind" => "split", "solutions" => sort_parts(parts) } if parts.size > 1
      end
      merges = live.group_by(&text).values.filter_map do |names|
        parts = names.group_by(&old_group).values
        { "kind" => "merge", "solutions" => sort_parts(parts) } if parts.size > 1
      end
      unrepresentable = broken.sort.map do |name|
        { "kind" => "unrepresentable", "solutions" => [[name]], "reason" => text.(name).strip }
      end

      (splits + merges + unrepresentable).map { |difference| { "exercise" => exercise }.merge(difference) }
    end
  end

  def self.sort_parts(parts) = parts.map(&:sort).sort_by { |names| [-names.size, names] }

  # The identity of a difference, which stays the same while the same
  # solutions differ in the same way.
  def self.key(difference) = difference.values_at("exercise", "kind", "solutions")

  def self.differences_path(track) = File.join(ROOT, track, "differences.yml")

  def self.recorded_differences(track)
    path = differences_path(track)
    File.exist?(path) ? Array(YAML.safe_load_file(path)) : []
  end

  # Writes every solution's representation.txt and the track's
  # differences.yml. A difference already recorded keeps its status and
  # note. A new one is marked undecided, with a note that says where the
  # solutions differ.
  def self.regenerate(track)
    solutions = solutions(track)
    texts = solutions.to_h do |solution|
      text = representation(solution)
      File.write(solution.representation_path, text) unless solution.recorded_representation == text
      [solution.id, text]
    end
    write_differences(track, differences(track, texts), texts)
    texts
  end

  def self.write_differences(track, differences, texts)
    recorded = recorded_differences(track).to_h { |difference| [key(difference), difference] }
    differences = differences.map do |difference|
      old = recorded[key(difference)]
      difference.merge(
        "status" => old ? old["status"] : "undecided",
        "note" => old ? old["note"] : Notes.(track, difference, texts)
      )
    end
    File.write(differences_path(track), DIFFERENCES_HEADER + format_differences(differences))
  end

  DIFFERENCES_HEADER = <<~YAML.freeze
    # How the groups that the representer makes today differ from the groups
    # these solutions were in on production (groups.yml). test/golden_test.rb
    # fails on any difference that isn't listed here, and on any listed
    # difference that no longer happens. bin/regenerate-golden rewrites this
    # file, and keeps each difference's status and note.
    #
    # - split: a production group whose solutions now get different
    #   representations. The solutions are listed by their new group.
    # - merge: solutions from different production groups that now get the
    #   same representation. The solutions are listed by production group.
    # - unrepresentable: a solution that now gets no representation.
    #
    # status is undecided until iHiD decides whether the difference is right
    # (accepted) or a bug to fix (rejected).
  YAML

  def self.format_differences(differences)
    return "[]\n" if differences.empty?

    entries = differences.map do |difference|
      lines = ["- exercise: #{difference['exercise']}", "  kind: #{difference['kind']}", "  solutions:"]
      difference["solutions"].each { |names| lines << "    - [#{names.map { |name| yaml_name(name) }.join(', ')}]" }
      lines << "  reason: #{difference['reason'].to_json}" if difference["reason"]
      lines << "  status: #{difference['status']}"
      lines << "  note: #{difference['note'].to_json}"
      lines.join("\n")
    end
    "#{entries.join("\n")}\n"
  end

  # A solution's folder name as YAML, quoted if YAML would otherwise read it
  # as something other than a string (such as the number 123).
  def self.yaml_name(name) = YAML.safe_load("[#{name}]") == [name] ? name : name.dump

  # Writes a short note on where the solutions in a new difference differ,
  # as a starting point for deciding on it.
  module Notes
    def self.call(track, difference, texts)
      case difference["kind"]
      when "split" then split(track, difference, texts)
      when "merge" then merge(track, difference)
      else "The representer gives this solution no representation (#{difference['reason']})."
      end
    end

    # A production group that now splits. The old representer treated the
    # solutions as the same, so the note shows the first line where the new
    # representations differ.
    def self.split(track, difference, texts)
      first, second = difference["solutions"].first(2).map { |names| texts.fetch("#{difference['exercise']}/#{names.first}") }
      a, b = first_difference(first.lines, second.lines)
      if [a, b].all? { |line| line.to_s.start_with?("(file ") }
        cause = "The solutions' files have different names."
      elsif Representer::Languages.for(track) == Representer::Languages::Basic
        cause = basic_split_cause(a, b)
      else
        cause = split_cause(track, difference["exercise"], first, second)
      end
      [cause, "The representations first differ at #{quote(a)} and #{quote(b)}."].compact.join(" ")
    end

    TOKEN = /"(?:\\.|[^"\\])*"|[()]|[^\s()]+/
    PLACEHOLDER = /\APLACEHOLDER_\d+\z/
    NUMBER = /\A[-+]?\.?\d[\w.]*\z/

    # Looks at the first token where the representations differ, for the
    # common causes: a name that one solution keeps and the other renames,
    # placeholders numbered differently, or numbers written differently.
    def self.split_cause(track, exercise, first, second)
      a, b = first_difference(first.scan(TOKEN), second.scan(TOKEN))
      return nil unless a && b

      if [a, b].all?(PLACEHOLDER)
        "The placeholders are numbered differently (#{quote(a)} and #{quote(b)})."
      elsif [a, b].one?(PLACEHOLDER)
        name = [a, b].grep_v(PLACEHOLDER).first
        return nil unless name.match?(/\A[[:alpha:]_$@][[:alnum:]_$@?!-]*\z/)

        word = /(?<![[:alnum:]_])#{Regexp.escape(name)}(?![[:alnum:]_])/
        used = Golden.exercise_files(track, exercise).values.any? { |source| source.match?(word) }
        reason = used ? " because the exercise's files use the name" : ""
        "One solution keeps the name #{quote(name)}#{reason}, and the other renames it."
      elsif [a, b].all?(NUMBER)
        "The solutions write numbers differently (#{quote(a)} and #{quote(b)})."
      end
    end

    # Basic used to delete all whitespace and keep comments. Today it keeps
    # line breaks, indentation (in some languages) and the spaces between
    # tokens.
    def self.basic_split_cause(line_a, line_b)
      if line_a.to_s.strip == line_b.to_s.strip
        "The solutions differ in indentation."
      elsif line_a.to_s.gsub(/\s/, "") == line_b.to_s.gsub(/\s/, "")
        "The solutions differ in the spaces between tokens or inside strings."
      else
        "The solutions differ in line breaks."
      end
    end

    # Solutions from different production groups that now get the same
    # representation. The note says whether their code only differs in
    # comments or formatting, and otherwise shows the first line where it
    # differs.
    def self.merge(track, difference)
      first, second = difference["solutions"].first(2).map do |names|
        Solution.new(track:, exercise: difference["exercise"], name: names.first).files
      end
      return "The solutions have the same files." if first == second

      squash = ->(files) { files.transform_values { |source| source.gsub(/\s/, "") } }
      return "The solutions differ only in whitespace." if squash.(first) == squash.(second)

      decommented = [first, second].map { |files| files.transform_values { |source| strip_comments(track, source) } }
      return "The solutions differ only in comments and whitespace." if decommented.map(&squash).uniq.size == 1

      a, b = first_difference(*[first, second].map { |files| files.values.join("\n").lines.map(&:strip).reject(&:empty?) })
      "The code first differs at #{quote(a)} and #{quote(b)}."
    end

    def self.strip_comments(track, source)
      lexer = Rouge::Lexer.find(Representer::Languages::Basic::LEXERS.fetch(track, track))
      return source unless lexer

      lexer.new.lex(source).reject { |token, _| token.qualname.start_with?("Comment") }.map(&:last).join
    rescue StandardError
      source
    end

    def self.first_difference(lines_a, lines_b)
      index = (0...[lines_a.size, lines_b.size].max).find { |i| lines_a[i] != lines_b[i] }
      [lines_a[index], lines_b[index]]
    end

    def self.quote(line)
      return "the end" if line.nil?

      text = line.strip
      text = "#{text[0, 77]}..." if text.size > 80
      "`#{text}`"
    end
  end
end
