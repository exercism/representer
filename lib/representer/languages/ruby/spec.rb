# REPRESENTER_DSL.md defines every declaration in this file. Ruby's stages
# are the other files in this folder.
module Representer::Languages::Ruby
  class Spec < Representer::Engine::Language
    tracks "ruby"
    version 11
    grammar "ruby"
    extensions ".rb"

    # Identifiers, constants and the three kinds of variable (`@x`, `@@x`
    # and `$x`) hold names.
    names_are :identifier,         # count
              :constant,           # Counter
              :instance_variable,  # @count
              :class_variable,     # @@count
              :global_variable     # $count

    # A symbol such as `:count` names the method `count`, so the colon isn't
    # part of the name.
    names_are :simple_symbol, without_prefix: ":" # :count

    # A class or a module defines its name.
    names_are_defined_by :class,  # class Counter ... end
                         :module  # module Counting ... end

    # A method defines its name.
    names_are_defined_by method: :name,           # def area(width) ... end
                         singleton_method: :name  # def self.area(width) ... end

    # The parameters of a method, a block or a lambda define their names.
    # This includes `*rest`, `**options`, `&block`, the parts of `|(a, b)|`,
    # and the names of `x = 1` and `key:`.
    names_are_defined_by :method_parameters,         # def area(width, height)
                         :block_parameters,          # xs.map { |x| x * 2 }
                         :destructured_parameter,    # pairs.each { |(key, value)| ... }
                         :splat_parameter,           # def sum(*numbers)
                         :hash_splat_parameter,      # def build(**options)
                         :block_parameter,           # def each(&block)
                         optional_parameter: :name,  # def greet(name = "you")
                         keyword_parameter: :name    # def greet(name:)

    # An assignment defines the variable or constant on its left, so `x = y`
    # defines `x` and not `y`. This includes `x += 1`, `a, b = ...`,
    # `*rest = ...` and `(a, b), c = ...`.
    names_are_defined_by :left_assignment_list,          # first, second = pair
                         :rest_assignment,               # first, *rest = list
                         :destructured_left_assignment,  # (a, b), c = pairs
                         assignment: :left,              # total = 0
                         operator_assignment: :left      # total += 1

    # `for x in xs` defines `x`, and `rescue => e` defines `e`.
    names_are_defined_by :exception_variable,  # rescue ArgumentError => error
                         for: :pattern         # for item in items

    # A solution that passes its tests has already loaded everything it
    # needs, so the engine drops every `require` and `require_relative` of a
    # plain string.
    imports 'require "{{file}}"',          # require "set"
            'require_relative "{{file}}"'  # require_relative "helpers"
  end
end
