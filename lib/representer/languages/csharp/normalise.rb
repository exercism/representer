# REPRESENTER_DSL.md defines the verbs and helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here is one of the old representer's rewriters, or a change made by Roslyn's
# simplifier, which the old representer ran before them.
module Representer::Languages::CSharp
  class Normalise < Representer::Engine::Normalise
    # Drop `System.` before a name.
    # System.Math.Max(a, b) == Math.Max(a, b)
    rewrite "System.{{name}}", as: "{{name}}"
    rewrite "System.{{name}}", as: "{{name}}", inside: "class A { ... x; }"

    # Write the type `String` as its keyword.
    # String.Join(",", xs) == string.Join(",", xs)
    rewrite "String", as: "string", inside: "class A { ... x; }"

    # Turn a negative condition of a ternary into a positive one, and swap the
    # two results.
    # a != b ? x : y == a == b ? y : x
    # !a ? x : y == a ? y : x
    rewrite "{{a}} != {{b}} ? {{yes}} : {{no}}", as: "{{a}} == {{b}} ? {{no}} : {{yes}}"
    rewrite "!{{a}} ? {{yes}} : {{no}}", as: "{{a}} ? {{no}} : {{yes}}"

    # Drop a comparison with `true` or `false`.
    # x == true == x
    # x == false == !x
    # x != true == !x
    rewrite "{{x}} == true", as: "{{x}}"
    rewrite "true == {{x}}", as: "{{x}}"
    rewrite "{{x}} != false", as: "{{x}}"
    rewrite "false != {{x}}", as: "{{x}}"
    rewrite "{{x}} == false", as: "!{{x}}"
    rewrite "false == {{x}}", as: "!{{x}}"
    rewrite "{{x}} != true", as: "!{{x}}"
    rewrite "true != {{x}}", as: "!{{x}}"

    # Drop `readonly`.
    # readonly int x; == int x;
    drop "readonly", inside: "class A { ... int x; }"

    # The declarations of names that can hide one of a class's members.
    LOCALS = %w[parameter variable_declarator foreach_statement catch_declaration declaration_expression
                declaration_pattern].freeze

    # The declarations of a class's members, apart from fields.
    MEMBERS = %w[method_declaration property_declaration event_declaration].freeze

    def call
      root = super
      drop_this_and_class_name_before_own_members!(root)
      drop_empty_brackets_from_new_with_initializer!(root)

      # Drop the `readonly` of a `ref readonly` too, which isn't a modifier.
      # ref readonly int F() == ref int F()
      drop_tokens(root, everywhere: %w[readonly])
      add_braces_to_if_and_else_bodies!(root)
      write_every_dictionary_initialiser_the_same_way!(root)
      root
    end

    private
    # Drop `this.` and the class's own name before one of the class's members,
    # as Roslyn's simplifier does, unless a parameter or local variable has
    # the same name.
    #
    # e.g. We convert:
    # class Counter
    # {
    #     int count;
    #     static int Start() => 1;
    #     void Reset() { this.count = Counter.Start(); }
    # }
    #
    # internally into:
    # void Reset() { count = Start(); }
    def drop_this_and_class_name_before_own_members!(root)
      each_node(root) do |type, _|
        next unless %w[class_declaration struct_declaration record_declaration].include?(type.type) && type[:body]

        names = member_names(type[:body]) - local_names(type)
        drop_own_qualifiers_before_names!(type, names) if names.any?
      end
    end

    def member_names(body)
      fields = captured(body, "(field_declaration (variable_declaration (variable_declarator name: (identifier) @name)*))")
      members = body.children.filter_map { |member| member[:name] if MEMBERS.include?(member.type) }
      (fields + members).select(&:leaf?).to_set(&:text)
    end

    def local_names(type)
      locals = Set.new
      type[:body].children.each do |member|
        next if member.type == "field_declaration"

        each_node(member) do |node, _|
          next unless LOCALS.include?(node.type)

          name = node[:name] || node[:left]
          locals << name.text if name&.type == "identifier"
        end
      end
      locals
    end

    def drop_own_qualifiers_before_names!(type, names)
      own = ->(qualifier) { qualifier.type == "this" || (qualifier.type == "identifier" && qualifier.text == type[:name].text) }
      transform(type, "(member_access_expression expression: _ @qualifier name: (identifier) @name)") do |match|
        match[:name] if names.include?(match[:name].text) && own.(match[:qualifier])
      end
    end

    # Drop empty brackets after the type of a `new` with an initializer, as
    # Roslyn's simplifier does.
    # new List<int>() { 1 } == new List<int> { 1 }
    def drop_empty_brackets_from_new_with_initializer!(root)
      find_all(root, "(object_creation_expression arguments: (argument_list) @arguments initializer: (_))").each do |match|
        match.node.children.delete(match[:arguments]) if match[:arguments].children.empty?
      end
    end

    # Put the body of each `if` and `else` in braces. As in the old
    # representer, this also puts an `else if` in braces.
    #
    # e.g. We convert:
    # if (x) y(); else if (z) w();
    #
    # internally into:
    # if (x) { y(); } else { if (z) { w(); } }
    def add_braces_to_if_and_else_bodies!(root)
      each_node(root) do |node, _|
        next unless node.type == "if_statement"

        [node[:consequence], node[:alternative]].compact.each do |body|
          node.replace_child(body, build(:block, body)) unless body.type == "block"
        end
      end
    end

    # Write each `[key] = value` entry of a new dictionary as `{ key, value }`.
    # new Dictionary<int, string> { [1] = "a" } == new Dictionary<int, string> { { 1, "a" } }
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
