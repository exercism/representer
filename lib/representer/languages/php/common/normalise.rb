# docs/dsl.md defines the verbs and helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. These rules
# give one form to spellings that PHP reads the same way, for every output.
module Representer::Languages::PHP::Common
  class Normalise < Representer::Engine::Normalise
    # Put braces around the body of each `if`, `else` and loop, because the
    # parser reads a body with or without braces the same way.
    # if ($x) y(); else z();  ->  if ($x) { y(); } else { z(); }
    # if ($x) y(); else if ($z) w();  ->  if ($x) { y(); } else { if ($z) { w(); } }
    add_braces_to "if ({{...}}) {{body}}",
                  "while ({{...}}) {{body}}",
                  "for (;;) {{body}}",
                  "foreach ({{...}} as {{...}}) {{body}}",
                  "do {{body}} while ({{...}});"
    add_braces_to "elseif ({{...}}) {{body}}",
                  "else {{body}}",
        inside: "<?php if (true) { } {{pattern}}"

    def call
      super.tap do |root|
        drop_the_backslash_before_global_names!(root)
        write_each_function_method_and_class_name_in_one_case!(root)
      end
    end

    private
    ### Global names ###

    # Drop the `\` before the name of a function or class in a call or a
    # `new`, because the name is the same without it.
    # \strlen($s)  ->  strlen($s)
    # new \DateTime()  ->  new DateTime()
    def drop_the_backslash_before_global_names!(root)
      pattern = "[(function_call_expression function: (qualified_name) @name) " \
                "(object_creation_expression (qualified_name) @name) " \
                "(scoped_call_expression scope: (qualified_name) @name)]"
      find_all(root, pattern).each do |match|
        name = match[:name]
        next unless name.named_children.one? && name.children.any? { |child| child.text == "\\" }

        leaf = name.named_children.first
        leaf.field = name.field
        match.node.replace_child(name, leaf)
      end
    end

    ### Case ###

    # Write every spelling of a function, method or class name the same way,
    # because PHP ignores the case of the letters A to Z in them. A name
    # defined in the file gets the spelling it has most often, and a function
    # that the file doesn't define gets lower case.
    #
    # function isLeap() {} ... ISLEAP()  ->  function isLeap() {} ... isLeap()
    # STRLEN($s)  ->  strlen($s)
    def write_each_function_method_and_class_name_in_one_case!(root)
      names = name_positions(root)
      defined = names.select { |_, _, definition| definition }.to_set { |kind, leaf, _| [kind, leaf.text.downcase(:ascii)] }
      names.group_by { |kind, leaf, _| [kind, leaf.text.downcase(:ascii)] }.each do |key, uses|
        leaves = uses.map { |_, leaf, _| leaf }
        spelling = defined.include?(key) ? most_common(leaves.map(&:text)) : (key.last if key.first == :function)
        leaves.each { |leaf| leaf.text = spelling } if spelling
      end
    end

    def most_common(texts) = texts.tally.max_by { |text, count| [count, -texts.index(text)] }.first

    # Return each name of a function, method or class: [kind, leaf, whether
    # it defines the name].
    def name_positions(root)
      found = []
      each_node(root) do |node, _|
        node.children.each_with_index do |child, index|
          next unless child.type == "name" && child.leaf?

          kind, definition = name_kind(node, child, index)
          found << [kind, child, definition] if kind
        end
      end
      found
    end

    def name_kind(parent, child, index)
      case parent.type
      when "function_definition" then [:function, true] if child.field == "name"
      when "function_call_expression" then [:function, false] if child.field == "function"
      when "method_declaration" then [:method, true] if child.field == "name"
      when "member_call_expression", "nullsafe_member_call_expression" then [:method, false] if child.field == "name"
      when "scoped_call_expression" then child.field == "name" ? [:method, false] : [:class, false]
      when "class_declaration", "interface_declaration", "trait_declaration", "enum_declaration"
        [:class, child.field == "name"]
      when "object_creation_expression", "base_clause", "class_interface_clause", "named_type", "use_declaration"
        [:class, false]
      when "class_constant_access_expression", "scoped_property_access_expression" then [:class, false] if index.zero?
      end
    end
  end
end
