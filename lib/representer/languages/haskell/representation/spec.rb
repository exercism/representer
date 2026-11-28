module Representer::Languages::Haskell::Representation
  class Spec < Representer::Engine::Representation
    version 6

    # Rename names that start with a lower case letter or a capital, and
    # operators.
    names_are :variable,             # «count»
              :name,                 # «Shape»
              :constructor,          # «Circle»
              :module_id,            # «Leap»
              :operator,             # a «|>» f
              :constructor_operator  # a «:+» b

    # Rename the name of the module, and the names of functions, values
    # and operators, their parameters, and the variables in patterns.
    names_are_defined_by :module_name,          # module «Leap» (isLeapYear) where
                         :binding_list,         # «width», «height» :: Int
                         :variable_pattern,     # area «width» «height» = ...
                         function: :name,       # «area» width height = ...
                         bind: :name,           # «total» = 0
                         signature: :name,      # «area» :: Int -> Int -> Int
                         infix_head: :operator  # x «|>» f = f x

    # Rename the names of types and classes, and of their constructors,
    # fields and type variables.
    names_are_defined_by :type_variable,               # area :: «a» -> «a»
                         :field_name,                  # data Point = Point { «x» :: Int }
                         data_type: :name,             # data «Shape» = ...
                         newtype: :name,               # newtype «Name» = ...
                         type_synonym: :name,          # type «Grid» = [[Int]]
                         class: :name,                 # class «Sized» a where ...
                         prefix: :name,                # data Shape = «Circle» Double
                         record: :name,                # data Point = «Point» { x :: Int }
                         infix_constructor: :operator, # data Complex = Double «:+» Double
                         newtype_constructor: :name,   # newtype Name = «Name» String
                         gadt_constructor: :name       # data Shape where «Circle» :: Double -> Shape

    # Drop these imports, because a solution that passes its tests has already
    # imported every module it needs.
    imports "import {{...}} as {{...}} ({{...}})",                 # «import Data.List (sort)»
            "import {{...}} as {{...}} hiding ({{...}})",          # «import Prelude hiding (lookup)»
            "import qualified {{...}} as {{...}} ({{...}})",       # «import qualified Data.Map as Map»
            "import qualified {{...}} as {{...}} hiding ({{...}})" # «import qualified Data.Map as M hiding (map)»
  end
end
