module Representer
  module Languages
    class Ruby < Language
      tracks "ruby"
      version 2
      grammar "ruby"
      extensions ".rb"

      names :identifier, :constant, :instance_variable, :class_variable, :global_variable, simple_symbol: ":"

      ### Drop ###

      drop "(comment)"

      # The node types already say what these tokens say.
      drop_tokens "(", ")", "[", "]", "{", "}", ",", ";", "\n", "|", "=>", ":", ".", "\#{",
        "def", "class", "module", "if", "unless", "while", "until", "then", "do", "end", "begin", "return"

      # `def foo()` is `def foo`.
      drop "(method_parameters)", where: ->(match) { match.node.children.empty? }

      ### Rewrite ###

      # `do ... end` and `{ ... }` blocks are the same.
      retype do_block: :block, block_body: :body_statement

      # (x) is x.
      unwrap :parenthesized_statements

      # `and`, `or` and `not` only differ from `&&`, `||` and `!` in
      # precedence, which the tree's shape already shows.
      { "and" => "&&", "or" => "||", "not" => "!" }.each do |word, symbol|
        rewrite("[(binary operator: \"#{word}\" @operator) (unary operator: \"#{word}\" @operator)]") do |match|
          match[:operator].type = symbol
          match.node
        end
      end

      # A modifier is the same as the block form: `x if y` is `if y then x end`.
      rewrite "(if_modifier body: (_) @body condition: (_) @condition)",
        "(if condition: @condition consequence: (then @body))"
      rewrite "(unless_modifier body: (_) @body condition: (_) @condition)",
        "(unless condition: @condition consequence: (then @body))"

      # `begin ... end while x` runs the body before the first check, so only
      # other modifier loops are the same as the block form.
      rewrite "(while_modifier body: (_) @body condition: (_) @condition)",
        "(while condition: @condition body: (do @body))",
        where: ->(match) { match[:body].type != "begin" }
      rewrite "(until_modifier body: (_) @body condition: (_) @condition)",
        "(until condition: @condition body: (do @body))",
        where: ->(match) { match[:body].type != "begin" }

      # An endless method (`def foo = x`) is the same as `def foo; x; end`.
      rewrite "[(method \"=\" @equals body: (_) @body) (singleton_method \"=\" @equals body: (_) @body)]" do |match|
        match.node.children.delete(match[:equals])
        match.node.replace_child(match[:body], build(:body_statement, match[:body]))
        match.node
      end

      # `{a: 1}` is `{:a => 1}`.
      rewrite("(hash_key_symbol) @key") { |match| leaf(:simple_symbol, ":#{match[:key].text}") }

      # A string is its value: 'a', "a" and %q(a) are the same. Strings with
      # interpolation keep their structure, with each literal part as one value.
      # The rule only matches strings that still have their quotes, so it
      # doesn't match its own output.
      rewrite '(string "\"" @quote)' do |match|
        parts = match.node.children.select(&:named?)
        next nil if parts.any? { |part| %w[string_content escape_sequence interpolation].none?(part.type) }

        pieces = Ruby.string_parts(parts, single_quoted: match[:quote].text.start_with?("'", "%q"))
        next literal(pieces.first || "") if pieces.size <= 1 && !pieces.first.is_a?(Engine::Node)

        build(:string, *pieces.map { |piece| piece.is_a?(String) ? literal(piece) : piece })
      end

      ### Rename and keep ###

      # Local variables and parameters.
      rename "[(method_parameters (identifier)* @name) (block_parameters (identifier)* @name)]"
      rename "(lambda_parameters (identifier)* @name)"
      rename "[(optional_parameter name: (_) @name) (splat_parameter name: (_) @name)]"
      rename "[(hash_splat_parameter name: (_) @name) (block_parameter name: (_) @name)]"
      rename "(destructured_parameter (identifier)* @name)"
      rename "[(assignment left: (identifier) @name) (operator_assignment left: (identifier) @name)]"
      rename "[(left_assignment_list (identifier)* @name) (rest_assignment (identifier) @name)]"
      rename "[(for pattern: (identifier) @name) (exception_variable (identifier) @name)]"
      rename "[(instance_variable) @name (class_variable) @name (global_variable) @name]"

      # Methods, classes, modules and constants.
      rename_member "[(method name: (_) @name) (singleton_method name: (_) @name)]"
      rename_member "[(class name: (constant) @name) (module name: (constant) @name)]"
      rename_member "(class name: (scope_resolution name: (constant) @name))"
      rename_member "(module name: (scope_resolution name: (constant) @name))"
      rename_member "[(assignment left: (constant) @name) (operator_assignment left: (constant) @name)]"

      # attr_reader :name (and attr_writer and attr_accessor) define methods.
      rename_member <<~'PATTERN'
        (call !receiver
          method: (identifier /\Aattr_(reader|writer|accessor)\z/)
          arguments: (argument_list (simple_symbol)* @name))
      PATTERN

      # Names after a dot or ::, or in `&:name`, refer to some object's method.
      member "(call receiver: (_) method: (_) @name)"
      member "(scope_resolution scope: (_) name: (_) @name)"

      # Callers pass keyword arguments by name.
      keep "(keyword_parameter name: (identifier) @name)"

      # Methods that Ruby itself calls.
      keep "initialize", "initialize_copy", "to_s", "to_str", "inspect", "to_a", "to_ary", "to_h", "to_hash",
        "to_i", "to_int", "to_f", "to_proc", "to_sym", "each", "<=>", "==", "eql?", "hash", "call", "coerce",
        "method_missing", "respond_to_missing?", "included", "extended", "inherited", "prepended", "succ"

      library_names File.join(__dir__, "library_names", "ruby.txt")

      ESCAPES = {
        "n" => "\n", "t" => "\t", "s" => " ", "r" => "\r", "0" => "\0", "e" => "\e",
        "a" => "\a", "b" => "\b", "f" => "\f", "v" => "\v"
      }.freeze

      # Joins a string's literal parts into values, decoding escapes, and keeps
      # interpolations as they are. Returns a list of Strings and nodes.
      def self.string_parts(parts, single_quoted:)
        parts.each_with_object([]) do |part, pieces|
          if part.type == "interpolation"
            pieces << part
            next
          end

          text = single_quoted ? part.text.gsub(/\\([\\'])/, '\1') : decode(part)
          pieces.last.is_a?(String) ? pieces.last << text : pieces << text.dup
        end
      end

      # Decodes a double-quoted escape. An escape not listed here keeps its
      # source text, so two different strings can never get the same value.
      def self.decode(part)
        return part.text unless part.type == "escape_sequence"

        code = part.text[1..]
        case code
        when /\Au\{([0-9a-fA-F ]+)\}\z/ then Regexp.last_match(1).split.map { |hex| hex.to_i(16) }.pack("U*")
        when /\Au([0-9a-fA-F]{4})\z/ then [Regexp.last_match(1).to_i(16)].pack("U")
        when /\Ax([0-7][0-9a-fA-F]?)\z/ then Regexp.last_match(1).to_i(16).chr(Encoding::UTF_8)
        when /\A[\\"'#]\z/ then code
        else ESCAPES.fetch(code, part.text)
        end
      end
    end
  end
end
