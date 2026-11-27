# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the helpers in this
# file.
# Ballerina's grammar only splits the code into tokens. Its tree is a flat
# list of keywords, names, literals, punctuation and templates, with no
# declarations or expressions. So this stage keeps every token, because the
# brackets are the only record of grouping, and finds the names that the
# solution defines from the tokens around them.
module Representer::Languages::Ballerina::Common
  class GenerateAST < Representer::Engine::GenerateAST
    DEFINING_KEYWORDS = {
      "function" => :function_name,
      "type" => :type_name,
      "class" => :type_name,
      "enum" => :type_name
    }.freeze
    DECLARATION_ENDS = ["=", ";", ",", ")", "in"].freeze
    MEMBER_ACCESSES = [".", "->"].freeze
    RECORD_OPENERS = ["{", "{|"].freeze
    RECORD_CLOSERS = ["}", "|}"].freeze
    TYPE_SUFFIXES = ["d", "D", "f", "F"].freeze

    def call
      tree.tap do
        write_quoted_names_as_plain_names!
        write_template_text_as_values!
        write_floats_as_their_values!
        wrap_defined_names!
      end
    end

    private
    ### Values ###

    # Write a quoted name as the plain name, because the quote only lets a
    # name be a keyword.
    # 'limit  ->  limit
    def write_quoted_names_as_plain_names!
      transform(tree, "(quoted_identifier) @name") { |match| leaf(:identifier, match.node.text.delete_prefix("'")) }
    end

    # Turn the text of each template into its value, as a string's is, and
    # keep its interpolations.
    # `Hello, ${name}!`  ->  (template_literal "Hello, " (interpolation name) "!")
    def write_template_text_as_values!
      transform(tree, "(template_text) @text") { |match| literal(match.node.text) }
    end

    # Write each float as its value. Keep the digits of a float with a type
    # suffix, such as the decimal `1.50d`.
    # 1.50  ->  1.5
    def write_floats_as_their_values!
      tree.children.each_with_index do |token, index|
        write_float(token) unless type_suffix?(tree.children[index + 1])
      end
    end

    def write_float(token)
      return unless token.type == "float_literal" && token.leaf?

      value = Representer::Engine::Numbers.decimal(token.text, separator: "")
      token.text = Representer::Engine::Numbers.write_decimal(value) if value
    end

    def type_suffix?(token) = token&.type == "identifier" && TYPE_SUFFIXES.include?(token.text)

    ### Names ###

    # Wrap each name that the solution defines in a node that says what it
    # defines, so that representation.rb can list them. The tokens around a
    # name show whether the solution defines it:
    #
    # - A name after `function`, `type`, `class` or `enum`. A resource
    #   function's names stay, because they are part of its URL and HTTP
    #   method.
    # - A name after a type (`int total`, `Person p`, `int[] xs`) and before
    #   one of `=`, `;`, `,`, `)` or `in`, outside a record's body. A
    #   record's fields stay, because they are names in the data that the
    #   code reads and writes.
    # - A parameter of a lambda without types, such as `(a, b) => a + b`.
    #
    # A name after `.` or `->` is a member of another value, so it defines
    # nothing.
    #
    # function add(int x)  ->  function (function_name add) ( int (variable x) )
    def wrap_defined_names!
      @tokens = tree.children
      @texts = @tokens.map { |token| text_of(token) }
      @kinds = Array.new(@tokens.size)
      @in_record = record_bodies
      @tokens.each_index { |index| @kinds[index] = name_kind(index) if @tokens[index].type == "identifier" }
      lambda_parameters.each { |index| @kinds[index] = :variable }

      tree.children = @tokens.each_with_index.map do |token, index|
        [nil, :member].include?(@kinds[index]) ? token : build(@kinds[index], token)
      end
    end

    # Return what the name at this index defines, :member, or nil.
    def name_kind(index)
      previous = index.zero? ? nil : @texts[index - 1]
      return :member if MEMBER_ACCESSES.include?(previous)
      return nil if @in_record[index]
      return defined_by_keyword(index) if DEFINING_KEYWORDS.key?(previous)

      :variable if declaration?(index)
    end

    # A function's name comes before its `(`, and a resource function's names
    # come after `resource function`.
    def defined_by_keyword(index)
      previous = @texts[index - 1]
      return DEFINING_KEYWORDS[previous] unless previous == "function"
      return nil if index >= 2 && @texts[index - 2] == "resource"

      @texts[index + 1] == "(" ? :function_name : nil
    end

    # A declaration is a type (a type keyword, an array type's `]` or a name
    # that defines nothing) and then the name, and then one of the tokens
    # that can end a declaration.
    def declaration?(index)
      return false if index.zero? || !DECLARATION_ENDS.include?(@texts[index + 1])

      before = @tokens[index - 1]
      before.type == "type_keyword" || @texts[index - 1] == "]" || plain_name?(index - 1)
    end

    def plain_name?(index) = @tokens[index].type == "identifier" && @kinds[index].nil?

    # Return whether each token is inside the body of a `record { ... }`.
    def record_bodies
      inside = {}
      @texts.each_with_index do |text, index|
        next unless text == "record" && RECORD_OPENERS.include?(@texts[index + 1])

        depth = 0
        (index + 1...@texts.size).each do |position|
          depth += 1 if RECORD_OPENERS.include?(@texts[position])
          depth -= 1 if RECORD_CLOSERS.include?(@texts[position])
          inside[position] = true
          break if depth.zero?
        end
      end
      inside
    end

    # Return the indexes of the untyped parameters of each lambda: the names
    # in `x => ...` and in `(x, y) => ...`.
    def lambda_parameters
      @texts.each_index.select { |index| @texts[index] == "=>" && index.positive? }.flat_map do |arrow|
        next [arrow - 1] if plain_name?(arrow - 1)
        next [] unless @texts[arrow - 1] == ")"

        opener = (arrow - 2).downto(0).find { |position| @texts[position] == "(" } || -1
        ((opener + 1)...(arrow - 1)).select { |inner| plain_name?(inner) && [",", "("].include?(@texts[inner - 1]) }
      end
    end
  end
end
