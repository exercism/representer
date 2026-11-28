# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the tree that Pharo's own parser gives, where each message has one selector
# such as `at:put:`, and marks the names that the class and its methods
# define.
module Inspector::Languages::PharoSmalltalk::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the brackets and separators, because the node types already show
    # them. Pharo reads several `.` between statements, and one after the
    # last statement, the same as one `.` between statements.
    # ^ a foo.  ->  (return (unary_message a foo))
    strip_tokens "[", "]", "{", "}", "(", ")", "#(", "#[", "<", ">", "|", ":", ":=", "^", ";", ">>", ".", ","

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping.
    # (a foo) bar  ->  a foo bar
    unwrap :parenthesized_expression

    # Write each integer as its value. Pharo reads `16rFF` and `255` as the
    # same integer.
    # 16rFF  ->  255
    # 2r1010  ->  10
    numbers_are integer: :number,
                prefixes: { "16r" => 16, "10r" => 10, "8r" => 8, "2r" => 2 }

    CLASS_KEYS = ["name", "superclass"].freeze

    VARIABLE_KEYS = ["instVars", "classVars", "classInstVars"].freeze

    KEYWORD_HOLDERS = ["keyword_message", "cascaded_message", "keyword_pattern", "pragma"].freeze

    def call
      tree.tap do |root|
        write_decimals_as_their_values!(root)
        write_strings_and_symbols_as_their_values!(root)
        write_each_selector_as_one_name!(root)
        write_class_headers_as_their_names_and_values!(root)
      end
    end

    private
    # Write each decimal as its value. Pharo reads `1e10` as an integer and
    # `1.5s2` as a scaled decimal, so those keep their text, and stay apart
    # from a float with the same value.
    # 1.50  ->  1.5
    def write_decimals_as_their_values!(root)
      root.each_descendant do |node|
        next unless node.type == "number" && node.text.match?(/\A-?\d+\.\d+(e-?\d+)?\z/)

        node.text = Inspector::Engine::Numbers.write_decimal(Inspector::Engine::Numbers.decimal(node.text))
      end
    end

    # Write each string as its value, and each symbol as `#` and its value.
    # Pharo reads a symbol in quotes as the same symbol without them, and
    # reads a word in a literal array as a symbol.
    # 'it''s'  ->  "it's"
    # #'foo'  ->  #foo
    # #(foo at:put: + #bar)  ->  (literal_array #foo #at:put: #+ #bar)
    def write_strings_and_symbols_as_their_values!(root)
      each_node(root) do |node, parent|
        next unless node.leaf?

        if node.type == "string" then parent.replace_child(node, literal(string_value(node.text)))
        elsif node.type == "symbol" then node.text = "##{symbol_value(node.text)}"
        end
      end
    end

    def string_value(text) = text[1...-1].gsub("''", "'")

    def symbol_value(text)
      value = text.delete_prefix("#")
      value.start_with?("'") ? string_value(value) : value
    end

    # Write the keywords of each message, method and pragma as one selector,
    # in the place of the first keyword, because Pharo names a message by
    # its whole selector.
    # a at: 1 put: 2  ->  (keyword_message a (keyword_selector at:put:) 1 2)
    # at: i put: v [ ]  ->  (keyword_pattern (keyword_selector at:put:) (parameter i) (parameter v))
    def write_each_selector_as_one_name!(root)
      each_node(root) do |node, _|
        join_keywords!(node) if KEYWORD_HOLDERS.include?(node.type)
      end
    end

    def join_keywords!(node)
      parts = node.children.flat_map { |child| child.type == "keyword_argument" ? child.children : [child] }
      keywords = parts.select { |part| part.type == "keyword" }
      return if keywords.empty?

      parts[parts.index(keywords.first)] = leaf(:keyword_selector, keywords.map(&:text).join, field: :selector)
      node.children = parts - keywords
    end

    # Write a class header as the names and values that the class
    # definition reads from it. The header names the class and its
    # superclass, and declares the variables, so their names become
    # identifiers, and the class's own name marks it as defined.
    # Class { #name : #Foo, #instVars : [ 'a' ] }  ->
    #   (class_definition Class (ston_map (ston_pair name (class_name Foo)) (ston_pair instVars (variable_names a))))
    def write_class_headers_as_their_names_and_values!(root)
      root.children.each do |definition|
        map = definition.type == "class_definition" ? definition["body"] : definition["metadata"]
        map&.children&.each { |pair| write_ston_pair!(pair, defines_class: defines_class?(definition)) }
      end
    end

    def write_ston_pair!(pair, defines_class:)
      return unless pair.type == "ston_pair"

      key = ston_text(pair["key"])
      value = pair["value"]
      pair.replace_child(pair["key"], leaf(:ston_key, key))
      if CLASS_KEYS.include?(key) && value.leaf?
        name = leaf(:identifier, ston_text(value))
        pair.replace_child(value, key == "name" && defines_class ? build(:class_name, name) : name)
      elsif VARIABLE_KEYS.include?(key) && value.type == "ston_list"
        names = value.named_children.map { |item| leaf(:identifier, ston_text(item)) }
        pair.replace_child(value, build(:variable_names, *names))
      else
        each_node(value) { |item, _| item.type = "ston_symbol" if item.type == "symbol" }
      end
    end

    # A STON symbol or string, without its `#`.
    def ston_text(node) = node.quoted ? node.text : node.text.delete_prefix("#")

    # The header of `Class { }` and `Trait { }` defines a class or trait, and
    # the header of `Extension { }` names a class from outside the solution.
    def defines_class?(definition)
      definition.type == "class_definition" && definition.children.none? { |child| child.type == "Extension" }
    end
  end
end
