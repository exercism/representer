module Representer
  # Generates the outputs asked for, for one solution. The outputs are
  # :representation, :snippet and :analysis, and the result has one key for
  # each output asked for:
  #
  #   Generate.("ruby", { "two_fer.rb" => "..." }, outputs: %i[representation analysis])
  #   # => { representation: { representation: "...", mapping: {...}, version: 12 },
  #   #      analysis: { comments: [{ comment: "ruby.two-fer.string_format", ... }], version: 1 } }
  #
  # Each output has its own version, so a change to one output never makes
  # the website generate the others again.
  #
  # The snippet works on the main file's tree from the grammar, before any
  # stage changes it. The representation then starts from the same tree, so
  # the engine parses each file only once.
  #
  # If an output can't be generated, its key holds an error with a reason
  # (error) and a message. The other outputs still come back. A solution that
  # can't be represented gets an error with one of the reasons listed in
  # docs/representation.md, and the language's version. An analysis whose main file doesn't parse
  # gets an error with the analysis's version. An output that the track
  # doesn't support yet gets the error "not_supported", and a bug in the
  # snippet's or the analysis's rules gets "internal_error".
  class Generate
    include Mandate

    OUTPUTS = %i[representation snippet analysis].freeze

    initialize_with :track_slug, :solution_files, outputs: Mandate::NO_DEFAULT, exercise_files: {}, exercise_slug: nil

    def call
      unknown = outputs - OUTPUTS
      raise ArgumentError, "Unknown outputs: #{unknown.join(', ')}" if unknown.any?

      # Make the snippet first, because the representation's stages change
      # the trees that it shares with the snippet.
      generated = outputs.uniq.sort_by { |output| output == :snippet ? 0 : 1 }.to_h { |output| [output, send(output)] }
      outputs.uniq.to_h { |output| [output, generated[output]] }
    end

    private
    # Exercise files over their limit make the solution too large too, as the
    # whole request has to fit under the load balancer's limit.
    def representation
      if bytes(exercise_files) > MAX_EXERCISE_BYTES
        return error("too_large", "The exercise files are over #{MAX_EXERCISE_BYTES} bytes", version: language.version)
      end

      result = RepresentSolution.(track_slug, solution_files, exercise_slug:, trees:)
      return error(result.reason, result.message, version: result.version) if result.reason

      { representation: result.representation, mapping: result.mapping, version: result.version }
    end

    # A bug in a snippet's rules must never fail the request, so the snippet
    # gets an error and the log says what went wrong.
    def snippet
      rules = Languages.snippet_for(track_slug)
      file = Engine::FindMainFile.(solution_files, exercise_files)
      source = Engine.clean(solution_files.fetch(file))
      { snippet: rules.(track_slug, source, parse(file, source, rules.language)), version: rules.version }
    rescue StandardError => e
      warn "#{track_slug}/#{exercise_slug} snippet: #{e.class}: #{e.message}\n#{e.backtrace&.first(5)&.join("\n")}"
      error("internal_error", "One of the snippet's rules raised an error")
    end

    # Parses the file with the language's grammar and options, as PrepareFile
    # would, and keeps the tree for the representation. Returns nil if the
    # track has no grammar, or the file is too large or doesn't parse.
    def parse(file, source, language)
      return nil unless language && source.bytesize <= MAX_SOLUTION_BYTES

      trees[file] = Engine::Grammar[language.grammar].parse(source, spans: true, **language.parse_options)
    rescue CannotRepresent
      nil
    end

    memoize
    def trees = {}

    # The comments of the exercise's rules, for a track with an analysis.
    # A bug in a rule must never fail the request, so the analysis gets an
    # error and the log says what went wrong.
    def analysis
      analysis = language.respond_to?(:analysis) && language.analysis
      return error("not_supported", "The #{track_slug} track has no analysis rules yet") unless analysis

      begin
        { comments: Engine::Analyse.(analysis, exercise_slug, solution_files, exercise_files), version: analysis.version }
      rescue CannotRepresent => e
        error(e.reason, e.message, version: analysis.version)
      rescue SystemStackError
        error("too_deep", "The code nests too deeply", version: analysis.version)
      rescue StandardError => e
        warn "#{track_slug}/#{exercise_slug} analysis: #{e.class}: #{e.message}\n#{e.backtrace&.first(5)&.join("\n")}"
        error("internal_error", "One of the analysis's rules raised an error", version: analysis.version)
      end
    end

    def error(reason, message, **details) = { error: reason, message:, **details }

    def language = Languages.for(track_slug)
    def bytes(files) = files.sum { |name, source| name.bytesize + source.bytesize }
  end
end
