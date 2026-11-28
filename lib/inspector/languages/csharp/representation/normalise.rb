# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here gives one form to spellings that C# reads the same way.
module Inspector::Languages::CSharp::Representation
  class Normalise < Inspector::Engine::Normalise
    # Drop `System.` before a name.
    # System.Math.Max(a, b)  ->  Math.Max(a, b)
    rewrite "System.{{name}}", as: "{{name}}"
    rewrite "System.{{name}}",
        as: "{{name}}",
        inside: "class A { {{pattern}} x; }"

    # Write the type `String` as its keyword.
    # String.Join(",", xs)  ->  string.Join(",", xs)
    rewrite "String",
        as: "string",
        inside: "class A { {{pattern}} x; }"

    # Turn a negative condition of a ternary into a positive one, and swap the
    # two results.
    # a != b ? x : y  ->  a == b ? y : x
    # !a ? x : y  ->  a ? y : x
    rewrite "{{a}} != {{b}} ? {{yes}} : {{no}}", as: "{{a}} == {{b}} ? {{no}} : {{yes}}"
    rewrite "!{{a}} ? {{yes}} : {{no}}",         as: "{{a}} ? {{no}} : {{yes}}"

    # Drop a comparison with `true` or `false`.
    # x == true  ->  x
    # x == false  ->  !x
    # x != true  ->  !x
    rewrite "{{x}} == true",  as: "{{x}}"
    rewrite "true == {{x}}",  as: "{{x}}"
    rewrite "{{x}} != false", as: "{{x}}"
    rewrite "false != {{x}}", as: "{{x}}"
    rewrite "{{x}} == false", as: "!{{x}}"
    rewrite "false == {{x}}", as: "!{{x}}"
    rewrite "{{x}} != true",  as: "!{{x}}"
    rewrite "true != {{x}}",  as: "!{{x}}"

    # Drop every `readonly`, because it never changes whether a passing solution works.
    # readonly int x;  ->  int x;
    # ref readonly int F()  ->  ref int F()
    drop "readonly", inside: "class A { {{pattern}} int x; }"
    drop "readonly", inside: "class A { ref {{pattern}} int F() => x; }"

    # Put braces around the body of each `if` and `else`, including an
    # `else if`.
    # if (x) y(); else if (z) w();  ->  if (x) { y(); } else { if (z) { w(); } }
    add_braces_to "if ({{...}}) {{body}}",
                  "if ({{...}}) { } else {{body}}"

    def call
      super.tap do |root|
        drop_empty_brackets_from_new_with_initializer!(root)
        write_every_dictionary_initialiser_the_same_way!(root)
      end
    end

    private
    # Drop empty brackets after the type of a `new` with an initializer. A
    # tree pattern's `(argument_list)` also matches brackets that hold
    # arguments, so this step checks that the brackets are empty.
    # new List<int>() { 1 }  ->  new List<int> { 1 }
    def drop_empty_brackets_from_new_with_initializer!(root)
      find_all(root, "(object_creation_expression arguments: (argument_list) @arguments initializer: (_))").each do |match|
        match.node.children.delete(match[:arguments]) if match[:arguments].children.empty?
      end
    end

    # Write each `[key] = value` entry of a new dictionary as `{ key, value }`.
    # new Dictionary<int, string> { [1] = "a" }  ->  new Dictionary<int, string> { { 1, "a" } }
    def write_every_dictionary_initialiser_the_same_way!(root)
      pattern = '(object_creation_expression type: (generic_name (identifier "Dictionary")) ' \
                "initializer: (initializer_expression (assignment_expression left: (element_binding_expression))* @entries))"
      find_all(root, pattern).each do |match|
        match[:entries].each do |entry|
          key = entry[:left].named_children.first.named_children.first
          value = entry[:right]
          value.field = nil
          match.node[:initializer].replace_child(entry, build(:initializer_expression, key, value))
        end
      end
    end
  end
end
