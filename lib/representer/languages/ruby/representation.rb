# This file declares the settings of Ruby's representation.
# REPRESENTER_DSL.md explains each declaration, and the stages that only
# the representation needs are in `representation/`.
module Representer::Languages::Ruby
  class Representation < Representer::Engine::Representation
    version 12

    # Rename identifiers, constants and variables.
    names_are :identifier,         # «count»
              :constant,           # «Counter»
              :instance_variable,  # «@count»
              :class_variable,     # «@@count»
              :global_variable     # «$count»

    # Rename a symbol such as `:count` as the name `count`, without the colon.
    names_are :simple_symbol, without_prefix: ":" # :«count»

    # Rename the names of classes and modules.
    names_are_defined_by :class,  # class «Counter» ... end
                         :module  # module «Counting» ... end

    # Rename the names of methods.
    names_are_defined_by method: :name,           # def «area»(width) ... end
                         singleton_method: :name  # def self.«area»(width) ... end

    # Rename the parameters of methods, blocks and lambdas.
    names_are_defined_by :method_parameters,         # def area(«width», «height»)
                         :block_parameters,          # xs.map { |«x»| x * 2 }
                         :destructured_parameter,    # pairs.each { |(«key», «value»)| ... }
                         :splat_parameter,           # def sum(*«numbers»)
                         :hash_splat_parameter,      # def build(**«options»)
                         :block_parameter,           # def each(&«block»)
                         optional_parameter: :name,  # def greet(«name» = "you")
                         keyword_parameter: :name    # def greet(«name»:)

    # Rename the names on the left of an assignment, and leave the right alone.
    names_are_defined_by :left_assignment_list,          # «first», «second» = pair
                         :rest_assignment,               # first, *«rest» = list
                         :destructured_left_assignment,  # («a», «b»), c = pairs
                         assignment: :left,              # «total» = price * 2
                         operator_assignment: :left      # «total» += 1

    # Rename the variables of `rescue` and `for`.
    names_are_defined_by :exception_variable,  # rescue ArgumentError => «error»
                         for: :pattern         # for «item» in items

    # Drop these imports, because a solution that passes its tests has already
    # loaded everything it needs.
    imports 'require "{{...}}"',          # «require "set"»
            'require_relative "{{...}}"'  # «require_relative "helpers"»
  end
end
