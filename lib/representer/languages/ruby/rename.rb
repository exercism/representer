# Ruby's Rename stage decides which names are the student's, and the engine
# then writes a placeholder for each of them. This stage renames these
# names:
#
# - It renames each parameter of a method, block or lambda, and each local
#   variable assigned in the solution.
# - It renames each instance variable and class variable.
# - It renames each global variable assigned in the solution. Ruby's own
#   globals, such as `$stdout`, keep their names.
# - It renames each instance method defined with `def`, and each method
#   defined with `attr_reader`, `attr_writer` or `attr_accessor`.
# - It renames each class and module defined in the solution.
#
# A name after a dot or `::` refers to a method or a constant, and so does
# a symbol. The engine only renames a name there if the solution defines a
# member with that name. So `count = 0; xs.map(&:count)` keeps `:count`.
#
# This stage keeps these names:
#
# - It keeps keyword parameters, because callers pass them by name.
# - It keeps methods defined with `def self.`, and constants, because the
#   old representer kept them.
#
# The engine also keeps every name used in the exercise's tests, the
# members defined in its stub, and each method named after one of Ruby's
# own methods (see library_names/ruby.txt).
#
# Renaming goes by name, so every use of a renamed name gets the same
# placeholder. Update this list whenever the class changes.
module Representer
  module Languages
    module Ruby
      class Rename
        extend Engine::RenameStage

        # Ruby's operator assignments, such as `x += 1` and `x ||= 1`.
        OPERATORS = ["+=", "-=", "*=", "/=", "%=", "**=", "<<=", ">>=", "&=", "|=", "^=", "&&=", "||="].freeze

        # In these patterns, `@$name` matches an instance variable, and
        # `$$name` matches a global variable, because Ruby writes a global as
        # `$name`. A capitalised `$Name` matches a constant.

        # An assignment names a local variable, or a global variable that
        # belongs to the solution.
        rename_locals "$name = $value", "$$name = $value"
        rename_locals(*OPERATORS.flat_map { |operator| ["$name #{operator} $value", "$$name #{operator} $value"] })
        rename_locals "$name, $more", "$$name, $more", "*$name", inside: "... = $value"

        # A parameter names a local variable. The patterns with a context
        # match a parameter in a method, a block or a lambda.
        rename_locals "def $method($name)", "def $object.$method($name)", "{ |$name| }"
        rename_locals "$name = $default", "*$name", "**$name", "&$name", "($name)", inside: "def f(...) end"

        # A `for` loop and a `rescue` also name a local variable.
        rename_locals "for $name in $list", "rescue => $name", "rescue $errors => $name"

        rename_locals "@$name", "@@$name"

        rename_members "def $name", "def $Name", "class $name", "module $name"
        rename_members "class $Scope::$name", "module $Scope::$name"
        rename_members "attr_reader :$name", "attr_writer :$name", "attr_accessor :$name"

        rename_member_uses "$object.$name", "$object.$Name", "$Scope::$Name", ":$name"

        keep "$name:", inside: "def f(...) end"
      end
    end
  end
end
