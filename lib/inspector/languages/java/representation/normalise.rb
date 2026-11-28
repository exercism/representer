# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here gives one form to spellings that Java reads the same way.
module Inspector::Languages::Java::Representation
  class Normalise < Inspector::Engine::Normalise
    # Drop the package declaration, because the engine leaves out where each
    # file lives.
    # package leap;  ->  (nothing)
    drop "package {{...}};"

    # Put braces around the body of each `if`, `else` and loop, including an
    # `else if`.
    # if (x) y(); else if (z) w();  ->  if (x) { y(); } else { if (z) { w(); } }
    # while (x) y();  ->  while (x) { y(); }
    add_braces_to "if ({{...}}) {{body}}",
                  "if ({{...}}) { } else {{body}}",
                  "for (;;) {{body}}",
                  "for (int {{...}} : {{...}}) {{body}}",
                  "while ({{...}}) {{body}}",
                  "do {{body}} while ({{...}});"

    def call
      super.tap do |root|
        drop_package_names_before_class_names!(root)
      end
    end

    private
    # Drop the package names before a class name from `java` and `javax`, as
    # an import of every class would.
    # java.util.List<String>  ->  List<String>
    # java.util.Arrays.asList(1)  ->  Arrays.asList(1)
    def drop_package_names_before_class_names!(root)
      transform(root, "[(scoped_type_identifier) (field_access)] @name") do |match|
        match.node.named_children.last if package_qualified?(match.node)
      end
    end

    # Whether the name is a class name after package names that start with
    # `java` or `javax`, such as `java.util.function.Function`.
    def package_qualified?(node)
      parts = qualified_parts(node)
      return false unless parts && parts.size > 2

      ["java", "javax"].include?(parts.first) && parts[0...-1].all? { |part| part.match?(/\A[a-z]/) } &&
        parts.last.match?(/\A[A-Z]/)
    end

    # The names in a dotted name, such as ["java", "util", "List"], or nil
    # if it holds anything else, such as a call.
    def qualified_parts(node)
      case node.type
      when "identifier", "type_identifier" then [node.text]
      when "field_access", "scoped_type_identifier"
        parts = node.named_children.map { |child| qualified_parts(child) }
        parts.include?(nil) ? nil : parts.flatten
      end
    end
  end
end
