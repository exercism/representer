module Rosetta::Languages::Gleam::Representation
  class Spec < Rosetta::Engine::Representation
    version 7

    # Rename names, types, constructors and labels. The grammar calls a
    # record's field a label, and the name after the dot of `p.age` too.
    names_are :identifier,        # «count»
              :type_identifier,   # «Shape»
              :constructor_name,  # «Circle»
              :label              # p.«age»

    # Rename the names of functions, constants, types, constructors and fields.
    names_are_defined_by function: :name,                  # pub fn «area»(width: Int) -> Int { ... }
                         external_function: :name,         # @external(erlang, "m", "f") fn «now»() -> Int
                         constant: :name,                  # const «limit» = 10
                         type_name: :name,                 # pub type «Shape» { ... }
                         data_constructor: :name,          # pub type Shape { «Circle»(radius: Float) }
                         data_constructor_argument: :label # pub type Shape { Circle(«radius»: Float) }

    # Rename parameters, and every variable bound by a pattern.
    names_are_defined_by :variable,                # let «total» = price * 2
                         function_parameter: :name # pub fn area(with «width»: Int)

    # Drop these imports, because a solution that passes its tests has already
    # made every module it needs available.
    imports "import {{_}}.{ {{...}} } as {{...}}" # «import gleam/list», «import gleam/dict.{type Dict} as d»
  end
end
