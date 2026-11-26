# What this class does to a Python solution's code to make its representation:
#
# - Gives no representation to code that Python rejects, such as Python 2's
#   `print "x"`.
# - Drops comments, line continuations, docstrings, print statements and `if
#   __name__ == "__main__":` blocks.
# - Drops imports and `__all__`, keeps `from __future__` imports, and writes
#   each name given with `as` as the name it stands for.
# - Drops punctuation and keywords that the tree already shows, and brackets
#   that only group.
# - Drops type hints.
# - Writes `elif` as `else` with an `if`, and `1, 2` as `(1, 2)`.
# - Writes numbers as their values (`1_000` is `1000`, `0x10` is `16`).
# - Writes a string as its value, joining adjacent strings.
# - Replaces each name that the solution defines with a placeholder
#   (PLACEHOLDER_1, PLACEHOLDER_2 and so on).
# - Keeps every name used in the tests, the members of the exercise's stub,
#   and the language's library names.
# - Also keeps names that start and end with `__`.
# - Ignores files with other extensions, and test and config files.
# - Joins the files into one tree, in an order set by their code. File names
#   never appear.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    # Follows the old exercism/python-representer, which renamed names in
    # Python's own `ast` tree, and left out comments, docstrings, print
    # statements, `if __name__ == "__main__"` blocks and type hints.
    class Python < Language
      tracks "python"
      version 7
      grammar "python"
      extensions ".py"

      names :identifier

      # Python's own built-in names and exceptions. A solution can't give
      # them a new meaning without confusing the rest of Python, so they are
      # never renamed.
      BUILTINS = %w[
        ArithmeticError AssertionError AttributeError BaseException BaseExceptionGroup BlockingIOError BrokenPipeError
        BufferError BytesWarning ChildProcessError ConnectionAbortedError ConnectionError ConnectionRefusedError
        ConnectionResetError DeprecationWarning EOFError Ellipsis EncodingWarning EnvironmentError Exception
        ExceptionGroup False FileExistsError FileNotFoundError FloatingPointError FutureWarning GeneratorExit IOError
        ImportError ImportWarning IndentationError IndexError InterruptedError IsADirectoryError KeyError
        KeyboardInterrupt LookupError MemoryError ModuleNotFoundError NameError None NotADirectoryError NotImplemented
        NotImplementedError OSError OverflowError PendingDeprecationWarning PermissionError ProcessLookupError
        RecursionError ReferenceError ResourceWarning RuntimeError RuntimeWarning StopAsyncIteration StopIteration
        SyntaxError SyntaxWarning SystemError SystemExit TabError TimeoutError True TypeError UnboundLocalError
        UnicodeDecodeError UnicodeEncodeError UnicodeError UnicodeTranslateError UnicodeWarning UserWarning ValueError
        Warning ZeroDivisionError abs aiter all anext any ascii bin bool breakpoint bytearray bytes callable chr
        classmethod compile complex delattr dict dir divmod enumerate eval exec filter float format frozenset getattr
        globals hasattr hash help hex id input int isinstance issubclass iter len list locals map max memoryview min
        next object oct open ord pow print property range repr reversed round set setattr slice sorted staticmethod
        str sum super tuple type vars zip self _ exit quit license copyright credits PythonFinalizationError
        _IncompleteInputError
      ].freeze

      # Tree-sitter leaves the text between a string's escape sequences out
      # of its tree, so these types ask for it back.
      text_between_children :string_content, :format_specifier

      ### Syntax checks ###

      # The grammar accepts some code that Python rejects, which the old
      # representer (using Python's own parser) never represented: Python 2's
      # `print "x"` and `exec "x"`, a decimal number with a leading zero, and
      # indentation that mixes tabs and spaces or dedents to a level that
      # was never opened.
      syntax_check do |_source, tree|
        problem = nil
        tree.each_descendant do |node|
          problem ||= "Python 2's #{node.type}" if %w[print_statement exec_statement].include?(node.type)
          problem ||= "A number with a leading zero" if node.type == "integer" && node.text.match?(/\A0[0-9_]*[1-9][0-9_]*\z/)
        end
        problem
      end
      syntax_check { |source, _tree| Python.indentation_problem(source) }

      ### Drop ###

      drop "(comment)"
      drop "(line_continuation)"

      # The `__all__` list of what a module exports only makes names
      # available. A rule below removes the imports.
      drop '[(expression_statement (assignment left: (identifier "__all__"))) (assignment left: (identifier "__all__"))]'

      # `if __name__ == "__main__":` blocks only run when the file is a script.
      drop "(if_statement condition: (comparison_operator))", where: ->(match) { Python.main_guard?(match.node) }

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "[", "]", "{", "}", ",", ";",
        "class", "def", "lambda", "return", "pass", "break", "continue", "raise", "assert", "del", "try", "finally", "except",
        "elif", "else", "while", "if", "for", "with", "import", "as", "match", "case", "await", "global", "nonlocal"

      # In these nodes, a trailing comma makes a tuple: `a[1,]` is `a[(1,)]`,
      # not `a[1]`, and `case 1,:` and `match x,:` match a one-item tuple.
      keep_tokens_in :subscript, ","
      keep_tokens_in :case_clause, ","
      keep_tokens_in :match_statement, ","

      ### Rewrite ###

      # (a + b) is a + b: the tree's shape already shows the grouping.
      unwrap :parenthesized_expression

      # `1, 2` is `(1, 2)`, and `a, b = x` is `(a, b) = x`.
      retype expression_list: :tuple, pattern_list: :tuple_pattern

      # Type hints don't change what the code does. The old representer left
      # them out of parameters, return types and assignments, and made a
      # bare `x: int` into `x = None`.
      rewrite("(typed_parameter (_) @parameter)") { |match| match[:parameter] }
      rewrite "(typed_default_parameter name: (_) @name value: (_) @value)" do |match|
        build(:default_parameter, { name: match[:name] }, token("="), { value: match[:value] })
      end
      rewrite "(function_definition return_type: (_) @type)" do |match|
        match.node.children.reject! { |child| child.equal?(match[:type]) || child.type == "->" }
        match.node
      end
      rewrite "(assignment left: (_) @left type: (_))" do |match|
        right = match.node["right"] || leaf(:none, "None")
        build(:assignment, { left: match[:left] }, token("="), { right: right })
      end

      # Print statements go, as they did in the old representer. A body left
      # with nothing in it is `pass`.
      rewrite "[(block) (module)]" do |match|
        body = match.node.children
        kept = body.reject { |statement| Python.print_statement?(statement) }
        next nil if kept.size == body.size && !body.empty?

        kept << Python.pass_statement if kept.empty?
        match.node.children.replace(kept)
        match.node
      end

      # Docstrings go too.
      rewrite "[(function_definition body: (block) @body) (class_definition body: (block) @body)]" do |match|
        next nil unless match[:body].children.first&.type == "literal"

        match[:body].children.shift
        match[:body].children << Python.pass_statement if match[:body].children.empty?
        match.node
      end
      rewrite "(module) @module" do |match|
        next nil unless match.node.children.first&.type == "literal"

        match.node.children.shift
        match.node.children << Python.pass_statement if match.node.children.empty?
        match.node
      end

      # `elif` is an `else` that holds an `if`, as it is in Python's own tree.
      rewrite "(if_statement) @if", where: ->(match) { match.node.children.any? { |child| child.type == "elif_clause" } } do |match|
        children = match.node.children
        index = children.index { |child| child.type == "elif_clause" }
        elif = children[index]
        nested = build(:if_statement, { condition: elif["condition"] }, token(":"), { consequence: elif["consequence"] },
          *children[(index + 1)..])
        otherwise = build(:else_clause, token(":"), { body: build(:block, nested) })
        otherwise.field = "alternative"
        children.slice!(index..)
        children << otherwise
        match.node
      end

      # `f(x for x in y)` and `f((x for x in y))` are the same call, but the
      # grammar gives them different shapes.
      rewrite "(call arguments: (argument_list (generator_expression) @generator) @arguments)",
        where: ->(match) { match[:arguments].children.size == 1 } do |match|
        match.node.replace_child(match[:arguments], match[:generator])
        match.node
      end

      # In `case` patterns, `[a, b]` and `(a, b)` match the same sequences.
      rewrite "[(case_pattern) (union_pattern) (as_pattern)] @pattern" do |match|
        lists = match.node.children.select { |child| child.type == "list_pattern" }
        next nil if lists.empty?

        lists.each { |list| list.type = "tuple_pattern" }
        match.node
      end

      # Imports only make names available, so they go. A name that an import
      # gives with `as` becomes the name it stands for: after
      # `import numpy as np`, `np.pi` is `numpy.pi`. A `from __future__`
      # import changes how the code runs, so it stays.
      rewrite("[(module) (block)] @scope") { |match| Python.drop_imports(match.node) ? match.node : nil }

      # Numbers are their values: 1_000 is 1000, and 0x10 is 16.
      rewrite "(integer) @number" do |match|
        value = Python.integer_value(match.node.text)
        next nil if value == match.node.text

        leaf(value.end_with?("j") ? :float : :integer, value)
      end
      rewrite "(float) @number" do |match|
        value = Python.float_value(match.node.text)
        value == match.node.text ? nil : leaf(:float, value)
      end

      # A string is its value, so 'a' and "a" are the same, and so are
      # "a" "b" and "ab".
      rewrite("(string) @string") { |match| Python.string_value(match.node) }
      rewrite "(concatenated_string) @strings" do |match|
        Python.join_strings(match.node)
      end

      # In `case x:` a bare name captures the value, which makes it a
      # variable. A dotted name (`Color.RED`) refers to a value.
      rewrite "(case_pattern (dotted_name) @name)", where: ->(match) { match[:name].children.size == 1 } do |match|
        match.node.replace_child(match[:name], build(:capture_pattern, match[:name].children.first))
        match.node
      end

      ### Rename and keep ###

      # Parameters.
      rename "[(parameters (identifier)* @name) (lambda_parameters (identifier)* @name)]"
      rename "(default_parameter name: (identifier) @name)"
      rename "[(list_splat_pattern (identifier) @name) (dictionary_splat_pattern (identifier) @name)]"

      # Variables.
      rename "[(assignment left: (identifier) @name) (augmented_assignment left: (identifier) @name)]"
      rename "[(tuple_pattern (identifier)* @name) (list_pattern (identifier)* @name)]"
      rename "[(for_statement left: (identifier) @name) (for_in_clause left: (identifier) @name)]"
      rename "[(as_pattern alias: (as_pattern_target (identifier) @name)) (named_expression name: (identifier) @name)]"
      rename "[(global_statement (identifier)* @name) (nonlocal_statement (identifier)* @name)]"
      rename "(splat_pattern (identifier) @name)"
      rename "[(capture_pattern (identifier) @name) (case_pattern (as_pattern (identifier) @name))]"

      # Functions, classes, and the fields that a class defines.
      rename_member "[(function_definition name: (identifier) @name) (class_definition name: (identifier) @name)]"
      rename_member "(class_definition body: (block (assignment left: (identifier) @name)*))"
      rename_member "(assignment left: (attribute object: (identifier /\\A(self|cls)\\z/) attribute: (identifier) @name))"
      rename_member "(tuple_pattern (attribute object: (identifier /\\A(self|cls)\\z/) attribute: (identifier) @name)*)"

      # Names after a dot, and the names in an import, refer to something in
      # another module or object.
      member "(attribute attribute: (identifier) @name)"
      member "(keyword_pattern (identifier) @name)"
      member "(dotted_name (identifier)* @name)"

      # Names that Python itself uses.
      keep(*BUILTINS)
      keep "(identifier /\\A__\\w+__\\z/) @name"

      library_names File.join(__dir__, "library_names", "python.txt")

      ### Helpers for the rules above ###

      ESCAPES = {
        "n" => "\n", "t" => "\t", "r" => "\r", "a" => "\a", "b" => "\b", "f" => "\f", "v" => "\v",
        "\\" => "\\", "'" => "'", "\"" => "\"", "\n" => "", "\r\n" => ""
      }.freeze

      class << self
        def pass_statement = build(:pass_statement)

        # Python's own indentation check. It measures each line's indentation
        # twice, with a tab as 8 columns and as 1, and both measures must
        # agree about which lines are deeper (or it raises TabError). A
        # dedent must return to a level that is open (or it raises
        # IndentationError). Returns a message, or nil if the indentation is
        # valid.
        def indentation_problem(source)
          levels = [[0, 0]]
          each_line_indentation(source) do |indentation|
            width = indentation.each_char.reduce(0) { |column, char| char == "\t" ? ((column / 8) + 1) * 8 : column + 1 }
            other = indentation.size
            if width > levels.last[0]
              return "Inconsistent use of tabs and spaces" if other <= levels.last[1]

              levels << [width, other]
            else
              levels.pop while levels.size > 1 && width < levels.last[0]
              return "A dedent that matches no outer indentation level" if width != levels.last[0]
              return "Inconsistent use of tabs and spaces" if other != levels.last[1]
            end
          end
          nil
        end

        # Yields the indentation of each line that starts a statement: not a
        # blank or comment line, and not a line inside brackets, a string or
        # after a backslash.
        def each_line_indentation(source)
          depth = 0
          quote = nil
          continued = false
          source.each_line do |line|
            starts = depth.zero? && quote.nil? && !continued
            continued = false
            indentation = line[/\A[ \t\f]*/]
            yield indentation.delete("\f") if starts && !line[indentation.size..].match?(/\A(#|\r?\n|\z)/)

            index = starts ? indentation.size : 0
            while index < line.size
              char = line[index]
              if quote
                if char == "\\"
                  index += 1
                elsif line[index, quote.size] == quote
                  index += quote.size - 1
                  quote = nil
                end
              elsif char == "#"
                break
              elsif ["'", '"'].include?(char)
                quote = line[index, 3] == char * 3 ? char * 3 : char
                index += quote.size - 1
              elsif char == "\\" && line[index + 1] == "\n"
                continued = true
              elsif "([{".include?(char)
                depth += 1
              elsif ")]}".include?(char)
                depth = [depth - 1, 0].max
              end
              index += 1
            end
            quote = nil if quote&.size == 1
          end
        end

        def print_statement?(node)
          node.type == "call" && node["function"]&.type == "identifier" && node["function"].text == "print"
        end

        # Whether this is `if __name__ == "__main__":`, in either order.
        def main_guard?(node)
          condition = node["condition"]
          operands = condition.named_children
          return false unless operands.size == 2 && condition.children.any? { |child| child.type == "==" }

          operands.map { |operand| operand_text(operand) }.to_set == %w[__main__ __name__].to_set
        end

        # The text of the name `__name__` or of a string (for main_guard?).
        def operand_text(operand)
          return operand.text if operand.type == "identifier"

          operand.type == "string" ? string_text(operand) : nil
        end

        def content_pieces(part, raw:, bytes:, into:)
          return add_piece(into, part.text.dup) || true if part.leaf?

          part.children.each do |piece|
            text =
              case piece.type
              when "fragment" then piece.text
              when "escape_sequence" then raw ? piece.text : decode(piece.text, bytes:)
              when "escape_interpolation" then piece.text[0]
              else return false
              end
            add_piece(into, text.dup)
          end
          true
        end

        # Adds a piece to a list of Strings and nodes, joining text that
        # follows text.
        def add_piece(pieces, piece)
          if piece.is_a?(String) && pieces.last.is_a?(String)
            pieces.last << piece
          else
            pieces << piece
          end
        end

        def wrap(pieces, bytes:)
          return literal(pieces.join).then { |value| bytes ? build(:bytes, value) : value } if pieces.all?(String)

          build(:fstring, *pieces.map { |piece| piece.is_a?(String) ? literal(piece) : piece })
        end

        # Decodes an escape. One not listed here keeps its source text, so two
        # different strings can never get the same value.
        def decode(escape, bytes: false)
          code = escape[1..]
          return ESCAPES.fetch(code, escape) if bytes

          case code
          when /\A([0-7]{1,3})\z/ then Regexp.last_match(1).to_i(8).chr(Encoding::UTF_8)
          when /\Ax([0-9a-fA-F]{2})\z/ then Regexp.last_match(1).to_i(16).chr(Encoding::UTF_8)
          when /\Au([0-9a-fA-F]{4})\z/, /\AU([0-9a-fA-F]{8})\z/
            value = Regexp.last_match(1).to_i(16)
            value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
          else ESCAPES.fetch(code, escape)
          end
        end

        def string_text(string)
          string.children.select { |part| part.type == "string_content" }.map { |part| part.leaf? ? part.text : "" }.join
        end

        # The value of a (non-template) string, as a literal. An f-string
        # keeps its substitutions, with each stretch of text as a literal. A
        # bytes string is wrapped, so it never equals a text string.
        def string_value(node)
          start = node.children.first
          return nil unless start&.type == "string_start" && node.children.last.type == "string_end"

          prefix = start.text.downcase.delete("\"'")
          return nil unless prefix.match?(/\A[rbfu]*\z/)

          raw = prefix.include?("r")
          bytes = prefix.include?("b")
          pieces = []
          node.children[1...-1].each do |part|
            case part.type
            when "interpolation" then pieces << part
            when "string_content" then content_pieces(part, raw:, bytes:, into: pieces) or return nil
            else return nil
            end
          end
          wrap(pieces, bytes:)
        end

        # "a" "b" is "ab", and f"a" "{b}" is f"a{b}".
        def join_strings(node)
          return nil unless node.children.all? { |part| %w[literal bytes fstring].include?(part.type) }

          bytes = node.children.first.type == "bytes"
          return nil unless node.children.all? { |part| (part.type == "bytes") == bytes }

          pieces = []
          node.children.each do |part|
            parts = %w[fstring bytes].include?(part.type) ? part.children : [part]
            parts.each { |piece| add_piece(pieces, piece.type == "literal" ? piece.text.dup : piece) }
          end
          wrap(pieces, bytes:)
        end

        # 2j, 2.0j and 2e0j are the same number.
        def imaginary_value(text)
          number = Float(text.delete("_").chomp("j").chomp("J"), exception: false)
          number&.finite? ? "#{number}j" : text.delete("_").downcase
        end

        IMPORTS = %w[import_statement import_from_statement].freeze

        # Removes the imports among a module's or block's statements, and
        # writes each name given with `as` as the name it stands for, in the
        # rest of the module or block. Returns whether anything changed.
        def drop_imports(scope)
          imports = scope.children.select { |child| IMPORTS.include?(child.type) }
          return false if imports.empty?

          aliases = {}
          imports.each do |statement|
            statement.each_descendant do |node|
              next unless node.type == "aliased_import" && node["alias"] && node["name"]

              parts = node["name"].children.select { |part| part.type == "identifier" }.map(&:text)
              aliases[node["alias"].text] = statement.type == "import_statement" ? parts : [parts.last]
            end
          end
          scope.children.reject! { |child| imports.include?(child) }
          expand_aliases(scope, aliases) unless aliases.empty?
          true
        end

        def expand_aliases(node, aliases)
          node.children.map! do |child|
            parts = aliases[child.text] if child.type == "identifier" && child.leaf? && child.field != "attribute"
            next expand_aliases(child, aliases) || child unless parts

            path = parts.drop(1).reduce(leaf(:identifier, parts.first)) do |object, part|
              build(:attribute, { object: }, token("."), { attribute: leaf(:identifier, part) })
            end
            path.tap { |expanded| expanded.field = child.field }
          end
          node
        end

        def integer_value(text)
          return imaginary_value(text) if text.match?(/[jJ]\z/)

          digits = text.delete("_").downcase
          return digits unless digits.match?(/\A(0x[0-9a-f]+|0o[0-7]+|0b[01]+|\d+)\z/)

          Integer(digits, exception: false)&.to_s || text
        end

        def float_value(text)
          return imaginary_value(text) if text.match?(/[jJ]\z/)

          number = Float(text.delete("_"), exception: false)
          number&.finite? ? number.to_s : text
        end
      end
    end
  end
end
