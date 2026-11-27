# This file declares how the representer reads Ruby. REPRESENTER_DSL.md
# explains each declaration, and the other files in this folder hold Ruby's
# stages.
module Representer::Languages::Ruby
  class Spec < Representer::Engine::Language
    tracks "ruby"
    version 12
    grammar "ruby"
    extensions ".rb"

    names_are :identifier,         # «count»
              :constant,           # «Counter»
              :instance_variable,  # «@count»
              :class_variable,     # «@@count»
              :global_variable     # «$count»

    # A symbol such as `:count` refers to the name `count`, so the colon isn't
    # part of the name.
    names_are :simple_symbol, without_prefix: ":" # :«count»

    # A class or a module defines its name.
    names_are_defined_by :class,  # class «Counter» ... end
                         :module  # module «Counting» ... end

    # A method defines its name.
    names_are_defined_by method: :name,           # def «area»(width) ... end
                         singleton_method: :name  # def self.«area»(width) ... end

    # The parameters of a method, a block or a lambda define their names.
    names_are_defined_by :method_parameters,         # def area(«width», «height»)
                         :block_parameters,          # xs.map { |«x»| x * 2 }
                         :destructured_parameter,    # pairs.each { |(«key», «value»)| ... }
                         :splat_parameter,           # def sum(*«numbers»)
                         :hash_splat_parameter,      # def build(**«options»)
                         :block_parameter,           # def each(&«block»)
                         optional_parameter: :name,  # def greet(«name» = "you")
                         keyword_parameter: :name    # def greet(«name»:)

    # An assignment defines only the names on its left.
    names_are_defined_by :left_assignment_list,          # «first», «second» = pair
                         :rest_assignment,               # first, *«rest» = list
                         :destructured_left_assignment,  # («a», «b»), c = pairs
                         assignment: :left,              # «total» = price * 2
                         operator_assignment: :left      # «total» += 1

    # The variable of a `rescue` and the variable of a `for` loop are
    # definitions.
    names_are_defined_by :exception_variable,  # rescue ArgumentError => «error»
                         for: :pattern         # for «item» in items

    # A solution that passes its tests has already loaded everything it
    # needs, so the engine drops these imports.
    imports 'require "{{file}}"',          # «require "set"»
            'require_relative "{{file}}"'  # «require_relative "helpers"»
  end
end
