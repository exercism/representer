# Ruby's representer has four stages, each in its own file in ruby/:
#
# - GenerateAST turns tree-sitter's tree into the tree that Ruby's own
#   parser would give.
# - Normalise drops `require` and `require_relative`.
# - Rename marks the names that the solution gives their whole meaning.
# - Reorder sorts nothing yet.
#
# The comment at the top of each file lists everything that stage does.
module Representer
  module Languages
    module Ruby
      extend StagedLanguage

      tracks "ruby"
      version 8
      grammar "ruby"
      extensions ".rb"

      names :identifier, :constant, :instance_variable, :class_variable, :global_variable, simple_symbol: ":"

      library_names File.join(__dir__, "library_names", "ruby.txt")
    end
  end
end

require_relative "ruby/generate_ast"
require_relative "ruby/normalise"
require_relative "ruby/rename"
require_relative "ruby/reorder"
