# Ruby's representer has one stage of its own, GenerateAST, in
# ruby/generate_ast.rb. It turns tree-sitter's tree into the tree given by
# Ruby's own parser, and the comment at the top of that file lists
# everything it does.
#
# This file declares Ruby's names and imports, and the engine does the rest:
#
# - A solution that passes its tests has already loaded everything it
#   needs, so the engine drops every `require` and `require_relative` of a
#   plain string.
# - The engine renames every name the solution defines, wherever the name
#   appears. A name counts as defined if one of the nodes listed in
#   names_are_defined_by defines it: a class, a module, a method, a
#   parameter of a method, block or lambda (keyword parameters included),
#   an assignment to a variable or a constant, a `for` loop or a `rescue`.
#   So a method's name is renamed in its `def`, in every call to it, and
#   in every symbol with its name, such as `:count` in `xs.map(&:count)`.
# - A name that the solution doesn't define keeps its name, such as a call
#   to a library method, or `$stdout`.
# - A name in Ruby's library names list keeps its name, even if the
#   solution defines it (see library_names/ruby.txt).
module Representer
  module Languages
    module Ruby
      extend StagedLanguage

      tracks "ruby"
      version 9
      grammar "ruby"
      extensions ".rb"

      names_are :identifier, :constant, :instance_variable, :class_variable, :global_variable, simple_symbol: ":"

      names_are_defined_by :class, :module,
        :method_parameters, :block_parameters, :destructured_parameter, :splat_parameter, :hash_splat_parameter,
        :block_parameter, :left_assignment_list, :rest_assignment, :destructured_left_assignment, :exception_variable,
        method: :name, singleton_method: :name, optional_parameter: :name, keyword_parameter: :name,
        assignment: :left, operator_assignment: :left, for: :pattern

      imports 'require "{{file}}"', 'require_relative "{{file}}"'
    end
  end
end

require_relative "ruby/generate_ast"
