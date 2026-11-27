module Representer::Engine
  # Finds the solution's main file, which the snippet comes from. It is the
  # first file listed in `files.solution` in the exercise's
  # `.meta/config.json` that the student submitted. If the student submitted
  # none of them, it is the student's first file, in name order.
  class FindMainFile
    include Mandate

    initialize_with :solution_files, :exercise_files

    def call = solution_paths.find { |path| solution_files.key?(path) } || solution_files.keys.min

    private
    def solution_paths
      config = JSON.parse(exercise_files.fetch(".meta/config.json", "{}"))
      files = config["files"] if config.is_a?(Hash)
      paths = files["solution"] if files.is_a?(Hash)
      paths.is_a?(Array) ? paths : []
    rescue JSON::ParserError
      []
    end
  end
end
