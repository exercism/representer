# Ruby's Rename stage marks the names that the solution gives their whole
# meaning, and the engine then writes a placeholder for each of them. These
# names are the student's:
#
# - Parameters of methods, blocks and lambdas, and assigned local variables.
# - Instance variables and class variables.
# - Global variables that the solution assigns. Other globals, such as
#   `$stdout`, are Ruby's.
# - Instance methods that the solution defines with `def`, and the methods
#   that `attr_reader`, `attr_writer` and `attr_accessor` define.
# - Classes and modules that the solution defines.
#
# A name after a dot or `::`, and every symbol, refers to a method. It is
# only renamed if the solution defines a method with that name, so
# `count = 0; xs.map(&:count)` keeps `:count`.
#
# These names are kept:
#
# - Every name used in the exercise's tests, and the members that its stub
#   defines (the engine finds these).
# - Keyword parameters, which callers pass by name.
# - A method that the solution names after one of Ruby's own methods (see
#   library_names/ruby.txt), so `def sum(a) = a.sum` and
#   `def max(a) = a.max` stay apart.
# - Methods defined with `def self.`, and constants, as the old representer
#   kept them.
#
# Renaming goes by name: every use of a renamed name gets the same
# placeholder. Update this list whenever the class changes.
module Representer
  module Languages
    module Ruby
      class Rename
        include Mandate
        include Engine::TreeHelpers

        initialize_with :trees, :kept_names

        LOCALS = [
          "[(method_parameters (identifier)* @name) (block_parameters (identifier)* @name)]",
          "[(optional_parameter name: (_) @name) (splat_parameter name: (_) @name)]",
          "[(hash_splat_parameter name: (_) @name) (block_parameter name: (_) @name)]",
          "(destructured_parameter (identifier)* @name)",
          "[(assignment left: (identifier) @name) (operator_assignment left: (identifier) @name)]",
          "[(left_assignment_list (identifier)* @name) (rest_assignment (identifier) @name)]",
          "[(for pattern: (identifier) @name) (exception_variable (identifier) @name)]",
          "[(instance_variable) @name (class_variable) @name]",
          "[(assignment left: (global_variable) @name) (operator_assignment left: (global_variable) @name)]",
          "(left_assignment_list (global_variable)* @name)"
        ].freeze

        MEMBERS = [
          "(method name: (_) @name)",
          "[(class name: (constant) @name) (module name: (constant) @name)]",
          "[(class name: (scope_resolution name: (constant) @name)) (module name: (scope_resolution name: (constant) @name))]",
          "(call !receiver method: (identifier /\\Aattr_(reader|writer|accessor)\\z/)
            arguments: (argument_list (simple_symbol)* @name))"
        ].freeze

        MEMBER_USES = [
          "(call receiver: (_) method: (_) @name)",
          "(scope_resolution scope: (_) name: (_) @name)",
          "(simple_symbol) @name"
        ].freeze

        KEPT = ["(keyword_parameter name: (identifier) @name)"].freeze

        # Returns the names of the members that the trees define, which the
        # engine keeps when it reads them from an exercise's stub.
        def call
          members = names_in(trees, Ruby, *MEMBERS)
          kept = kept_names | names_in(trees, Ruby, *KEPT) | (members & Ruby.library)
          member_uses = MEMBER_USES.flat_map { |pattern| trees.flat_map { |tree| captured(tree, pattern) } }
          mark_student_names(trees, Ruby, names: names_in(trees, Ruby, *LOCALS) | members, members:, member_uses:, kept:)
          members
        end
      end
    end
  end
end
