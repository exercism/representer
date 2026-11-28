module Rosetta
  # Represents a solution with its track's language. Tracks with no language
  # of their own get Basic.
  #
  # If a file doesn't parse, the solution gets Basic's representation, with
  # the language's version (see represent_with_basic).
  #
  # A solution that a language can't represent for another reason (it nests
  # too deeply, is too large, or has no source file) gets no
  # representation: the result has a nil representation, an empty mapping,
  # the language's version, the reason and a message. So does a solution
  # that makes a rule raise an error (reason "internal_error").
  class RepresentSolution
    include Mandate

    # A solution that falls back to Basic gets a representation that starts
    # with this line, so it can never equal a tree's, which starts with "(".
    BASIC_PREFIX = "basic\n".freeze

    # trees holds the files already parsed by the snippet, by filename. The
    # language starts from them instead of parsing the files again.
    initialize_with :track_slug, :solution_files, exercise_slug: nil, trees: {}

    def call
      raise CannotRepresent.new("too_large", "The solution is over #{MAX_SOLUTION_BYTES} bytes") if too_large?

      return Languages::Basic.(track_slug, solution_files) if language == Languages::Basic

      represent
    rescue CannotRepresent => e
      unrepresentable(e.reason, e.message)
    rescue SystemStackError
      # A language's rules recurse into the tree, and a tree nested close to
      # MAX_DEPTH can still overflow the stack.
      unrepresentable("too_deep", "The code nests too deeply")
    rescue StandardError => e
      # A bug in a rule must never fail the request, so the website marks the
      # solution as unrepresentable and the log says what went wrong.
      warn "#{track_slug}/#{exercise_slug}: #{e.class}: #{e.message}\n#{e.backtrace&.first(5)&.join("\n")}"
      unrepresentable("internal_error", "One of Rosetta's rules raised an error")
    end

    private
    def language = Languages.for(track_slug)
    def too_large? = solution_files.sum { |name, source| name.bytesize + source.bytesize } > MAX_SOLUTION_BYTES

    def represent
      language.(solution_files, trees:)
    rescue CannotRepresent => e
      raise unless e.reason == "parse_error"

      represent_with_basic
    end

    # Every solution passes its tests, so a file that doesn't parse shows a
    # gap in the grammar. Basic still groups solutions that differ only in
    # comments and formatting. The result keeps the language's version, so
    # the website has one version for each track.
    def represent_with_basic
      basic = Languages::Basic.(track_slug, solution_files)
      Engine::Result.new(representation: BASIC_PREFIX + basic.representation, mapping: basic.mapping,
        version: language.version, language: Languages::Basic)
    end

    def unrepresentable(reason, message)
      Engine::Result.new(representation: nil, mapping: {}, version: language.version, language: language, reason:,
        message:)
    end
  end
end
