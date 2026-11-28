# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, which gives one form to the spellings that D's parser reads
# as one.
module Representer::Languages::D::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords where they sit in a fixed place, because the node
    # types already show them. Elsewhere they tell two programs apart, as in
    # `typeof(return)`, `is(T == class)` and `static int x;`.
    # if (x) { return y; }  ->  (if_statement x (block_statement (return_statement y)))
    # static if (a) {}  ->  (conditional_statement (condition (static_if_condition a)) (block_statement))
    strip_tokens "module", only_in: :module_declaration
    strip_tokens "import", only_in: [:import_declaration, :import_expression]
    strip_tokens "return", only_in: :return_statement
    strip_tokens "if", only_in: [:if_statement, :static_if_condition, :constraint]
    strip_tokens "else", only_in: [:if_statement, :conditional_statement, :conditional_declaration]
    strip_tokens "while", only_in: [:while_statement, :do_statement]
    strip_tokens "do", only_in: [:do_statement, :function_body]
    strip_tokens "for", only_in: :for_statement
    strip_tokens "switch", only_in: [:switch_statement, :final_switch_statement]
    strip_tokens "final", only_in: :final_switch_statement
    strip_tokens "case", only_in: :case_statement
    strip_tokens "break", only_in: :break_statement
    strip_tokens "continue", only_in: :continue_statement
    strip_tokens "goto", only_in: :goto_statement
    strip_tokens "static", only_in: [:static_if_condition, :static_foreach_statement, :static_foreach_declaration,
                                     :static_assert]
    strip_tokens "struct", only_in: :struct_declaration
    strip_tokens "class", only_in: :class_declaration
    strip_tokens "union", only_in: :union_declaration
    strip_tokens "interface", only_in: :interface_declaration
    strip_tokens "enum", only_in: [:enum_declaration, :anonymous_enum_declaration, :manifest_constant]
    strip_tokens "template", only_in: [:template_declaration, :mixin_template_declaration]
    strip_tokens "mixin", only_in: [:mixin_template_declaration, :mixin_expression, :template_mixin]
    strip_tokens "alias", only_in: :alias_declaration
    strip_tokens "unittest", only_in: :unittest_declaration
    strip_tokens "assert", only_in: [:assert_expression, :static_assert]
    strip_tokens "is", only_in: :is_expression
    strip_tokens "in", only_in: [:in_statement, :in_contract_expression]
    strip_tokens "out", only_in: [:out_statement, :out_contract_expression]
    strip_tokens "new", only_in: :new_expression
    strip_tokens "cast", only_in: :cast_expression
    strip_tokens "throw", only_in: :throw_expression
    strip_tokens "try", only_in: :try_statement
    strip_tokens "catch", only_in: :catch_statement
    strip_tokens "finally", only_in: :finally_statement
    strip_tokens "typeof", only_in: :typeof_expression
    strip_tokens "typeid", only_in: :typeid_expression
    strip_tokens "with", only_in: :with_statement

    # Strip the brackets, commas and semicolons, because they are layout.
    # f(a, b);  ->  (call_expression f (named_arguments a b))
    strip_tokens "(", ")", "{", "}", ",", ";"

    # Keep the `;` in a `for`, because it is the only thing that tells
    # these apart.
    # for (;; i++) and for (i++;;)
    keep_tokens ";", in: :for_statement

    # Strip these tokens only where they sit in a fixed place, because
    # elsewhere they tell two programs apart, as in `int[]` and `int`,
    # `is(T : U)` and `is(T == U)`, or `.x` and `x`.
    # [1, 2]  ->  (array_literal 1 2)
    # to!(int)  ->  (template_instance to (template_arguments (template_argument (type int))))
    # a ? b : c  ->  (ternary_expression a b c)
    # int x = 1;  ->  (variable_declaration (type int) (declarator x 1))
    strip_tokens "[", "]", only_in: [:array_literal, :index_expression]
    strip_tokens ".", only_in: :module_fqn
    strip_tokens "!", only_in: :template_arguments
    strip_tokens "?", only_in: :ternary_expression
    strip_tokens ":", only_in: [:ternary_expression, :case_statement, :label, :named_argument, :class_declaration,
                                :interface_declaration, :enum_declaration]
    strip_tokens "=", only_in: [:declarator, :auto_declaration, :parameter, :enum_member, :anonymous_enum_member,
                                :manifest_declarator, :alias_initializer, :if_condition]

    # Unwrap the grammar's wrappers around one expression, and brackets that
    # only group, because the tree's shape shows the grouping.
    # (a % 4 == 0) && b  ->  a % 4 == 0 && b
    # if (x) y;  ->  (if_statement x y)
    unwrap :expression, :expression_list, :binary_expression, :primary_expression, :named_argument,
           :scope_statement, :if_condition

    DEFINITIONS = ["class_declaration", "struct_declaration", "union_declaration", "interface_declaration",
                   "enum_declaration", "template_declaration", "mixin_template_declaration", "alias_initializer",
                   "function_declaration", "template_parameter", "declarator", "parameter", "foreach_type",
                   "catch_statement", "enum_member", "anonymous_enum_member", "manifest_declarator", "label"].freeze

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\0' => "\0",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'"
    }.freeze

    BUILTIN_TYPES = ["bool", "byte", "ubyte", "char", "short", "ushort", "int", "uint", "long", "ulong", "cent", "ucent",
                     "wchar", "dchar", "float", "double", "real", "ifloat", "idouble", "ireal", "cfloat", "cdouble",
                     "creal", "size_t", "ptrdiff_t", "string", "cstring", "dstring", "wstring", "noreturn",
                     "void"].freeze

    INT = (0...(2**31))

    def call
      tree.tap do
        read_the_stripped_keywords_as_tokens!
        write_numbers_as_their_values!
        write_strings_as_their_values!
        put_the_declarations_of_a_module_in_the_file!
        write_a_single_template_argument_as_a_list!
        give_each_function_literal_its_parameters!
        write_a_body_after_an_arrow_as_a_return!
        give_each_definition_its_name!
      end
    end

    private
    # Turn the keywords listed above into tokens, because the grammar gives
    # each keyword a node of its own, and the engine only strips tokens.
    def read_the_stripped_keywords_as_tokens!
      everywhere = self.class.stripped_tokens
      each_node(tree) do |node, _|
        stripped = everywhere + self.class.stripped_tokens_in.fetch(node.type, [])
        node.children.each do |child|
          child.named = false if child.leaf? && child.named? && child.type == child.text && stripped.include?(child.type)
        end
      end
    end

    ### Values ###

    # Write each number as its value. An integer only changes if it fits in
    # an int and has no suffix, because the type of a larger one depends on
    # how it is written: 0xFFFFFFFF is a uint, and 4294967295 is a long. A
    # decimal changes if it has no suffix, because 1.5f is a float.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    def write_numbers_as_their_values!
      each_node(tree) do |node, _|
        value = case node.type
                when "int_literal" then integer(node.text)
                when "float_literal" then decimal(node.text)
                end
        node.text = value if value
      end
    end

    def integer(text)
      value = Representer::Engine::Numbers.integer(text, prefixes: { "0x" => 16, "0b" => 2 })
      value.to_s if value && INT.cover?(value)
    end

    def decimal(text)
      value = Representer::Engine::Numbers.decimal(text)
      value && Representer::Engine::Numbers.write_decimal(value)
    end

    # Turn each string into its value, and read its escapes. A string in
    # backticks, a raw string and a token string have no escapes, so their
    # text is their value. Keep a string with a suffix as it is, because the
    # suffix sets its type, and keep any other escape as a node of its own,
    # so it can't make two different strings the same.
    #
    # `a\b`  ->  "a\\b"
    # q{a < b}  ->  "a < b"
    # "\x41\n"  ->  "A\n"
    def write_strings_as_their_values!
      transform(tree, "(string_literal) @string") do |match|
        string = match.node.named_children.first
        text = string&.text
        next nil unless text

        case string.type
        when "quoted_string" then quoted_string(text[1...-1]) if text.end_with?('"')
        when "raw_string" then literal(text.delete_prefix("r")[1...-1]) if text.end_with?('"', "`")
        when "token_string" then literal(text[2...-1]) if text.end_with?("}")
        end
      end
    end

    def quoted_string(text)
      pieces = text.scan(/\\x\h{2}|\\u\h{4}|\\U\h{8}|\\.|[^\\]+/m).map { |piece| piece.start_with?("\\") ? escape(piece) : piece }
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string_literal, *parts)
    end

    # Return the text that an escape stands for, or a node for the escape if
    # it stands for no single character.
    def escape(text)
      if text.match?(/\A\\[xuU]/)
        value = text[2..].to_i(16)
        return [value].pack("U") if character?(text, value)
      end

      ESCAPES.fetch(text) { leaf(:escape_sequence, text) }
    end

    # A `\x` escape stands for one byte, which is only a whole character up
    # to 0x7F, and a `\u` or `\U` escape stands for one code point.
    def character?(escape, value)
      return value <= 0x7F if escape.start_with?("\\x")

      !value.between?(0xD800, 0xDFFF) && value <= 0x10FFFF
    end

    ### Declarations ###

    # Put the declarations after `module` straight into the file, as D's
    # parser does, so a solution reads the same with and without its module
    # declaration.
    # module leap; bool f();  ->  (source_file (module_declaration leap) (function_declaration ...))
    def put_the_declarations_of_a_module_in_the_file!
      tree.children = tree.children.flat_map { |child| child.type == "module_def" ? child.children : [child] }
    end

    # Write a template argument without brackets as a list of one, as D's
    # parser does.
    # to!int  ->  to!(int)
    # map!"a * 2"  ->  map!("a * 2")
    def write_a_single_template_argument_as_a_list!
      each_node(tree) do |node, _|
        next unless node.type == "template_arguments"

        node.children.map! do |child|
          next child if !child.named? || child.type == "template_argument"

          build(:template_argument, BUILTIN_TYPES.include?(child.type) ? build(:type, child) : child)
        end
      end
    end

    # Put the parameters of a function literal in a list of their own, as D's
    # parser does. A parameter that is only a name has its type inferred.
    # x => x  ->  (function_literal (parameters (parameter x)) x)
    # (x, int y) => x  ->  (function_literal (parameters (parameter x) (parameter (type int) y)) x)
    def give_each_function_literal_its_parameters!
      each_node(tree) do |node, _|
        next unless node.type == "function_literal"

        if node.children.first&.type == "identifier"
          node.children[0] = build(:parameters, build(:parameter, node.children.first))
          next
        end

        open = node.children.index { |child| child.type == "(" }
        next unless open

        close = node.children.index { |child| child.type == ")" }
        node.children[open..close] = [build(:parameters, *parameters(node.children[(open + 1)...close]))]
      end
    end

    def parameters(children)
      children.slice_when { |_, child| child.type == "," }.map do |run|
        run = run.reject { |child| child.type == "," }
        type = run.first
        name = type.named_children.first if run.one? && type.type == "type" && type.children.one?
        build(:parameter, *(name&.type == "identifier" ? [name] : run))
      end
    end

    # Write a body after `=>` as a block that returns it, as D's parser does.
    # int f() => 1;  ->  int f() { return 1; }
    # x => x * 2  ->  (x) { return x * 2; }
    def write_a_body_after_an_arrow_as_a_return!
      each_node(tree) do |node, _|
        next unless ["function_body", "function_literal"].include?(node.type)

        arrow = node.children.index { |child| child.type == "=>" }
        next unless arrow

        value = node.children[arrow + 1]
        node.children[arrow..] = [build(:block_statement, build(:return_statement, value))]
      end
    end

    # Give the first name in each definition the field `name`, so that
    # representation/spec.rb can tell it apart from a value in the same node. In
    # an `if`, only a condition with `=` defines a name.
    # int total = count;  ->  (declarator name: total count)
    # if (auto p = k in aa)  ->  (if_condition auto name: p (identity_expression k in aa))
    def give_each_definition_its_name!
      each_node(tree) do |node, _|
        defines = DEFINITIONS.include?(node.type) || (node.type == "if_condition" && node.children.any? { |child| child.type == "=" })
        next unless defines

        name = node.children.find { |child| child.type == "identifier" && child.field.nil? }
        name.field = "name" if name
      end
    end
  end
end
