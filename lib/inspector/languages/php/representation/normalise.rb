# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here gives one form to code that works the same way.
module Inspector::Languages::PHP::Representation
  class Normalise < Inspector::Engine::Normalise
    FUNCTION_ALIASES = {
      "chop" => "rtrim",
      "doubleval" => "floatval",
      "fputs" => "fwrite",
      "ini_alter" => "ini_set",
      "is_double" => "is_float",
      "is_integer" => "is_int",
      "is_long" => "is_int",
      "is_writeable" => "is_writable",
      "join" => "implode",
      "key_exists" => "array_key_exists",
      "pos" => "current",
      "show_source" => "highlight_file",
      "sizeof" => "count",
      "strchr" => "strstr"
    }.freeze

    def call
      super.tap do |root|
        write_each_function_alias_as_its_main_name!(root)
        make_every_method_public_and_not_final!(root)
        drop_the_type_of_each_class_constant!(root)
        write_strings_with_code_as_concatenations!(root)
        join_the_strings_in_each_concatenation!(root)
      end
    end

    private
    # Write each alias of a PHP function as the function's main name.
    # sizeof($xs)  ->  count($xs)
    # join(",", $xs)  ->  implode(",", $xs)
    def write_each_function_alias_as_its_main_name!(root)
      captured(root, "(function_call_expression function: (name) @name)").each do |name|
        name.text = FUNCTION_ALIASES.fetch(name.text, name.text)
      end
    end

    ### Classes ###

    # Make every method public and not final, because a passing solution works
    # the same either way.
    # private final function f() {}  ->  public function f() {}
    # function f() {}  ->  public function f() {}
    def make_every_method_public_and_not_final!(root)
      each_node(root) do |node, _|
        next unless node.type == "method_declaration"

        node.children.reject! { |child| ["visibility_modifier", "final_modifier", "readonly_modifier"].include?(child.type) }
      end
    end

    # Drop the type of each class constant, because the value already shows it.
    # const string NAME = 'PHP';  ->  const NAME = 'PHP';
    def drop_the_type_of_each_class_constant!(root)
      find_all(root, "(const_declaration type: (_) @type)").each { |match| match.node.children.delete(match[:type]) }
    end

    ### Strings ###

    # Write each string that holds code as a concatenation of its pieces.
    # "a $b c"  ->  'a ' . $b . ' c'
    # "$b"  ->  $b
    def write_strings_with_code_as_concatenations!(root)
      transform(root, "(encapsed_string) @string") { |match| concatenation(match.node.children) }
    end

    # Join the strings that touch in each concatenation, and group the
    # concatenation from the left.
    # 'a' . 'b' . $c  ->  'ab' . $c
    # $a . ($b . $c)  ->  ($a . $b) . $c
    def join_the_strings_in_each_concatenation!(root)
      transform(root, "(binary_expression operator: \".\") @concat") do |match|
        operands = flatten(match.node)
        joined = operands.chunk_while { |a, b| a.type == "literal" && b.type == "literal" }.map do |run|
          run.one? ? run.first : literal(run.map(&:text).join)
        end
        concatenation(joined) unless joined.size == operands.size && !concatenation?(match.node["right"])
      end
    end

    def flatten(node) = concatenation?(node) ? flatten(node["left"]) + flatten(node["right"]) : [node]

    def concatenation?(node) = node&.type == "binary_expression" && node["operator"]&.text == "."

    def concatenation(operands)
      operands.map { |operand| copy(operand).tap { |own| own.field = nil } }.reduce do |left, right|
        build(:binary_expression, { left: }, { operator: token(".") }, { right: })
      end
    end
  end
end
