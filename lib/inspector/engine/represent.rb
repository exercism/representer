module Inspector::Engine
  # Represents the source files of a solution in one language (see
  # Engine::Language). It only represents the solution files that have one
  # of the language's extensions and aren't test or config files, as the
  # website also sends files such as Rust's Cargo.toml.
  #
  # 1. PrepareFile parses each file (unless trees holds its tree already)
  #    and runs the common stages and the representation's Normalise
  #    stage on it.
  # 2. RenameUserDefinedNodes marks every name the solution defines, in
  #    all the files together.
  # 3. JoinFiles joins the files into one tree, so the files' names are
  #    never part of the representation.
  # 4. The representation's Reorder stage runs on the joined tree, if the
  #    language defines one.
  # 5. NumberPlaceholders numbers the marked names, and Serialize writes
  #    the tree out.
  #
  # Raises CannotRepresent if the solution has no source file, or if a file
  # doesn't parse (RepresentSolution then falls back to Basic).
  class Represent
    include Mandate

    # trees holds files already parsed by the grammar, by filename (see
    # RepresentSolution).
    initialize_with :language, :solution_files, trees: {}

    def call
      if sources.empty?
        raise Inspector::CannotRepresent.new("no_source_files",
          "No solution file has one of the extensions #{language.extensions.join(', ')}")
      end

      prepared = sources.map { |filename, source| PrepareFile.(language, source, tree: trees[filename]) }
      representation = language.representation
      RenameUserDefinedNodes.(prepared, representation)
      tree = JoinFiles.(prepared, prepared.first.type)
      tree = representation.run_stage(:Reorder, tree)
      mapping = NumberPlaceholders.(tree, representation)
      Result.new(representation: Serialize.(tree), mapping:, version: representation.version, representer: language)
    end

    private
    memoize
    def sources
      solution_files.select do |filename, _|
        language.source_file?(filename) && !Inspector::Engine.test_or_config_file?(filename)
      end
    end
  end

  # representer is the class that made the representation. reason and
  # message say why a solution has no representation (representation is
  # then nil).
  Result = Struct.new(:representation, :mapping, :version, :representer, :reason, :message, keyword_init: true)

  # Source code arrives as JSON strings, which are UTF-8 but may hold
  # invalid bytes from a student's editor. The editor also chooses Windows
  # line endings and a byte-order mark, so line endings become plain line
  # breaks and the mark goes. Otherwise they would end up in strings and in
  # other tokens (such as a C++ `#define`).
  # An old Mac line ending (a carriage return on its own) is a line break
  # too. A NUL byte is replaced like an invalid byte, as the website can't
  # store it.
  def self.clean(source)
    source = source.dup.force_encoding(Encoding::UTF_8)
    source = source.scrub("�") unless source.valid_encoding?
    source.delete_prefix("\uFEFF").gsub(/\r\n?/, "\n").tr("\0", "�")
  end

  # Ignore files that students submit but that aren't part of the solution, so
  # they can't change the representation.
  # two_fer_test.rb, test_two_fer.py, leap.spec.js, LeapTests.cs, embed.go, babel.config.js
  TEST_OR_CONFIG_FILE = %r{
    (\A|[_.])(test|spec)s?\.[^./]+\z |
    \Atest_[^/]*\.py\z |
    [a-z0-9]Tests?\.[^./]+\z |
    \Aembed\.go\z |
    \.config\.[cm]?[jt]s\z |
    \A\.eslintrc
  }x

  def self.test_or_config_file?(filename) = File.basename(filename).match?(TEST_OR_CONFIG_FILE)

  # Whether a pattern could match a node of this type, judging only by
  # the type at the pattern's root.
  def self.could_match?(pattern, type)
    case pattern
    when CodePattern then pattern.type.nil? || pattern.type == type
    when Pattern::NodePattern then ["_", type].include?(pattern.type)
    when Pattern::Alternation then pattern.options.any? { |option| could_match?(option, type) }
    else true
    end
  end
end
