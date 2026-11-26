require "json"
require "mandate"

module Representer
  # The most bytes the solution files may hold in total. Larger solutions
  # can't be represented (reason "too_large").
  MAX_SOLUTION_BYTES = 200_000

  # The most bytes the exercise files may hold in total. With the solution
  # limit, this keeps the request under the load balancer's 1 MB limit.
  MAX_EXERCISE_BYTES = 500_000

  # The deepest a syntax tree may nest. Deeper code can't be represented
  # (reason "too_deep").
  MAX_DEPTH = 1_000

  # The solution can't be represented. The reason is "parse_error",
  # "too_deep" or "too_large", and the response gives it to the website.
  class CannotRepresent < StandardError
    attr_reader :reason

    def initialize(reason, message)
      @reason = reason
      super(message)
    end
  end

  # The request is invalid (400).
  class BadRequest < StandardError; end

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
require_relative "representer/snippet"
require_relative "representer/process_request"
