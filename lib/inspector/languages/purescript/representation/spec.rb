module Inspector::Languages::PureScript::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename names that start with a lower case letter or a capital, and
    # operators, record labels and instance names.
    names_are :variable,          # «count»
              :constructor,       # «Circle»
              :type,              # «Shape»
              :type_variable,     # forall «a». «a» -> «a»
              :qualified_module,  # module «Leap» where
              :operator,          # a «+++» b
              :field_name,        # { «name» :: String }
              :instance_name      # instance «showShape» :: Show Shape

    # Rename the name of the module, and the names of functions, values
    # and operators, their parameters, and the variables in patterns.
    names_are_defined_by :pat_name,                       # area «width» «height» = ...
                         purescript: :name,               # module «Leap» where
                         function: :name,                 # «area» width height = ...
                         signature: :name,                # «area» :: Int -> Int -> Int
                         operator_declaration: :operator  # infixl 6 add as «+++»

    # Rename the names of types, classes and instances, and of their
    # constructors, record labels and type variables.
    names_are_defined_by :data,                 # data «Shape» «a» = «Circle» a | «Square» a
                         :newtype,              # newtype «Name» = ...
                         :newtype_constructor,  # newtype Name = «Name» String
                         :type_alias,           # type «Point» = { x :: Int }
                         :class_head,           # class Sized «a» where
                         :class_head_name,      # class «Sized» a where
                         :class_instance,       # instance «sizedShape» :: Sized Shape where
                         :derive_declaration,   # derive instance «eqShape» :: Eq Shape
                         :forall,               # forall «a». a -> a
                         :type_var,             # Show «a» => Show (Tree «a»)
                         :row_field,            # { «x» :: Int }
                         :record_field          # { «x»: 1 }

    # Drop these imports, because a solution that passes its tests has already
    # imported every module it needs.
    imports "import {{...}} ({{...}}) as {{...}}" # «import Data.Array (filter)», «import Data.Map as M»
  end
end
