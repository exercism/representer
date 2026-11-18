module Representer
  # Represents a solution with its track's language. Tracks with no class of
  # their own get Basic.
  #
  # A solution that a language can't represent (it has a syntax error, nests
  # too deeply, or is too large) gets no representation: the result has a
  # nil representation, an empty mapping, the language's version and the
  class RepresentSolution
    include Mandate

    initialize_with :track_slug, :solution_files, :exercise_files

    def call
      raise CannotRepresent.new("too_large", "The solution is over #{MAX_SOLUTION_BYTES} bytes") if too_large?

      return Languages::Basic.(track_slug, solution_files) if language == Languages::Basic

      language.(solution_files, exercise_files)
    rescue CannotRepresent => e
      Engine::Result.new(representation: nil, mapping: {}, version: language.version, representer: language, reason: e.reason)
    end

    private
    def language = Languages.for(track_slug)
    def too_large? = solution_files.sum { |name, source| name.bytesize + source.bytesize } > MAX_SOLUTION_BYTES
  end
end
