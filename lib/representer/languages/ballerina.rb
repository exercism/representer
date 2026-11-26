# What this class does to a Ballerina solution's code to make its representation:
#
# - Reads the code as a flat list of tokens, because the grammar has no tree
#   for declarations or expressions.
# - Drops comments and doc comments, and every `import` statement.
# - Keeps all punctuation, because without a tree the brackets are the only
#   record of grouping.
# - Reads a quoted name (`'limit`) as the plain name (`limit`).
# - Writes the text of a backtick template as its value, like a string, and
#   keeps its interpolations.
# - Writes each float in one form (`1.50` is `1.5`), but keeps a decimal's
#   digits (`1.50d`).
# - Finds the names that the solution defines from the tokens around them:
#   after `function`, `type`, `class` or `enum`, after a type in a
#   declaration, and the parameters of a lambda.
# - Keeps the fields of a record and the names in a resource function's
#   path, and treats a name after `.` or `->` as a member.
# - Replaces each name that the solution defines with a placeholder
#   (PLACEHOLDER_1, PLACEHOLDER_2 and so on).
# - Keeps every name used in the tests, `main`, `init` and the HTTP method
#   names.
#
# Update this list whenever the class's rules change.

module Representer
  module Languages
    # Ballerina has no old representer, so there are no upstream tests to
    # port. The grammar is Exercism's fork of
    # David-Stephenson/tree-sitter-ballerina (MIT), which adds quoted
    # identifiers and backtick templates. It is only a tokeniser: its tree is
    # a flat list of keywords, identifiers, literals, punctuation and
    # templates, with no declarations or expressions. So this
    # class works on that list. It removes comments, keeps all punctuation
    # (without a tree, brackets are the only record of grouping), and renames
    # the names that tokens before and after show to be defined by the
    # solution:
    #
    # - A name after `function`, `type`, `class` or `enum`.
    # - A name after a type (`int total`, `Person p`, `int[] xs`) and before
    #   one of `=`, `;`, `,`, `)` or `in`, as long as it isn't in a `record`
    #   body. A record's fields are names in the data that the code reads and
    #   writes, so they keep their names.
    # - The parameters of a lambda such as `(a, b) => a + b`.
    #
    # A name after `.` or `->` is a member of some other value.
    class Ballerina < Language
      tracks "ballerina"
      version 3
      grammar "ballerina"
      extensions ".bal"

      # `identifier` is any name. The rules below retype the names that the
      # solution defines as `local` (a variable or parameter) or `defined`
      # (a function, type or class), and the names after a dot as `member`.
      names :identifier, :local, :defined, :member

      ### Drop ###

      drop "[(line_comment) (doc_comment)]"

      ### Rewrite ###

      # `'limit` is the name `limit`: the quote only lets a name be a
      # keyword.
      rewrite("(quoted_identifier) @name") { |match| leaf(:identifier, match.node.text.delete_prefix("'")) }

      # The text of a template (`` `Hello, ${name}!` ``) is its value, like
      # a string's.
      rewrite("(template_text) @text") { |match| literal(match.node.text) }

      # Imports only make names available, so the tokens from `import` to
      # its `;` go. A float is its value: `1.50` is `1.5`. A decimal
      # (`1.50d`) keeps its digits.
      rewrite("(source_file) @file") do |match|
        Ballerina.drop_imports(match.node) | Ballerina.normalise_floats(match.node) ? match.node : nil
      end

      rewrite("(source_file) @file") { |match| Ballerina.classify_names(match.node) ? match.node : nil }

      ### Rename and keep ###

      rename "(local) @name"
      rename_member "(defined) @name"
      member "(member) @name"

      keep "main", "init", "get", "post", "put", "delete", "patch", "head", "options"

      DEFINERS = %w[function type class enum].freeze
      DECLARATION_ENDS = ["=", ";", ",", ")", "in"].freeze
      OPENERS = ["{", "{|"].freeze
      CLOSERS = ["}", "|}"].freeze

      class << self
        # Removes each `import a/b;`. Returns whether any went.
        def drop_imports(file)
          tokens = file.children
          kept = []
          skipping = false
          tokens.each do |token|
            text = text_of(token)
            skipping = true if token.type == "keyword" && text == "import"
            kept << token unless skipping
            skipping = false if skipping && token.type == "punctuation" && text == ";"
          end
          return false if kept.size == tokens.size

          file.children = kept
          true
        end

        # Writes each float in one form. Returns whether any changed.
        def normalise_floats(file)
          changed = false
          file.children.each_with_index do |token, index|
            next unless token.type == "float_literal" && token.leaf?

            suffix = file.children[index + 1]
            next if suffix&.type == "identifier" && suffix.text.match?(/\A[dDfF]\z/)

            value = Engine::Numbers.decimal(token.text, separator: "")
            text = value && Engine::Numbers.write_decimal(value)
            next if text.nil? || text == token.text

            token.text = text
            changed = true
          end
          changed
        end

        # Gives each identifier in the file's token list the type that
        # shows what it is. Returns whether any changed.
        def classify_names(file)
          tokens = file.children
          texts = tokens.map { |token| text_of(token) }
          in_record = record_bodies(texts)
          changed = false

          tokens.each_with_index do |token, index|
            next unless token.type == "identifier"

            previous = index.zero? ? nil : texts[index - 1]
            if %w[. ->].include?(previous) then type = "member"
            elsif in_record[index] then type = nil
            elsif DEFINERS.include?(previous) then type = defined_type(texts, index)
            elsif declaration?(tokens, texts, index) then type = "local"
            end
            next unless type

            token.type = type
            changed = true
          end

          lambda_parameters(tokens, texts).each do |token|
            token.type = "local"
            changed = true
          end
          changed
        end

        private
        # The text of a token: a leaf's own text, or the text of the one
        # anonymous token inside a keyword or punctuation node.
        def text_of(token) = token.leaf? ? token.text : token.children.first&.text

        # A function after `function`, unless it is a resource function
        # (`resource function get name(...)`), whose names are part of its
        # URL and HTTP method. A type, class or enum after its keyword.
        def defined_type(texts, index)
          previous = texts[index - 1]
          return "defined" unless previous == "function"
          return nil if index >= 2 && texts[index - 2] == "resource"

          texts[index + 1] == "(" ? "defined" : nil
        end

        # Is this the name of a variable, parameter or field: a type (a type
        # keyword, `]` after an array type, or another name) and then a name,
        # and then one of the tokens that can follow a declaration?
        def declaration?(tokens, texts, index)
          return false unless DECLARATION_ENDS.include?(texts[index + 1])

          before = tokens[index - 1]
          return false if index.zero?

          %w[type_keyword identifier].include?(before.type) || texts[index - 1] == "]"
        end

        # The marks for each token that is inside a `record { ... }` body.
        def record_bodies(texts)
          inside = {}
          texts.each_with_index do |text, index|
            next unless text == "record" && OPENERS.include?(texts[index + 1])

            depth = 0
            (index + 1...texts.size).each do |position|
              depth += 1 if OPENERS.include?(texts[position])
              depth -= 1 if CLOSERS.include?(texts[position])
              inside[position] = true
              break if depth.zero?
            end
          end
          inside
        end

        # The untyped parameters of a lambda: the names in `x => ...` and in
        # `(x, y) => ...`.
        def lambda_parameters(tokens, texts)
          found = []
          texts.each_with_index do |text, index|
            next unless text == "=>" && index.positive?

            if tokens[index - 1].type == "identifier"
              found << tokens[index - 1]
            elsif texts[index - 1] == ")"
              position = index - 2
              position -= 1 while position >= 0 && texts[position] != "("
              ((position + 1)...(index - 1)).each do |inner|
                next unless tokens[inner].type == "identifier" && [",", "("].include?(texts[inner - 1])

                found << tokens[inner]
              end
            end
          end
          found
        end
      end
    end
  end
end
