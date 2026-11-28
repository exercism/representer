require "json"
require "mandate"

module Inspector
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

require_relative "inspector/engine/node"
require_relative "inspector/engine/numbers"
require_relative "inspector/engine/pattern"
require_relative "inspector/engine/template"
require_relative "inspector/engine/blank_comments"
require_relative "inspector/engine/grammar"
require_relative "inspector/engine/tree_helpers"
require_relative "inspector/engine/same_code"
require_relative "inspector/engine/code_pattern"
require_relative "inspector/engine/sort_children"
require_relative "inspector/engine/attach_to_next"
require_relative "inspector/engine/rewrite_code"
require_relative "inspector/engine/add_braces"
require_relative "inspector/engine/attach_to_each_following"
require_relative "inspector/engine/drop_comments"
require_relative "inspector/engine/write_numbers_as_values"
require_relative "inspector/engine/label_list_heads"
require_relative "inspector/engine/unwrap_brackets"
require_relative "inspector/engine/strip_tokens"
require_relative "inspector/engine/inherit_declarations"
require_relative "inspector/engine/stages"
require_relative "inspector/engine/drop_imports"
require_relative "inspector/engine/prepare_file"
require_relative "inspector/engine/collect_defined_names"
require_relative "inspector/engine/rename_user_defined_nodes"
require_relative "inspector/engine/serialize"
require_relative "inspector/engine/join_files"
require_relative "inspector/engine/number_placeholders"
require_relative "inspector/engine/represent"
require_relative "inspector/engine/find_main_file"
require_relative "inspector/engine/find_removed_nodes"
require_relative "inspector/engine/find_skipped_statements"
require_relative "inspector/engine/find_comments"
require_relative "inspector/engine/cut_ranges"
require_relative "inspector/engine/skip_lines"
require_relative "inspector/engine/tidy_lines"
require_relative "inspector/engine/snippet"
require_relative "inspector/engine/autoload_files"
require_relative "inspector/engine/representation"
require_relative "inspector/engine/indented_in_steps"
require_relative "inspector/engine/analysis_rules"
require_relative "inspector/engine/analysis"
require_relative "inspector/engine/analyse"
require_relative "inspector/engine/language"
require_relative "inspector/languages"
require_relative "inspector/represent_solution"
require_relative "inspector/generate"
require_relative "inspector/process_request"
