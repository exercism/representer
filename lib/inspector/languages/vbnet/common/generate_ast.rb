# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that VB.NET's own parser (Roslyn) gives, where names and
# keywords ignore case.
module Inspector::Languages::VBNet::Common
  class GenerateAST < Inspector::Engine::GenerateAST
    # Strip the brackets, separators and other punctuation, because they are
    # layout. Keep the commas of an array's rank, because `Integer(,)` and
    # `Integer()` are different types.
    # f(a, b)  ->  (invocation_expression f (argument_list a b))
    strip_tokens "(", ")", "{", "}", ",", ".", ":", ":=", "!", "<%=", "%>"
    keep_tokens ",", in: :array_rank_specifier

    # Strip these tokens only from the nodes listed, because elsewhere they
    # are operators, or the only thing that tells two programs apart.
    # Dim x As Integer = 1  ->  (variable_declarator x As (primitive_type Integer) 1)
    # Case Is > 10  ->  (case_clause > 10)
    strip_tokens "=", only_in: [:variable_declarator, :parameter, :enum_member, :property_declaration,
                                :property_signature, :for_statement, :let_clause, :field_initializer,
                                :aggregation, :xml_attribute, :imports_clause]
    strip_tokens "<", ">", only_in: [:attribute_list, :attribute_statement]
    strip_tokens "?", only_in: :nullable_type
    strip_tokens "Is", only_in: :case_clause
    strip_tokens "$\"", "\"", only_in: :interpolated_string_expression

    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. `If a Then` and `If a`, and `ElseIf` and `Else If`,
    # are the same to VB.NET's parser.
    # If a Then Return b  ->  (single_line_if_statement a (block (return_statement b)))
    # Else If a  ->  (elseif_clause a ...)
    strip_tokens "Namespace", "Module", "Class", "Structure", "Interface", "Enum", "Inherits", "Implements",
                 "Handles", "Delegate", "Event", "Custom", "Declare", "Lib", "Alias", "Property", "New", "As",
                 "Of", "With", "From", "Imports", "Option"
    strip_tokens "If", "Then", "Else", "ElseIf", "Select", "Case", "For", "Each", "In", "To", "Step", "Next",
                 "Do", "Loop", "While", "Try", "Catch", "When", "Finally", "Using", "SyncLock", "Return",
                 "Throw", "Exit", "Continue", "Call", "ReDim", "Erase", "Stop", "Yield", "Await",
                 "TypeOf", "GetType", "NameOf", "Aggregate", "Where", "Distinct", "Order", "By", "Group",
                 "Join", "Equals", "Into", "Let"
    strip_tokens "Sub", "Operator", only_in: [:constructor_declaration, :operator_declaration]
    strip_tokens "Resume", only_in: :resume_statement

    # Keep these tokens in the nodes listed, because they are the only thing
    # that tells two programs apart there.
    # Dim x As New Foo() and Dim x = New Foo()
    # Exit For and Exit Do, Continue For and Continue While
    # Do While a ... Loop and Do Until a ... Loop
    # Of T As Class and Of T As Structure
    # In and Out type parameters
    # On Error Resume Next and On Error GoTo 0, Resume Next and Resume
    # Into Group and Into Count()
    keep_tokens "As", in: :variable_declarator
    keep_tokens "For", "Do", "While", "Select", "Try", "Property", in: [:exit_statement, :continue_statement]
    keep_tokens "While", in: [:do_statement, :partition_clause]
    keep_tokens "Class", "Structure", "New", in: :special_constraint
    keep_tokens "In", in: :type_parameter
    keep_tokens "Next", in: [:on_error_statement, :resume_statement]
    keep_tokens "Module", "Return", in: [:attribute, :global_attribute]
    keep_tokens "Group", in: :aggregation

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value. A floating-point number keeps its type
    # character, in lower case, because `1.5D` is a Decimal and `1.5` is a
    # Double. An integer with a type character keeps its text.
    #
    # 1_000  ->  1000
    # &H1F  ->  31
    # 1.50  ->  1.5
    # 1E3  ->  1000.0
    # 8D  ->  8.0d
    numbers_are integer: :integer_literal,
                decimal: :floating_literal,
                prefixes: { "&H" => 16, "&O" => 8, "&B" => 2 },
                suffixes: ["f", "r", "d", "!", "#", "@"]

    # VB.NET reads a typographic quote as a plain double quote, so any two
    # quotes in a row stand for one quote.
    DOUBLED_QUOTE = /["“”]{2}/

    def call
      tree.tap do
        drop_end_lines!
        drop_the_variables_after_next!
        write_strings_as_their_values!
        write_names_in_lower_case!
      end
    end

    private
    ### Layout ###

    # Drop the `End` line that closes a block, because the node around it
    # already ends there.
    # End Sub  ->  (nothing)
    # End If  ->  (nothing)
    def drop_end_lines!
      each_node(tree) do |node, _|
        next if node.leaf?

        node.children = node.children.each_with_object([]) do |child, children|
          end_token = children.last && !children.last.named? && children.last.type == "End"
          end_token && !child.named? ? children.pop : children << child
        end
      end
    end

    # Drop the names after a loop's `Next`, because they must be the loop's
    # own variable.
    # For i = 1 To 3 ... Next i  ->  For i = 1 To 3 ... Next
    def drop_the_variables_after_next!
      each_node(tree) do |node, _|
        next unless ["for_statement", "for_each_statement"].include?(node.type)

        after_next = node.children.index { |child| !child.named? && child.type == "Next" }
        node.children = node.children[..after_next] if after_next
      end
    end

    ### Values ###

    # Turn each string and character into its value. VB.NET reads a doubled
    # quote in a string as one quote, and has no other escapes. An
    # interpolated string also reads `{{` and `}}` as braces.
    #
    # "say ""hi"""  ->  "say \"hi\""
    # "a"c  ->  (character_literal "a")
    # $"{{x}} {n}"  ->  (interpolated_string_expression "{x} " (interpolation n))
    def write_strings_as_their_values!
      transform(tree, "(string_literal) @string") { |match| literal(unquote(match.node.text)) }
      transform(tree, "(character_literal) @character") do |match|
        build(:character_literal, literal(unquote(match.node.text[0...-1])))
      end
      transform(tree, "(interpolated_text) @text") do |match|
        literal(match.node.text.gsub(DOUBLED_QUOTE, '"').gsub("{{", "{").gsub("}}", "}"))
      end
      transform(tree, "(interpolation_format) @format") { |match| literal(match.node.text) }
    end

    def unquote(text) = text[1...-1].gsub(DOUBLED_QUOTE, '"')

    ### Names ###

    # Write every name in lower case, because VB.NET ignores the case of
    # names, and drop the brackets that let a name spell a keyword. The
    # grammar spells the keywords one way already. A number with a type
    # character keeps its text, so that is written in lower case too.
    #
    # Dim Total = SUM(Values)  ->  Dim total = sum(values)
    # [Select]  ->  select
    # 10L  ->  10l
    def write_names_in_lower_case!
      each_node(tree) do |node, _|
        next unless node.leaf? && !node.quoted

        case node.type
        when "identifier" then node.text = node.text.delete_prefix("[").delete_suffix("]").downcase
        when "integer_literal", "floating_literal" then node.text = node.text.downcase
        end
      end
    end
  end
end
