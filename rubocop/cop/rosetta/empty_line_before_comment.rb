# frozen_string_literal: true

module RuboCop
  module Cop
    module Rosetta
      # A comment describes the code below it, so put a blank line above the
      # comment to keep the two together and apart from the code before them.
      # The blank line isn't needed when the comment is the first thing in a
      # method, class, module or block, follows another comment, or follows
      # `private`, `protected` or `public`.
      #
      # e.g. We flag:
      #   drop_tokens(tree)
      #   # Unwrap brackets that only group.
      #   unwrap(tree)
      #
      # and want:
      #   drop_tokens(tree)
      #
      #   # Unwrap brackets that only group.
      #   unwrap(tree)
      class EmptyLineBeforeComment < Base
        extend AutoCorrector

        MSG = "Put a blank line before a comment that describes the code below it."

        KEYWORDS = %w[def class module begin if unless case while until when in else elsif rescue ensure private protected
                      public].freeze
        OPENERS = /\A(#{KEYWORDS.join('|')})\b|(\bdo|\{|\[|\(|\|)\s*(\|[^|]*\|)?\s*\z/

        def on_new_investigation
          lines = processed_source.lines
          processed_source.comments.each do |comment|
            line_number = comment.loc.line
            next if line_number == 1

            text = lines[line_number - 1]
            next unless text.strip.start_with?("#")

            previous = lines[line_number - 2].strip
            next if previous.empty? || previous.start_with?("#") || previous.match?(OPENERS)

            add_offense(comment) do |corrector|
              corrector.insert_before(comment.source_range.with(begin_pos: comment.source_range.begin_pos - comment.loc.column), "\n")
            end
          end
        end
      end
    end
  end
end
