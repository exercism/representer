module Rosetta::Languages::Coffeescript::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename identifiers and the names of properties, including the
    # shorthand ones in objects.
    names_are :identifier,                    # «count»
              :property_identifier,           # @«count»
              :shorthand_property_identifier  # { «count» }

    # Rename the names of classes, and of their members, including the
    # properties set on `this` and on a prototype.
    names_are_defined_by class: :name,                  # class «Counter»
                         class_member: :key,            # «area»: -> width * height
                         this_property: :property,      # @«count» = 0
                         prototype_property: :property  # Array::«sum» = -> ...

    # Rename variables and parameters, including the ones in patterns.
    names_are_defined_by :array_pattern,          # [«first», «second»] = pair
                         :object_pattern,         # { «count» } = totals
                         :rest_pattern,           # [first, «rest»...] = list
                         pair_pattern: :value,    # { count: «total» } = totals
                         assignment: :left,       # «total» = price * 2
                         parameter: :name,        # («width», «height» = 1) ->
                         for_expression: :variable, # for «item», «index» in items
                         catch_clause: :parameter # catch «error»

    # Drop each assignment that only loads a module with `require`, because a
    # solution that passes its tests has already loaded everything it needs.
    imports '{{_}} = require "{{_}}"' # «Leap = require './leap'»
  end
end
