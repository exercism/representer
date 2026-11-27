module Representer
  # Represents a solution with its track's language. Tracks with no class of
  # their own get Basic.
  #
  # A solution that a language can't represent (it has a syntax error, nests
  # too deeply, is too large, or hits one of the engine's other limits) gets
  # no representation: the result has a nil representation, an empty
  # mapping, the language's version, the reason and a message. So does a
  # solution that makes a rule raise an error (reason "internal_error").
  class RepresentSolution
    include Mandate

    # trees holds the files already parsed by the snippet, by filename. A
    # staged language starts from them instead of parsing the files again.
    initialize_with :track_slug, :solution_files, :exercise_files, exercise_slug: nil, trees: {}

    def call
      raise CannotRepresent.new("too_large", "The solution is over #{MAX_SOLUTION_BYTES} bytes") if too_large?

      return Languages::Basic.(track_slug, solution_files) if language == Languages::Basic

      # Only a staged language starts from the trees already parsed for the
      # snippet, because the other languages parse with their own options.
      return language.(solution_files, exercise_files, trees:) if language.staged?

      language.(solution_files, exercise_files)
    rescue CannotRepresent => e
      # Hitting one of the engine's limits usually means a rule is wrong, so
      # the message goes to the log.
      warn "#{track_slug}: #{e.message}" if e.reason == "too_complex"
      unrepresentable(e.reason, e.message)
    rescue SystemStackError
      # A language's rules recurse into the tree, and a tree nested close to
      # MAX_DEPTH can still overflow the stack.
      unrepresentable("too_deep", "The code nests too deeply")
    rescue StandardError => e
      # A bug in a rule must never fail the request, so the website marks the
      # solution as unrepresentable and the log says what went wrong.
      warn "#{track_slug}/#{exercise_slug}: #{e.class}: #{e.message}\n#{e.backtrace&.first(5)&.join("\n")}"
      unrepresentable("internal_error", "One of the representer's rules raised an error")
    end

    private
    def language = Languages.for(track_slug)
    def too_large? = solution_files.sum { |name, source| name.bytesize + source.bytesize } > MAX_SOLUTION_BYTES

    def unrepresentable(reason, message)
      Engine::Result.new(representation: nil, mapping: {}, version: language.version, representer: language, reason:,
        message:)
    end
  end
end
