# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. YAMLScript compiles each
# mapping pair, call and list to a Clojure form, so this stage writes all
# three as the same `call`, as the YAMLScript compiler does.
module Inspector::Languages::YAMLScript::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the brackets, colons and marks, because the node types already
    # show them. Keep `-[`, `+[`, `-{` and `+{`, which differ from `[` and `{`.
    # f(x)  ->  (call f x)
    # x.y  ->  (member_expression x y)
    strip_tokens "(", ")", "[", "]", "{", "}", ":", "::", ".", "\\(", "\\{", "\\'", "*", "$"
    strip_tokens "?", only_in: :explicit_pair
    strip_tokens "-", only_in: :sequence_item

    # Write each number as its value. The compiler passes an integer to
    # Clojure as it is written, and Clojure reads a leading 0 as octal.
    # 017  ->  15
    # 0.90  ->  0.9
    # 1e3  ->  1000.0
    numbers_are integer: :number,
                decimal: :number,
                prefixes: { "0" => 8 }

    ESCAPES = { "\\\\" => "\\", '\\"' => '"', "\\n" => "\n", "\\t" => "\t" }.freeze

    # The compiler reads the mapping below `cond`, and below each of these
    # keys with more words after it, as clauses.
    CLAUSE_FORMS = ["case", "condp", "condf"].freeze

    # The compiler groups the words after each of these keys into one test.
    TEST_FORMS = ["if", "if-not", "when", "when-not", "while"].freeze

    # The compiler groups the words after each of these keys into one
    # vector of bindings.
    BINDING_FORMS = ["binding", "doseq", "dotimes", "each", "for", "if-let", "if-lets", "if-some", "let", "loop",
                     "when-first", "when-let", "when-lets", "when-some", "with-open"].freeze

    POSTFIX_FUNCTIONS = { ".#" => "count", ".?" => "truey?", ".!" => "falsey?", ".++" => "inc", ".--" => "dec",
                          ".@" => "deref" }.freeze

    def call
      tree.tap do
        drop_the_version_tag!
        write_strings_as_their_values!
        write_mapping_pairs_as_calls!
        write_postfix_operators_and_colon_calls_as_method_calls!
        write_each_chain_of_one_operator_as_one_expression!
        write_calls_and_lists_as_calls!
        mark_the_names_each_binding_defines!
      end
    end

    private
    # Drop the tag that starts the file, because `!YS-v0` and
    # `!yamlscript/v0` both turn on code mode for version 0.
    # !YS-v0  ->
    def drop_the_version_tag!
      tree.children.reject! { |child| child.type == "tag" }
    end

    ### Strings ###

    # Turn each string into its value, and read the escapes `\\`, `\"`, `\n`
    # and `\t`. A double-quoted string with `$name`, `${...}` or `$(...)` in
    # it interpolates, so it keeps its text in a node of its own. A string
    # with another escape, or with a `-` or `+` in front, keeps its text.
    #
    # 'It''s'  ->  "It's"
    # "a\nb"  ->  the string with a real line break
    # "One for $name"  ->  (interpolated_string "One for $name")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") { |match| string_value(match.node.text) }
    end

    def string_value(text)
      return if text.match?(/\A[-+]/)

      inner = text[1...-1]
      return literal(inner.gsub("''", "'")) if text.start_with?("'")
      return build(:interpolated_string, literal(inner)) if inner.match?(/\$[{(a-zA-Z]/)
      return if inner.gsub(/\\[\\"nt]/, "").include?("\\")

      literal(inner.gsub(/\\[\\"nt]/, ESCAPES))
    end

    ### Mapping pairs ###

    # Write the code in each mapping as the forms that the compiler gives.
    # A pair is a call of its key's words and its value's words, and a
    # mapping below a key gives one more argument for each of its pairs.
    # A key of `=>` gives only its value.
    #
    # die: 'too big'  ->  (call die "too big")
    # pow 2: n - 1  ->  (call pow 2 (binary_expression n - 1))
    # =>: x  ->  x
    #
    # e.g. We convert:
    #   when x:
    #     say: 'a'
    #     say: 'b'
    # internally into:
    #   (call when x (call say "a") (call say "b"))
    def write_mapping_pairs_as_calls!
      tree.children.map! { |child| child.type == "block_mapping" ? mapping_forms(child) : child }.flatten!
    end

    def mapping_forms(mapping) = mapping.named_children.flat_map { |entry| entry_forms(entry) }

    def entry_forms(entry)
      return [entry] if data?(entry)

      case entry.type
      when "pair", "explicit_pair" then pair_forms(entry)
      when "assignment" then [assignment(entry)]
      when "function_definition" then [function_definition(entry)]
      when "anonymous_function_definition" then [build(:anonymous_function_definition, entry[:parameters], *body(entry))]
      else [entry]
      end
    end

    # After `::`, the value is data, so its plain words are strings and its
    # mappings stay mappings.
    def data?(entry) = entry.children.any? { |child| !child.named? && child.text == "::" }

    def values(entry, field) = entry.children.select { |child| child.field == field }

    def body(entry) = value_forms(values(entry, "body"))

    def value_forms(values)
      values.flat_map do |value|
        contents = value.type == "block" ? value.named_children : [value]
        contents.flat_map { |child| child.type == "block_mapping" ? mapping_forms(child) : [child] }
      end
    end

    # Return the mapping below a key, written on the lines below it or, after
    # `?`, on the same line.
    def mapping_of(values)
      return unless values.one?

      value = values.first.type == "block" ? values.first.named_children.first : values.first
      value if value&.type == "block_mapping"
    end

    # x =: 1  ->  (assignment x = 1)
    def assignment(entry)
      build(:assignment, *values(entry, "left").map { |left| { left: } }, entry[:operator],
            *value_forms(values(entry, "right")))
    end

    # defn f(x): x  ->  (function_definition defn f (parameters x) x)
    def function_definition(entry)
      keyword = entry.children.find { |child| child.field == "keyword" }
      build(:function_definition, keyword, { name: entry[:name] }, entry[:parameters], *body(entry))
    end

    def pair_forms(pair)
      words = pair[:key].named_children
      forms = argument_forms(words, values(pair, "value"))
      return forms if words.empty?

      operator_pair(words, forms) || chained_pair(words, forms) || underscore_pair(words, forms) ||
        [build(:call, *key_words(words), *forms)]
    end

    # Write a key that ends with an operator as the operator between the key
    # and the value.
    # a ||: b  ->  (binary_expression a || b)
    def operator_pair(words, values)
      partial = words.last
      return unless words.one? && values.one? && partial.type == "binary_expression" && !partial[:right]

      [build(:binary_expression, *partial.children, { right: values.first })]
    end

    # Write a value that starts with a method call as a call on the key.
    # uc(s): .split()  ->  uc(s).split()
    def chained_pair(words, values)
      return unless words.one? && values.one?

      node = values.first
      node = node.named_children.first until node.nil? || leading_member?(node)
      return unless node

      node.children.unshift(words.first.tap { |word| word.field = "object" })
      values
    end

    def leading_member?(node) = node.type == "member_expression" && !node[:object]

    # Write a value as the argument in the place of each `_` in the key.
    # filter _ xs: odd?  ->  (call filter odd? xs)
    def underscore_pair(words, values)
      return unless values.one? && words.size > 1 && words.first.type == "identifier" && words.any? { |word| underscore?(word) }

      [build(:call, *words.map { |word| underscore?(word) ? copy(values.first) : word })]
    end

    def underscore?(word) = word.type == "identifier" && word.text == "_"

    # Group the words after `if`, `when` and similar keys into one test, and
    # the words after `let`, `loop`, `for` and similar keys into one vector of
    # bindings.
    # when a b c:  ->  (call when (call a b c) ...)
    # loop i 0 acc []:  ->  (call loop (vector i 0 acc (vector)) ...)
    def key_words(words)
      head, *rest = words
      return words unless head.type == "identifier"

      if TEST_FORMS.include?(head.text) && rest.size > 2 then [head, build(:call, *rest)]
      elsif BINDING_FORMS.include?(head.text) && rest.size != 1 then [head, build(:vector, *rest)]
      else words
      end
    end

    def argument_forms(words, values)
      head = words.first
      mapping = mapping_of(values)
      return value_forms(values) unless head&.type == "identifier" && mapping

      if clauses?(words) then clauses(head.text, mapping)
      elsif ["if", "if-not"].include?(head.text) then branches(mapping)
      else value_forms(values)
      end
    end

    def clauses?(words) = words.one? ? words.first.text == "cond" : CLAUSE_FORMS.include?(words.first.text)

    # Write each clause of `cond`, `case`, `condp` and `condf` as its test and
    # its result, with `do` around a side that holds several forms. A last
    # test of `else` or `=>` is the default.
    #
    # e.g. We convert:
    #   cond:
    #     a: 'x'
    #     else: 'y'
    # internally into:
    #   (call cond a "x" :else "y")
    def clauses(head, mapping)
      entries = mapping.named_children
      entries.each_with_index.flat_map do |entry, index|
        next entry_forms(entry) unless ["pair", "explicit_pair"].include?(entry.type) && !data?(entry)

        test = entry[:key].named_children
        test = [default(head)] if index == entries.size - 1 && default_test?(test)
        [one_form(test), one_form(value_forms(values(entry, "value")))]
      end
    end

    def default_test?(words) = words.empty? || (words.one? && words.first.type == "identifier" && words.first.text == "else")

    def default(head) = head == "cond" ? leaf(:keyword, ":else") : leaf(:identifier, "=>")

    def one_form(forms) = forms.one? ? forms.first : build(:call, leaf(:identifier, "do"), *forms)

    # Write the `then` and `else` of an `if` as their forms, with `do` around
    # one that holds several forms.
    # if a:\n  then: x\n  else: y  ->  (call if a x y)
    def branches(mapping)
      mapping.named_children.flat_map do |entry|
        words = entry.type == "pair" && !data?(entry) ? entry[:key].named_children : []
        next entry_forms(entry) unless words.one? && words.first.type == "identifier" && ["then", "else"].include?(words.first.text)

        [one_form(value_forms(values(entry, "value")))]
      end
    end

    ### Calls ###

    # Write each postfix operator and each `:` call as the method call it
    # stands for.
    # x.#  ->  x.count()
    # x.++  ->  x.inc()
    # x:f  ->  x.f()
    def write_postfix_operators_and_colon_calls_as_method_calls!
      transform(tree, "(postfix_expression) @postfix") do |match|
        operator = match.node[:operator].text
        method_call(match.node[:operand], leaf(:identifier, POSTFIX_FUNCTIONS.fetch(operator))) if POSTFIX_FUNCTIONS.key?(operator)
      end
      transform(tree, "(chain_call) @chain") { |match| method_call(match.node[:object], match.node[:function]) }
    end

    def method_call(object, function) = build(:call, build(:member_expression, { object: }, token("."), { property: function }))

    # Write a chain of one operator as one expression, as the compiler does.
    # Brackets keep their own expression.
    # 1 <= x <= 64  ->  (binary_expression 1 <= x <= 64)
    # (a + b) + c  ->  (binary_expression (binary_expression a + b) + c)
    def write_each_chain_of_one_operator_as_one_expression!
      transform(tree, "(binary_expression) @chain") do |match|
        left = match.node[:left]
        next unless left&.type == "binary_expression" && left[:operator].text == match.node[:operator].text

        build(:binary_expression, *left.children, *match.node.children.reject { |child| child.field == "left" })
      end
    end

    # Write a call and a list as the same call, and unwrap brackets that only
    # group an operator expression.
    # f(a b)  ->  (call f a b)
    # (f a b)  ->  (call f a b)
    # (+ a b)  ->  (call + a b)
    # (a + b)  ->  (binary_expression a + b)
    def write_calls_and_lists_as_calls!
      transform(tree, "(call function: (_) arguments: (arguments)) @call") do |match|
        build(:call, match.node[:function], *match.node[:arguments].named_children)
      end
      transform(tree, "(parenthesized_expression) @list") do |match|
        items = match.node.named_children
        next items.first if items.one? && items.first.type == "binary_expression"

        build(:call, *items)
      end
    end

    ### Names ###

    # Mark the names that a vector of parameters or bindings defines: every
    # second item of the bindings of `let`, `loop`, `for` and similar forms,
    # the items of a vector that takes a value apart, and the name after `*`
    # in parameters.
    # loop «i» 0 «acc» []: ...
    # [«a» «b»] =: pair
    # defn f(«first» *«rest»): ...
    def mark_the_names_each_binding_defines!
      each_node(tree) do |node, _|
        case node.type
        when "call"
          head, bindings = node.children
          mark_bindings!(bindings) if head&.type == "identifier" && BINDING_FORMS.include?(head.text) && bindings&.type == "vector"
          mark_parameters!(bindings) if head&.type == "identifier" && head.text == "fn" && bindings&.type == "vector"
        when "parameters" then mark_parameters!(node)
        when "assignment" then node.children.each { |child| mark_pattern!(child) if child.field == "left" }
        end
      end
    end

    def mark_bindings!(bindings)
      bindings.type = "bindings"
      bindings.named_children.each_slice(2) { |name, _| name.field = "name" if mark_pattern!(name).type == "identifier" }
    end

    def mark_parameters!(parameters)
      parameters.type = "parameters"
      parameters.named_children.each { |parameter| mark_pattern!(parameter) }
    end

    def mark_pattern!(node)
      case node.type
      when "vector" then node.type = "vector_pattern"
      when "splat" then node.type = "rest_parameter"
      end
      node.named_children.each { |child| mark_pattern!(child) } if node.type == "vector_pattern"
      node
    end
  end
end
