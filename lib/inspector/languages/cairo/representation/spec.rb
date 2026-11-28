module Inspector::Languages::Cairo::Representation
  class Spec < Inspector::Engine::Representation
    version 5

    # Rename identifiers, fields and the names of types.
    names_are :identifier,                  # «count»
              :field_identifier,            # self.«count»
              :shorthand_field_identifier,  # let Point { mut «x» } = p;
              :type_identifier              # «Counter»

    # Rename the names of modules, types and their parameters.
    names_are_defined_by :type_parameters,     # struct Wrapper<«T»> { ... }
                         mod_item: :name,      # mod «shapes» { ... }
                         struct_item: :name,   # struct «Point» { ... }
                         enum_item: :name,     # enum «Color» { Red }
                         trait_item: :name,    # trait «Shape»<T> { ... }
                         impl_item: :name,     # impl «PointShape» of Shape<Point> { ... }
                         type_item: :name      # type «Grid» = Array<u8>;

    # Rename the names of functions, constants, fields and enum variants.
    names_are_defined_by function: :name,           # fn «area»(width: u32) -> u32 { ... }
                         const_item: :name,         # const «MAX»: u32 = 10;
                         field_declaration: :name,  # struct Point { «x»: u32 }
                         enum_variant: :variant     # enum Color { «Red», «Green» }

    # Rename local variables and parameters.
    names_are_defined_by :closure_parameters,        # |«a», «b»| a + b
                         let_declaration: :pattern,  # let «total» = 0;
                         parameter: :pattern         # fn area(«width»: u32)

    # Rename the variables that loops, `if let` and patterns bind.
    names_are_defined_by :tuple_pattern,             # let («a», «b») = pair;
                         :tuple_enum_pattern,        # Option::Some(«value») => value
                         :slice_pattern,             # [«first», ..] => first
                         :match_pattern,             # «other» => 0
                         :mut_pattern,               # (mut «count», _)
                         for_expression: :pattern,   # for «item» in items
                         let_condition: :pattern,    # if let «value» = x
                         field_pattern: :pattern     # let Point { x: «a», .. } = p;

    # Drop these imports, because a solution that passes its tests has already
    # made every name it needs available.
    imports "use {{...}};",     # «use core::dict::Felt252Dict;»
            "pub use {{...}};"  # «pub use core::dict::Felt252Dict;»
  end
end
