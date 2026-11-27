require "rouge"

# Basic serves every track with no language of its own, so this file holds
# everything Basic knows about each of those tracks. Adding a track to Basic
# only means adding it to the lists here.
class Representer::Languages::Basic
  # Map each track to its Rouge lexer, if the track's slug isn't the lexer's
  # name. Only map a track to a lexer that knows its comment and string syntax
  # exactly, because a lexer that mistakes code for a comment would drop that
  # code.
  LEXERS = {
    "cfml" => "cfscript",
    "delphi" => "pascal",
    "free-pascal" => "pascal",
    "lfe" => "common_lisp",
    "perl5" => "perl",
    "pharo-smalltalk" => "smalltalk",
    "purescript" => "haskell",
    "sqlite" => "sql",
    "unison" => "haskell",
    "vbnet" => "vb",
    "x86-64-assembly" => "nasm"
  }.freeze

  # Give the source files' extensions for a track if its Rouge lexer doesn't
  # list them, or if it has no lexer. Every other track reads the file names
  # listed by its lexer.
  EXTENSIONS = {
    "8th" => [".8th"],
    "arm64-assembly" => [".s"],
    "arturo" => [".art"],
    "awk" => [".awk", ".sh"],
    "ballerina" => [".bal"],
    "cairo" => [".cairo"],
    "euphoria" => [".ex", ".e"],
    "futhark" => [".fut"],
    "jq" => [".jq"],
    "lfe" => [".lfe"],
    "mips" => [".mips", ".asm", ".s"],
    "odin" => [".odin"],
    "purescript" => [".purs"],
    "pyret" => [".arr"],
    "red" => [".red"],
    "roc" => [".roc"],
    "uiua" => [".ua"],
    "unison" => [".u"],
    "vlang" => [".v"],
    "yamlscript" => [".ys"]
  }.freeze

  # Read every file as code in a track with neither a lexer nor a list of
  # extensions, apart from files with these extensions.
  NOT_SOURCE = [".md", ".txt", ".json", ".yaml", ".yml", ".toml", ".lock", ".out"].freeze

  # Keep each line's indentation depth in these tracks, because indentation
  # is part of their syntax.
  INDENTATION_SENSITIVE = [
    "cobol", "coffeescript", "elm", "fsharp", "gdscript", "haskell", "idris", "lean", "moonscript", "nim",
    "purescript", "python", "roc", "scala", "unison", "yamlscript"
  ].freeze

  # Drop each line that starts with one of the track's import words. Only
  # list a track if its imports are always one line long, so a line that
  # starts with the word is always a whole import.
  # import kotlin.math.abs  ->  (nothing)
  IMPORT_WORDS = {
    "c" => ["#include"],
    "d" => ["import"],
    "dart" => ["import"],
    "fortran" => ["use", "USE"],
    "groovy" => ["import"],
    "haskell" => ["import"],
    "idris" => ["import"],
    "julia" => ["import", "using"],
    "kotlin" => ["import"],
    "lean" => ["import", "open"],
    "ocaml" => ["open"],
    "odin" => ["import"],
    "purescript" => ["import"],
    "r" => ["library"],
    "reasonml" => ["open"],
    "scala" => ["import"],
    "sml" => ["open"],
    "swift" => ["import"],
    "vbnet" => ["Imports"],
    "vlang" => ["import"]
  }.freeze

  # Also drop the more indented lines below an import in these tracks,
  # because their imports can go on over those lines.
  # import Data.List (sort,\n    nub)  ->  (nothing)
  CONTINUED_BY_INDENTATION = ["haskell", "idris", "purescript"].freeze

  # Drop each directive that starts with one of these pairs of tokens, up to
  # the "." that ends it, because these directives import or export names and
  # can go on over several lines.
  # -export([f/1,\n  g/1]).  ->  (nothing)
  DIRECTIVES = {
    "erlang" => [["-", "export"], ["-", "export_type"], ["-", "import"], ["-", "include"], ["-", "include_lib"]],
    "prolog" => [[":-", "use_module"], [":-", "ensure_loaded"], [":-", "module"]]
  }.freeze

  # Drop the export list from a module line in these tracks.
  # module Foo (bar, baz) where  ->  module Foo where
  EXPORT_LISTS = ["haskell", "purescript"].freeze

  # Read these prefixes and the character after them as a character literal,
  # because the track's Rouge lexer reads them as the start of a comment or a
  # string, and would drop the rest of the line, as in Emacs Lisp's
  # `(insert ?;)`.
  CHARACTER_PREFIXES = { "emacs-lisp" => "?", "scheme" => "#\\" }.freeze

  def self.lexer_for(track_slug) = Rouge::Lexer.find(LEXERS.fetch(track_slug, track_slug))

  # Read only a track's source files, so files such as Haskell's
  # package.yaml, and the test and config files, are left out.
  def self.source_file?(track_slug, filename)
    return false if Representer::Engine.test_or_config_file?(filename)

    name = File.basename(filename)
    return EXTENSIONS[track_slug].any? { |extension| name.end_with?(extension) } if EXTENSIONS.key?(track_slug)

    lexer = lexer_for(track_slug)
    return lexer.filenames.any? { |glob| File.fnmatch(glob, name) } if lexer

    NOT_SOURCE.none? { |extension| name.downcase.end_with?(extension) }
  end
end
