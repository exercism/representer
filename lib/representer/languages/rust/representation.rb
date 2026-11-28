module Representer::Languages::Rust
  class Representation < Representer::Engine::Representation
    version 9

    # Rename identifiers, fields and the names of types.
    names_are :identifier,        # «count»
              :field_identifier,  # self.«count»
              :type_identifier    # «Counter»

    # Rename the names of modules, types and their parameters.
    names_are_defined_by mod_item: :name,          # mod «shapes» { ... }
                         struct_item: :name,       # struct «Point» { ... }
                         enum_item: :name,         # enum «Color» { Red }
                         union_item: :name,        # union «Bits» { ... }
                         trait_item: :name,        # trait «Shape» { ... }
                         type_item: :name,         # type «Grid» = Vec<Vec<u8>>;
                         associated_type: :name,   # trait Shape { type «Unit»; }
                         type_parameter: :name,    # struct Wrapper<«T»>(T);
                         const_parameter: :name,   # struct Grid<const «N»: usize>;
                         lifetime: :name           # struct View<'«a»>(&'a str);

    # Rename the names of functions, constants, fields and enum variants.
    names_are_defined_by function_item: :name,            # fn «area»(width: u32) { ... }
                         function_signature_item: :name,  # trait Shape { fn «area»(&self) -> u32; }
                         const_item: :name,               # const «MAX»: u32 = 10;
                         static_item: :name,              # static «NAMES»: [&str; 2] = ["a", "b"];
                         field_declaration: :name,        # struct Point { «x»: i32 }
                         enum_variant: :name              # enum Color { «Red», «Green» }

    # Rename local variables, parameters and labels.
    names_are_defined_by :closure_parameters,        # |«a», «b»| a + b
                         :label,                     # '«outer»: loop { ... }
                         let_declaration: :pattern,  # let «total» = 0;
                         parameter: :pattern         # fn area(«width»: u32)

    # Rename the variables that loops, `if let` and patterns bind.
    names_are_defined_by :tuple_pattern,             # let («a», «b») = pair;
                         :tuple_struct_pattern,      # Some(«value») => value
                         :slice_pattern,             # [«first», ..] => first
                         :match_pattern,             # «other» => 0
                         :captured_pattern,          # «digit» @ 0..=9 => digit
                         :mut_pattern,               # (mut «count», _)
                         :ref_pattern,               # Some(ref «name»)
                         :reference_pattern,         # |&«x»| x * 2
                         for_expression: :pattern,   # for «item» in items
                         let_condition: :pattern,    # if let «value» = x
                         field_pattern: :pattern     # let Point { x: «a», .. } = p;

    # Drop these imports, because a solution that passes its tests has already
    # made every name it needs available.
    imports "use {{...}};",             # «use std::collections::HashMap;»
            "pub use {{...}};",         # «pub use std::fmt;»
            "pub(crate) use {{...}};",  # «pub(crate) use std::fmt;»
            "extern crate {{...}};"     # «extern crate regex;»
  end
end
