# Ruby's representer has four stages, and each one has its own file in
# ruby/:
#
# - GenerateAST turns tree-sitter's tree into the tree given by Ruby's own
#   parser.
# - Normalise makes no changes of its own.
# - Rename decides which names are the student's.
# - Reorder keeps the order of everything.
#
# A solution that passes its tests has already loaded everything it needs,
# so the engine drops the imports listed below from every file. The
# comment at the top of each stage's file lists everything that the stage
# does.
module Representer
  module Languages
    module Ruby
      extend StagedLanguage

      tracks "ruby"
      version 8
      grammar "ruby"
      extensions ".rb"

      names :identifier, :constant, :instance_variable, :class_variable, :global_variable, simple_symbol: ":"

      imports 'require "$file"', 'require_relative "$file"'

      # A code pattern such as `def $method($name)` needs its `end` to parse,
      # `rescue => $name` needs a `begin`, and `{ |$name| }` needs a call.
      pattern_contexts "...\nend", "begin\n...\nend", "f ..."
    end
  end
end

require_relative "ruby/generate_ast"
require_relative "ruby/normalise"
require_relative "ruby/rename"
require_relative "ruby/reorder"
