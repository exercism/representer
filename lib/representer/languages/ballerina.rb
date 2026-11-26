module Representer
  module Languages
    # Ballerina has no old representer, so there are no upstream tests to
    # port. The grammar is David-Stephenson/tree-sitter-ballerina (MIT). It is
    # only a tokeniser: its tree is a flat list of keywords, identifiers,
    # literals and punctuation, with no declarations or expressions. So this
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
    #
    # The grammar can't read quoted identifiers (`'limit`) or string
    # templates (`re `...``), so a solution that uses one gets no
    # representation.
    class Ballerina < Language
      tracks "ballerina"
      version 2
      grammar "ballerina"
      extensions ".bal"

      # `identifier` is any name. The rules below retype the names that the
      # solution defines as `local` (a variable or parameter) or `defined`
      # (a function, type or class), and the names after a dot as `member`.
      names :identifier, :local, :defined, :member

      ### Drop ###

      drop "[(line_comment) (doc_comment)]"

      ### Rewrite ###

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
