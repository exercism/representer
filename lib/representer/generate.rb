module Representer
  # Generates the outputs asked for, for one solution. The outputs are
  # :representation, :snippet and :analysis, and the result has one key for
  # each output asked for:
  #
  #   Generate.("ruby", { "two_fer.rb" => "..." }, outputs: %i[representation snippet])
  #   # => { representation: { representation: "...", mapping: {...}, version: 12 },
  #   #      snippet: { error: "not_supported", message: "..." } }
  #
  # Each output has its own version, so a change to one output never makes
  # the website generate the others again.
  #
  # If an output can't be generated, its key holds an error with a reason
  # (error) and a message. The other outputs still come back. A solution that
  # can't be represented gets an error with the reasons listed in README.md,
  # and the language's version. An output that the track doesn't support yet
  # gets the error "not_supported".
  class Generate
    include Mandate

    OUTPUTS = %i[representation snippet analysis].freeze

    initialize_with :track_slug, :solution_files, outputs: Mandate::NO_DEFAULT, exercise_files: {}, exercise_slug: nil

    def call
      unknown = outputs - OUTPUTS
      raise ArgumentError, "Unknown outputs: #{unknown.join(', ')}" if unknown.any?

      outputs.uniq.to_h { |output| [output, send(output)] }
    end

    private
    # Exercise files over their limit make the solution too large too, as the
    # whole request has to fit under the load balancer's limit.
    def representation
      if bytes(exercise_files) > MAX_EXERCISE_BYTES
        return error("too_large", "The exercise files are over #{MAX_EXERCISE_BYTES} bytes", version: language.version)
      end

      result = RepresentSolution.(track_slug, solution_files, exercise_files, exercise_slug:)
      return error(result.reason, result.message, version: result.version) if result.reason

      { representation: result.representation, mapping: result.mapping, version: result.version }
    end

    def snippet = error("not_supported", "The representer doesn't make snippets yet")

    def analysis = error("not_supported", "The #{track_slug} track has no analysis rules yet")

    def error(reason, message, **details) = { error: reason, message:, **details }

    def language = Languages.for(track_slug)
    def bytes(files) = files.sum { |name, source| name.bytesize + source.bytesize }
  end
end
