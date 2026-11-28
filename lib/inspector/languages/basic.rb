require_relative "basic/tracks"
require_relative "basic/tokenise"
require_relative "basic/drop_imports"
require_relative "basic/write_lines"

# Basic represents every track with no language of its own. It has no
# grammar, so it removes comments and formatting and changes nothing else.
# Two solutions get the same representation if they differ in nothing but
# comments, formatting, imports and the names and order of their files.
# Basic also represents the solutions that their language's grammar can't
# parse (see RepresentSolution).
#
# Basic renames nothing, and keeps every string exactly as written. In
# indentation-sensitive tracks it keeps each line's indentation depth. A
# track with no Rouge lexer keeps its comments, and its code is split at
# whitespace.
class Inspector::Languages::Basic
  include Mandate

  # Bump the version whenever the output for any solution changes. Versions
  # start at 2, because the website's old basic representer reported 0.
  # Solutions that their language can't parse get Basic's output with the
  # language's version, so a change to Basic's output must also bump the
  # representation version of every language.
  VERSION = 5

  initialize_with :track_slug, :solution_files

  def self.version = VERSION

  def call
    raise Inspector::CannotRepresent.new("no_source_files", "No solution file is a #{track_slug} source file") if sources.empty?

    Inspector::Engine::Result.new(representation:, mapping: {}, version: VERSION, representer: self.class)
  end

  private
  def sources = solution_files.select { |filename, _| self.class.source_file?(track_slug, filename) }.values

  # Write the files one after another, in the order of their
  # representations, so their names and order never matter.
  def representation = sources.map { |source| represent(source) }.reject(&:empty?).sort.join("\n")

  def represent(source)
    lines = Tokenise.(track_slug, Inspector::Engine.clean(source))
    lines = DropImports.(track_slug, lines)
    WriteLines.(track_slug, lines)
  end
end
