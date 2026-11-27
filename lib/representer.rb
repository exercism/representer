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

  # The most times the rewrite rules may change one node. A rule that keeps
  # matching its own output would otherwise run forever. A solution that
  # needs more can't be represented (reason "too_complex").
  MAX_REWRITES_PER_NODE = 50

  # The most seconds the rules may take over one solution. A slower solution
  # can't be represented (reason "too_complex").
  MAX_SECONDS = 10

  # The solution can't be represented. The reason is "parse_error",
  # "too_deep", "too_large", "too_complex" or "no_source_files", and the
  # response gives it to the website.
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
require_relative "representer/engine/numbers"
require_relative "representer/engine/pattern"
require_relative "representer/engine/template"
require_relative "representer/engine/grammar"
require_relative "representer/engine/names"
require_relative "representer/engine/tree_helpers"
require_relative "representer/engine/code_pattern"
require_relative "representer/engine/sort_children"
require_relative "representer/engine/attach_to_next"
require_relative "representer/engine/attach_to_each_following"
require_relative "representer/engine/stages"
require_relative "representer/engine/drop_imports"
require_relative "representer/engine/prepare_file"
require_relative "representer/engine/collect_defined_names"
require_relative "representer/engine/rename_user_defined_nodes"
require_relative "representer/engine/join_files"
require_relative "representer/engine/number_placeholders"
require_relative "representer/engine/represent_with_stages"
require_relative "representer/engine/represent"
require_relative "representer/engine/find_main_file"
require_relative "representer/engine/find_removed_nodes"
require_relative "representer/engine/find_skipped_statements"
require_relative "representer/engine/find_comments"
require_relative "representer/engine/cut_ranges"
require_relative "representer/engine/skip_lines"
require_relative "representer/engine/tidy_lines"
require_relative "representer/engine/snippet"
require_relative "representer/language_setup"
require_relative "representer/language"
require_relative "representer/engine/language"
require_relative "representer/languages"
require_relative "representer/represent_solution"
require_relative "representer/generate"
require_relative "representer/process_request"
