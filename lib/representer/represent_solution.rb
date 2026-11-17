module Representer
  # Represents a solution with its track's language, and falls back to Basic
  # if that language can't parse it.
  #
  # A fallback still reports the language's version, so that one track never
  # mixes two version numbers. Basic's own version only applies to tracks
  # with no class of their own. So a change to Basic's output must bump
  # Basic's version and every language's version too.
  class RepresentSolution
    include Mandate

    initialize_with :track_slug, :solution_files, :exercise_files

    def call
      language = Languages.for(track_slug)
      return basic if language == Languages::Basic

      begin
        language.(solution_files, exercise_files)
      rescue CannotRepresent
        basic.tap { |result| result.version = language.version }
      end
    end

    private
    def basic = Languages::Basic.(track_slug, solution_files)
  end
end
