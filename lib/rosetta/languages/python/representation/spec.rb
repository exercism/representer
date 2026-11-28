module Rosetta::Languages::Python::Representation
  class Spec < Rosetta::Engine::Representation
    version 9

    # Rename identifiers.
    names_are :identifier # «count»

    # Rename the names of functions and classes.
    names_are_defined_by function_definition: :name,  # def «area»(width): ...
                         class_definition: :name      # class «Counter»: ...

    # Rename parameters, and the names given to keyword arguments.
    names_are_defined_by :parameters,                # def area(«width», «height»)
                         :lambda_parameters,         # lambda «x»: x * 2
                         :list_splat_pattern,        # def total(*«numbers»)
                         :dictionary_splat_pattern,  # def build(**«options»)
                         default_parameter: :name,   # def greet(«name»="you")
                         keyword_argument: :name     # sorted(words, «key»=len)

    # Rename the names that are assigned to, and leave the right alone.
    names_are_defined_by :tuple_pattern,                # «first», «second» = pair
                         :list_pattern,                 # [«first», «second»] = pair
                         :global_statement,             # global «count»
                         assignment: :left,             # «total» = price * 2
                         augmented_assignment: :left,   # «total» += 1
                         named_expression: :name,       # if («match» := find(x)):
                         attribute: :name               # self.«count» = 0

    # Rename the variables of loops, comprehensions, `with` and `except`.
    names_are_defined_by :as_pattern_target,     # except ValueError as «error»:
                         for_statement: :left,   # for «item» in items:
                         for_in_clause: :left    # [x * 2 for «x» in xs]

    # Drop these imports, because a solution that passes its tests has already
    # imported everything it needs. Drop `__all__` too, because it only lists
    # what the module exports. Keep `from __future__` imports, because they
    # change how Python reads the file.
    imports "import {{...}}",                         # «import math»
            "import {{...}} as {{...}}",              # «import numpy as np»
            "from {{...}} import {{...}}",            # «from math import sqrt»
            "from {{...}} import {{...}} as {{...}}", # «from math import sqrt as root»
            "from {{...}} import *",                  # «from math import *»
            "__all__ = {{...}}"                       # «__all__ = ["slices"]»
  end
end
