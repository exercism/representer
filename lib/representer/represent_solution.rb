module Representer
  # Represents a solution with its track's language. Tracks with no class of
  # their own get Basic.
  #
  # A solution that a language can't represent (it has a syntax error, nests
  # too deeply, is too large, or hits one of the engine's other limits) gets
  # no representation: the result has a nil representation, an empty
  # mapping, the language's version and the reason.
  class RepresentSolution
    include Mandate

    initialize_with :track_slug, :solution_files, :exercise_files

    def call
      raise CannotRepresent.new("too_large", "The solution is over #{MAX_SOLUTION_BYTES} bytes") if too_large?

      return Languages::Basic.(track_slug, solution_files) if language == Languages::Basic

      language.(solution_files, exercise_files)
    rescue CannotRepresent => e
      # Hitting one of the engine's limits usually means a rule is wrong, so
      # the message goes to the log.
      warn "#{track_slug}: #{e.message}" if e.reason == "too_complex"
      unrepresentable(e.reason)
    rescue SystemStackError
      # A language's rules recurse into the tree, and a tree nested close to
      # MAX_DEPTH can still overflow the stack.
      unrepresentable("too_deep")
    end

    private
    def language = Languages.for(track_slug)
    def too_large? = solution_files.sum { |name, source| name.bytesize + source.bytesize } > MAX_SOLUTION_BYTES

    def unrepresentable(reason)
      Engine::Result.new(representation: nil, mapping: {}, version: language.version, representer: language, reason:)
    end
  end
end
