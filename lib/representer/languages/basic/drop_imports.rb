# A solution that passes its tests has already made every name it needs
# available, so this command drops the imports and export lists listed in
# tracks.rb from the lines given by Tokenise.
class Representer::Languages::Basic
  class DropImports
    include Mandate

    initialize_with :track_slug, :lines

    def call
      kept = []
      index = 0
      while index < lines.size
        indent, tokens = lines[index]
        if import?(tokens)
          index = after_import(index, indent)
        elsif directive?(tokens)
          index = after_directive(index)
        else
          kept << [indent, without_export_list(tokens)]
          index += 1
        end
      end
      kept
    end

    private
    def import?(tokens) = IMPORT_WORDS.fetch(track_slug, []).include?(tokens.first)
    def directive?(tokens) = DIRECTIVES.fetch(track_slug, []).include?(tokens.first(2))

    # Skip the import's line, and the more indented lines below it in a track
    # whose imports go on over them.
    def after_import(index, indent)
      index += 1
      index += 1 while CONTINUED_BY_INDENTATION.include?(track_slug) && index < lines.size && lines[index][0] > indent
      index
    end

    # Skip the directive's lines, up to the one that ends with a ".".
    def after_directive(index)
      index += 1 until index >= lines.size || lines[index][1].last.end_with?(".")
      index + 1
    end

    # Drop the export list from a module line that is all on one line.
    # module Foo (bar, baz) where  ->  module Foo where
    def without_export_list(tokens)
      return tokens unless EXPORT_LISTS.include?(track_slug)
      return tokens unless tokens.first == "module" && tokens.last == "where" && tokens[2] == "("
      return tokens unless tokens[-2] == ")"

      tokens.first(2) + ["where"]
    end
  end
end
