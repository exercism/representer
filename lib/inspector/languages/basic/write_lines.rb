# This command writes the lines given by DropImports as the representation:
# each line's tokens with single spaces between them, on lines of their own.
# Line breaks stay, because they can change the meaning, as in JavaScript's
# `return\nx`.
#   [[0, ["x", "=", "1"]], [0, ["y"]]]  ->  "x = 1\ny"
class Inspector::Languages::Basic
  class WriteLines
    include Mandate

    initialize_with :track_slug, :lines

    # Write a token as it is if it has no whitespace and doesn't start with a
    # double quote, and otherwise in double quotes with escapes. The output
    # can then only be read back one way, so different code can't give the
    # same output.
    # x  ->  x
    # "a b"  ->  "\"a b\""
    PLAIN = /\A[^\s"]\S*\z/

    def call
      indentation = [0]
      lines.map do |indent, tokens|
        depth = INDENTATION_SENSITIVE.include?(track_slug) ? depth(indentation, indent) : 0
        ("  " * depth) + tokens.map { |token| token.match?(PLAIN) ? token : token.dump }.join(" ")
      end.join("\n")
    end

    private
    # Turn an indentation width into a depth, as Python does: deeper than the
    # line above opens a level, and shallower closes levels until the width
    # matches. So 2 and 4 spaces give the same depths.
    def depth(stack, width)
      stack.pop while stack.size > 1 && width < stack.last
      stack << width if width > stack.last
      stack.size - 1
    end
  end
end
