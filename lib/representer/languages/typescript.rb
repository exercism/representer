require_relative "javascript"

module Representer
  module Languages
    class TypeScript < Language
      tracks "typescript"
      version 5
      grammar "typescript"
      extensions ".ts", ".mts", ".cts", ".tsx"

      # TypeScript is JavaScript plus types, so it starts from JavaScript's
      # rules and adds the rules for types, parameter properties and so on.
      inherit JavaScript

      # Names of types are names too.
      names :identifier, :property_identifier, :private_property_identifier, :statement_identifier, :type_identifier

      ### Rewrite ###

      # `(x) => x` is `x => x`.
      rewrite <<~PATTERN,
        (arrow_function parameters: (formal_parameters
          (required_parameter pattern: (identifier) @parameter) @required) @parameters)
      PATTERN
        where: ->(match) { match[:parameters].children.size == 1 && match[:required].children.size == 1 } do |match|
        match.node.replace_child(match[:parameters], match[:parameter])
        match[:parameter].field = "parameter"
        match.node
      end

      ### Rename and keep ###

      # Parameters, including the ones in function types and signatures.
      rename "[(required_parameter pattern: (identifier) @name) (optional_parameter pattern: (identifier) @name)]"
      rename "[(required_parameter pattern: (rest_pattern (identifier) @name)) (index_signature name: (identifier) @name)]"
      rename "[(required_parameter pattern: (array_pattern (identifier)* @name)) (type_predicate name: (identifier) @name)]"
      rename "[(function_signature name: (identifier) @name) (mapped_type_clause name: (type_identifier) @name)]"

      # Types the student defines, and their type parameters.
      rename "[(class_declaration name: (type_identifier) @name) (abstract_class_declaration name: (type_identifier) @name)]"
      rename "[(interface_declaration name: (type_identifier) @name) (type_alias_declaration name: (type_identifier) @name)]"
      rename "[(enum_declaration name: (identifier) @name) (type_parameter name: (type_identifier) @name)]"
      rename "(infer_type (type_identifier) @name)"

      # Properties, methods and enum members declared in classes, interfaces
      # and enums, and constructor parameters that also declare a property.
      rename_member "[(public_field_definition name: (_) @name) (property_signature name: (property_identifier) @name)]"
      rename_member "[(method_signature name: (property_identifier) @name) (abstract_method_signature name: (_) @name)]"
      rename_member "[(enum_body (property_identifier)* @name) (enum_assignment name: (property_identifier) @name)]"
      rename_member "(required_parameter (accessibility_modifier) pattern: (identifier) @name)"
      rename_member "(required_parameter \"readonly\" pattern: (identifier) @name)"
      rename_member "(optional_parameter (accessibility_modifier) pattern: (identifier) @name)"

      # Names after a dot in a type, such as `Namespace.Type`.
      member "(nested_type_identifier name: (_) @name)"

      # Exported types are part of the exercise's interface, like exported
      # functions.
      keep <<~PATTERN
        (export_statement declaration: [
          (interface_declaration name: (type_identifier) @name)
          (type_alias_declaration name: (type_identifier) @name)
          (enum_declaration name: (identifier) @name)
          (abstract_class_declaration name: (type_identifier) @name)])
      PATTERN
      keep "(export_specifier name: (identifier) @name)"

      library_names File.join(__dir__, "library_names", "javascript.txt")
    end
  end
end
