module Representer::Languages::Idris
  class Representation < Representer::Engine::Representation
    version 6

    # Rename names that start with a lower case letter or a capital, the
    # names of data types, and the fields in record updates.
    names_are :loname,     # «count»
              :caname,     # «Shape»
              :data_name,  # data «Shape» = Circle | Square
              :field_name  # {«count» $= S} robot

    # Rename the name of the module, and the names of functions, values,
    # their parameters and the variables in patterns.
    names_are_defined_by :pat_name,               # area «width» «height» = ...
                         :exp_list_comprehension, # [x * 2 | «x» <- xs]
                         module: :name,           # module «Leap»
                         namespace: :name,        # namespace «Helpers»
                         signature: :name,        # «area» : Int -> Int -> Int
                         funvar: :subject         # «area» width height = ...

    # Rename the names of types, interfaces and records, and of their
    # constructors, fields and type variables.
    names_are_defined_by :data,                 # data «Tree» «a» = Leaf | Node (Tree a) a (Tree a)
                         :data_constructor,     # data Shape = «Circle» Double | «Square» Double
                         :type_variable,        # length : List «a» -> Nat
                         :type_var,             # index : («n» : Nat) -> Vect n a -> a
                         :record_field,         # record Point where «x» : Int
                         record: :name,         # record «Point» where
                         constructor: :name,    # constructor «MkPoint»
                         interface_head: :name  # interface «Sized» a where

    # Drop these imports, because a solution that passes its tests has already
    # imported every module it needs.
    imports "import {{...}} as {{...}}", # «import Data.List», «import Data.Vect as V»
            "import public {{...}}"      # «import public Data.List»
  end
end
