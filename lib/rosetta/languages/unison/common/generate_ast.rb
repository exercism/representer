# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Unison's parser gives.
#
# The grammar writes each expression as one flat list of its parts, with no
# node for a call, so `f (g x) y` is `f`, a bracketed `g x`, and `y`. The
# brackets around a group of parts are its only sign of the grouping, so this
# stage keeps them, and keeps every token that separates the parts of a list.
module Rosetta::Languages::Unison::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords and brackets that sit in a fixed place, because the
    # node types already show them.
    # if a then b else c  ->  (exp_if (if_block a) (then_block b) (else_block c))
    # [a, b]  ->  (literal_list a , b)
    strip_tokens "ability", "cases", "do", "else", "handle", "if", "let", "match", "then", "type", "use",
                 "where", "with", "=", "!", "'", "[", "]"
    strip_tokens "(", ")", only_in: [:tuple_or_parenthesized, :parenthesized_or_tuple_pattern, :tuple_or_parenthesized_type]
    strip_tokens "{", "}", only_in: [:effect_pattern, :record]
    strip_tokens ":", only_in: [:type_signature, :record_field, :constructor]
    strip_tokens "|", only_in: :guarded_block

    # Unwrap brackets around a single part, because they only group.
    # f (x) y  ->  f x y
    # Some (x) -> x  ->  Some x -> x
    unwrap :tuple_or_parenthesized, :parenthesized_or_tuple_pattern, :tuple_or_parenthesized_type, :pattern

    # Write each number as its value. Unison reads `1` as a Nat, `+1` as an
    # Int and `1.0` as a Float, so the three stay apart.
    # 0x1f  ->  31
    # 1.50  ->  1.5
    numbers_are integer: [:nat, :literal_hex],
                decimal: :float

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\\\\' => "\\",
      '\"' => '"'
    }.freeze

    TYPES = ["term_type", "sequence_type", "tuple_or_parenthesized_type", "effect", "delayed", "constructor",
             "constructor_argument", "constructor_return_type", "record_field", "type_declaration", "forall"].freeze

    def call
      tree.tap do
        write_ints_with_their_signs!
        write_strings_as_their_values!
        keep_other_values_apart_from_strings!
        mark_operators_used_as_functions!
        unwrap_brackets_around_a_whole_expression!
        mark_the_code_that_defines_names!
      end
    end

    private
    ### Values ###

    # Write each Int as its value, with its sign, so that it stays apart
    # from the Nat with the same digits.
    # +007  ->  +7
    # -0  ->  +0
    def write_ints_with_their_signs!
      each_node(tree) do |node, _|
        next unless node.type == "int" && (value = Rosetta::Engine::Numbers.integer(node.text))

        node.text = value.negative? ? value.to_s : "+#{value}"
      end
    end

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a leaf of its own, so it can't make two different strings
    # the same. A raw string keeps its text, as Unison drops its indentation.
    #
    # "say \"hi\""  ->  say "hi"
    # "a\x41"  ->  (literal_text "a" \x "41")
    def write_strings_as_their_values!
      transform(tree, "(literal_text) @string") do |match|
        next if match.node.text.start_with?('"""')

        pieces = match.node.text[1..-2].scan(/\\.|[^\\]+/m)
        next literal(string_value(pieces)) if pieces.all? { |piece| read?(piece) }

        runs = pieces.chunk_while { |a, b| read?(a) && read?(b) }
        build(:literal_text, *runs.map { |run| read?(run.first) ? literal(string_value(run)) : leaf(:escape, run.first) })
      end
    end

    def read?(piece) = !piece.start_with?("\\") || ESCAPES.key?(piece)

    def string_value(pieces) = pieces.sum("") { |piece| ESCAPES.fetch(piece, piece) }

    # Put each character, raw string and `()` in a node of its own. The
    # output writes their text in quotes when it holds a bracket or a quote,
    # so without the node `?(` would be the same as the string `"?("`.
    # ?(  ->  (literal_char "?(")
    # ()  ->  (unit)
    def keep_other_values_apart_from_strings!
      transform(tree, "[(literal_char) (literal_text) (unit)] @value") do |match|
        node = match.node
        next build(:unit) if node.type == "unit"

        build(node.type, leaf(:text, node.text)) if node.leaf?
      end
    end

    ### Brackets ###

    # Give each operator in brackets a node of its own, because the brackets
    # make it a function. The grammar gives the brackets to the expression
    # around it, and stripping them would make `f (+) 1` the same as `f + 1`.
    # List.foldLeft (+) 0  ->  List. foldLeft (prefix_operator +) 0
    # map (Nat.+) xs  ->  map (prefix_operator Nat. +) xs
    def mark_operators_used_as_functions!
      each_node(tree) do |node, _|
        parts = node.children
        node.children = []
        until parts.empty?
          size = bracketed_operator_size(parts)
          node.children << (size ? build(:prefix_operator, *parts[1, size - 2]) : parts.first)
          parts = parts.drop(size || 1)
        end
      end
    end

    # The number of parts at the start of the list that make a bracketed
    # operator, such as the four of `(Nat.+)`, or nil.
    def bracketed_operator_size(parts)
      return unless parts.first.type == "(" && !parts.first.named?

      paths = parts.drop(1).take_while { |part| part.type == "path" }.size
      paths + 3 if parts[paths + 1]&.type == "operator" && parts[paths + 2]&.type == ")"
    end

    # Unwrap the brackets around the whole of an expression, because they
    # only group. Brackets with a comma make a tuple, so they stay.
    # x = (a + b)  ->  x = a + b
    # | (x > 0) -> 1  ->  | x > 0 -> 1
    def unwrap_brackets_around_a_whole_expression!
      each_node(tree) do |node, _|
        next unless ["block_term", "guard"].include?(node.type)

        while node.children.one? && (inner = node.children.first).type == "tuple_or_parenthesized" &&
              inner.children.none? { |part| part.type == "," }
          node.children = inner.children[1..-2]
        end
      end
    end

    ### Names ###

    # Give the code that defines a name a shape of its own, so that
    # representation/spec.rb can list it in names_are_defined_by.
    def mark_the_code_that_defines_names!
      mark_the_parameters_of_lambdas!
      mark_the_constructors_and_fields!
      mark_the_variables_that_patterns_bind!
      mark_the_type_variables!
    end

    # Mark the names before a lambda's arrow as its parameters.
    # «x» «y» -> x + y
    def mark_the_parameters_of_lambdas!
      each_node(tree) do |node, _|
        next unless node.type == "literal_function"

        node.children.take_while { |part| part.type != "->" }.each { |part| part.field = "param" }
      end
    end

    # Mark the name of each constructor of a type, after its `=` or `|`,
    # and the name of each record field and each operation of an ability.
    # type Shape = «Circle» Float | «Square» Float
    # type Point = { «x» : Nat }
    # ability Emit a where «emit» : a -> ()
    def mark_the_constructors_and_fields!
      each_node(tree) do |node, _|
        case node.type
        when "type_declaration"
          node.children.each_cons(2) do |before, part|
            part.field = "constructor" if ["=", "|"].include?(before.type) && part.type == "regular_identifier"
          end
        when "record_field", "constructor"
          node.children.each { |part| part.field = "name" if ["field_name", "constructor_name"].include?(part.type) }
        end
      end
    end

    # Mark each lower case name in a pattern as a `variable_pattern`, which
    # the pattern binds. A name with a capital is a constructor, such as
    # `Less`, so it keeps its name. The first name in an ability's pattern
    # is the operation, so it keeps its name too.
    # Some «x», «h» +: «t» -> ...
    # { emit «a» -> «k» } -> ...
    def mark_the_variables_that_patterns_bind!
      each_node(tree) do |node, _|
        next unless ["pattern", "effect_bind"].include?(node.type)

        node.children.each_with_index do |part, index|
          next if node.type == "effect_bind" && index.zero?
          next unless part.type == "var_or_nullary_ctor" && part.named_children.one? &&
                      lower_case?(part.named_children.first)

          part.type = "variable_pattern"
        end
      end
    end

    # Mark each lower case name in a type as a `type_variable`, because
    # Unison reads every such name as a type variable. A name after a
    # namespace, such as `base.nat`, is a type's name.
    # f : «a» -> [«a»]
    # type Tree a = Node (Tree «a») «a»
    def mark_the_type_variables!
      each_node(tree) do |node, _|
        next unless TYPES.include?(node.type)

        [nil, *node.children].each_cons(2) do |before, part|
          next unless lower_case?(part) && part.field != "constructor" && before&.type != "path"

          node.replace_child(part, build(:type_variable, part))
        end
      end
    end

    def lower_case?(node) = node&.type == "regular_identifier" && node.text.match?(/\A[a-z_]/)
  end
end
