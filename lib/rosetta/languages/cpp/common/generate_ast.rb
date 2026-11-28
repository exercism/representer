# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, which gives one form to the spellings that a C++ compiler
# reads as one.
module Rosetta::Languages::Cpp::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if (x) { return y; }  ->  (if_statement (condition_clause x) (compound_statement (return_statement y)))
    strip_tokens "return", "if", "else", "while", "for", "do", "switch", "namespace", "class", "struct", "enum", "union",
                 "using", "template", "typedef", "break", "continue", "goto", "try", "catch", "throw", "new", "delete",
                 "sizeof", "static_assert"

    # Strip the brackets, commas and other punctuation, because they are layout.
    # f(a, b);  ->  (call_expression f (argument_list a b))
    strip_tokens "(", ")", "{", "}", "[", "]", ";", ",", "::"

    # Strip `typename` from a template parameter, because `class` means the
    # same there and is stripped too.
    # template <typename T>  ->  template <T>
    strip_tokens "typename", only_in: :type_parameter_declaration

    # Keep these tokens in the nodes listed, because they are the only thing
    # that tells two programs apart there.
    # delete[] p and delete p, ::delete p and delete p, ::new int and new int
    # enum class E and enum E, friend class B and friend struct B
    # using namespace A and using A, using enum E and using E
    # for (;; i++) and for (i++;;)
    # operator() and operator[], operator new and operator delete
    keep_tokens "[", "]", "::", in: :delete_expression
    keep_tokens "::", in: :new_expression
    keep_tokens "class", "struct", in: :enum_specifier
    keep_tokens "class", "struct", "union", in: :friend_declaration
    keep_tokens "namespace", "enum", in: [:using_declaration, :class_using_declaration]
    keep_tokens ";", in: :for_statement
    keep_tokens "(", ")", "[", "]", ",", "new", "delete", in: :operator_name

    OPERATOR_WORDS = {
      "and" => "&&",
      "or" => "||",
      "not" => "!",
      "not_eq" => "!=",
      "bitand" => "&",
      "bitor" => "|",
      "xor" => "^",
      "compl" => "~",
      "and_eq" => "&=",
      "or_eq" => "|=",
      "xor_eq" => "^="
    }.freeze

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\a' => "\a",
      '\b' => "\b",
      '\f' => "\f",
      '\v' => "\v",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'",
      '\?' => "?"
    }.freeze

    INT = (0...(2**31))

    def call
      tree.tap do
        write_numbers_as_their_values!
        write_strings_as_their_values!
        write_operator_words_as_symbols!
        put_the_else_branch_in_the_if!
        give_each_name_of_a_declaration_with_several_its_own_declarator!
        write_the_scopes_of_a_function_name_before_the_name!
        give_a_using_declaration_in_a_class_its_own_type!
      end
    end

    private
    ### Values ###

    # Write each number as its value. A leading 0 means octal. An integer
    # only changes if it fits in an int, because the type of a larger one
    # depends on how it is written: 0xFFFFFFFF is an unsigned int, and
    # 4294967295 is a long. A number with a suffix keeps its text.
    #
    # 1'000  ->  1000
    # 0x1F  ->  31
    # 017  ->  15
    # 1.50  ->  1.5
    def write_numbers_as_their_values!
      each_node(tree) do |node, _|
        next unless node.type == "number_literal"

        value = number(node.text.delete("'"))
        node.text = value if value
      end
    end

    def number(text)
      text = "0o#{text[1..]}" if text.match?(/\A0\d/)
      value = Rosetta::Engine::Numbers.integer(text, separator: "")
      return INT.cover?(value) ? value.to_s : nil if value
      return nil if text.match?(/\A0[xb]/i)

      value = Rosetta::Engine::Numbers.decimal(text, separator: "")
      value && Rosetta::Engine::Numbers.write_decimal(value)
    end

    # Turn each plain string into its value, and read its escapes. Join
    # strings written next to each other. A string with a prefix, such as
    # L"a", keeps its text, and so does an escape that isn't listed, so two
    # different strings can never get the same value.
    #
    # "a\x41"  ->  "aA"
    # R"(a\n)"  ->  "a\\n"
    # "a" "b"  ->  "ab"
    def write_strings_as_their_values!
      transform(tree, '(string_literal "\"") @string') do |match|
        next nil unless plain_string?(match.node)

        literal(match.node.named_children.map { |part| part.type == "escape_sequence" ? decode(part.text) : part.text }.join)
      end
      transform(tree, '(raw_string_literal "R\"") @string') do |match|
        parts = match.node.named_children
        literal(parts.first.text) if parts.map(&:type) == ["raw_string_content"]
      end
      transform(tree, "(concatenated_string) @string") do |match|
        literal(match.node.children.map(&:text).join) if match.node.children.all? { |part| part.type == "literal" }
      end
    end

    def plain_string?(node)
      node.children.all? { |child| ['"', "string_content", "escape_sequence"].include?(child.type) }
    end

    # Return the text that an escape stands for, or the escape itself if it
    # stands for no single character, such as half of a surrogate pair.
    def decode(escape)
      code = escape[1..]
      case code
      when /\Au(\h{4})\z/, /\AU(\h{8})\z/
        value = Regexp.last_match(1).to_i(16)
        value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? escape : [value].pack("U")
      when /\A[0-7]{1,3}\z/ then code.to_i(8) > 127 ? escape : code.to_i(8).chr
      when /\Ax([0-7]\h?)\z/ then Regexp.last_match(1).to_i(16).chr
      else ESCAPES.fetch(escape, escape)
      end
    end

    # Write each operator word as its symbol, because C++ reads them the same.
    # a and not b  ->  a && !b
    # a or_eq b  ->  a |= b
    def write_operator_words_as_symbols!
      each_node(tree) do |node, _|
        next unless ["binary_expression", "unary_expression", "assignment_expression"].include?(node.type)

        operator = node[:operator]
        symbol = operator && OPERATOR_WORDS[operator.type]
        operator.type = operator.text = symbol if symbol
      end
    end

    ### Statements ###

    # Put the statement after an `else` straight into its `if`, as the
    # compiler does.
    # if (a) { } else { }  ->  (if_statement (condition_clause a) (compound_statement) (compound_statement))
    def put_the_else_branch_in_the_if!
      captured(tree, "(if_statement alternative: (else_clause) @name)").each do |clause|
        branch = clause.named_children.first
        clause.type = branch.type
        clause.children = branch.children
      end
    end

    ### Declarations ###

    # In a declaration of more than one name, put each name and its value in
    # an `init_declarator` of its own, so that representation/spec.rb can list
    # each name as a definition.
    # int a, b = 1;  ->  (declaration int (init_declarator a) (init_declarator b = 1))
    # struct A { int a = 1, b; };  ->  (field_declaration int (init_declarator a = 1) (init_declarator b))
    def give_each_name_of_a_declaration_with_several_its_own_declarator!
      each_node(tree) do |node, _|
        next unless ["declaration", "field_declaration"].include?(node.type)
        next unless node.children.count { |child| child.field == "declarator" } > 1

        node.children = node.children.slice_before { |child| child.field == "declarator" }.flat_map do |run|
          next run if run.first.field != "declarator" || run.first.type == "init_declarator"

          [build(:init_declarator, *run).tap { |declarator| declarator.field = "declarator" }]
        end
      end
    end

    # Write the scopes of a function's name before the name, as the compiler
    # does, so that representation/spec.rb can list the name as a definition.
    # int Clock::hour()  ->  (function_declarator Clock hour (parameter_list))
    def write_the_scopes_of_a_function_name_before_the_name!
      find_all(tree, "(function_declarator declarator: (qualified_identifier) @name)").each do |match|
        scopes = []
        name = match[:name]
        while name.type == "qualified_identifier"
          scopes << name[:scope]
          name = name[:name]
        end
        name.field = "declarator"
        index = match.node.children.index { |child| child.equal?(match[:name]) }
        match.node.children[index, 1] = [*scopes.compact, name]
      end
    end

    # Give a `using` in a class a type of its own, so that the imports in
    # representation/spec.rb leave it alone. It changes what the class has, as in
    # `using Base::Base;`.
    def give_a_using_declaration_in_a_class_its_own_type!
      each_node(tree) do |node, _|
        next unless node.type == "field_declaration_list"

        node.children.each { |child| child.type = "class_using_declaration" if child.type == "using_declaration" }
      end
    end
  end
end
