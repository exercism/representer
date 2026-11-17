require "json"
require "mandate"

module Representer
  # The most bytes the solution files may hold in total. Larger solutions get
  # a 413, and the website doesn't represent them.
  MAX_SOLUTION_BYTES = 200_000

  # The most bytes the exercise files may hold in total. With the solution
  # limit, this keeps the request under the load balancer's 1 MB limit.
  MAX_EXERCISE_BYTES = 500_000

  # The deepest a syntax tree may nest. Deeper code falls back to Basic.
  MAX_DEPTH = 1_000

  # The language's parser can't represent this solution, so it falls back
  # to Basic.
  class CannotRepresent < StandardError; end

  # The request is invalid (400).
  class BadRequest < StandardError; end

  # The request's files are too large (413).
  class TooLarge < StandardError; end

  def self.process(event:, context:) = ProcessRequest.(event, context)
end

require_relative "representer/engine/node"
require_relative "representer/engine/pattern"
require_relative "representer/engine/template"
require_relative "representer/engine/grammar"
require_relative "representer/engine/names"
require_relative "representer/engine/represent"
require_relative "representer/language"
require_relative "representer/languages"
require_relative "representer/represent_solution"
require_relative "representer/process_request"
