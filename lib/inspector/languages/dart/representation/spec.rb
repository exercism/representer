module Inspector::Languages::Dart::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename identifiers and the names of types.
    names_are :identifier,      # «count»
              :type_identifier  # «Counter»

    # Rename the names of classes, mixins, extensions, enums and type
    # aliases, and their type parameters.
    names_are_defined_by :type_parameter,               # class Box<«T»> { ... }
                         class_definition: :name,       # class «Counter» { ... }
                         mixin_declaration: :name,      # mixin «Walker» on Animal { ... }
                         extension_declaration: :name,  # extension «Doubler» on int { ... }
                         enum_declaration: :name,       # enum «Color» { red }
                         type_alias: :name              # typedef «Grid» = List<List<int>>;

    # Rename the names of functions, methods, getters, setters, constructors
    # and enum values.
    names_are_defined_by :factory_constructor_signature,  # factory «Shape».«make»() => ...
                         :constant_constructor_signature, # const «Point»(this.x);
                         function_signature: :name,       # int «area»(int width) { ... }
                         getter_signature: :name,         # int get «count» => 1;
                         setter_signature: :name,         # set «count»(int v) { ... }
                         constructor_signature: :name,    # «Shape».«named»(this.name);
                         enum_constant: :name             # enum Color { «red», «green» }

    # Rename fields, variables and parameters, including the named fields of
    # records and the parameters of function types.
    names_are_defined_by initialized_identifier: :name,           # int «count» = 0;
                         static_final_declaration: :name,         # static const «max» = 10;
                         initialized_variable_definition: :name,  # var «total» = 0;
                         formal_parameter: :name,                 # int area(int «width»), («x») => x
                         typed_identifier: :name                  # ({int «moves»}), int Function(int «acc»)

    # Rename the variables of loops, `catch`, patterns and labels.
    names_are_defined_by :catch_parameters,         # catch («e», «s»)
                         :labeled_statement,        # «outer»: while (true)
                         for_loop_parts: :name,     # for (final «item» in items)
                         variable_pattern: :name    # case int «z» when z > 3:

    # Drop these imports and exports, because a solution that passes its tests
    # has already made every name it needs available.
    imports "import '{{_}}';",                 # «import 'dart:math';»
            "import '{{_}}' as {{_}};",        # «import 'dart:math' as math;»
            "import '{{_}}' show {{...}};",    # «import 'dart:math' show max;»
            "import '{{_}}' hide {{...}};",    # «import 'dart:math' hide min;»
            "export '{{_}}';"                  # «export 'src/leap.dart';»
  end
end
