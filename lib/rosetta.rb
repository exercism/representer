require "json"
require "mandate"

module Rosetta
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
  # "too_deep", "too_large" or "no_source_files", and the response gives it
  # to the website.
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

require_relative "rosetta/engine/node"
require_relative "rosetta/engine/numbers"
require_relative "rosetta/engine/pattern"
require_relative "rosetta/engine/template"
require_relative "rosetta/engine/blank_comments"
require_relative "rosetta/engine/grammar"
require_relative "rosetta/engine/tree_helpers"
require_relative "rosetta/engine/same_code"
require_relative "rosetta/engine/code_pattern"
require_relative "rosetta/engine/sort_children"
require_relative "rosetta/engine/attach_to_next"
require_relative "rosetta/engine/rewrite_code"
require_relative "rosetta/engine/add_braces"
require_relative "rosetta/engine/attach_to_each_following"
require_relative "rosetta/engine/drop_comments"
require_relative "rosetta/engine/write_numbers_as_values"
require_relative "rosetta/engine/label_list_heads"
require_relative "rosetta/engine/unwrap_brackets"
require_relative "rosetta/engine/strip_tokens"
require_relative "rosetta/engine/inherit_declarations"
require_relative "rosetta/engine/stages"
require_relative "rosetta/engine/drop_imports"
require_relative "rosetta/engine/prepare_file"
require_relative "rosetta/engine/collect_defined_names"
require_relative "rosetta/engine/rename_user_defined_nodes"
require_relative "rosetta/engine/serialize"
require_relative "rosetta/engine/join_files"
require_relative "rosetta/engine/number_placeholders"
require_relative "rosetta/engine/represent"
require_relative "rosetta/engine/find_main_file"
require_relative "rosetta/engine/find_removed_nodes"
require_relative "rosetta/engine/find_skipped_statements"
require_relative "rosetta/engine/find_comments"
require_relative "rosetta/engine/cut_ranges"
require_relative "rosetta/engine/skip_lines"
require_relative "rosetta/engine/tidy_lines"
require_relative "rosetta/engine/snippet"
require_relative "rosetta/engine/autoload_files"
require_relative "rosetta/engine/representation"
require_relative "rosetta/engine/indented_in_steps"
require_relative "rosetta/engine/analysis_rules"
require_relative "rosetta/engine/analysis"
require_relative "rosetta/engine/analyse"
require_relative "rosetta/engine/language"
require_relative "rosetta/languages"
require_relative "rosetta/represent_solution"
require_relative "rosetta/generate"
require_relative "rosetta/process_request"
