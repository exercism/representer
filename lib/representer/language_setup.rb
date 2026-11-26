module Representer
  # The setup that every language with its own representer gives: its
  # tracks, version, grammar, file extensions, the leaf types that hold
  # names, and its library names. A Language subclass (written with the
  # rule DSL) and a StagedLanguage module (written as four stages) both
  # extend it.
  module LanguageSetup
    IDENTITY_FOLD = ->(name) { name }

    # The track slugs this language represents.
    def tracks(*slugs)
      slugs.each { |slug| Languages.register(slug, self) }
    end

    # The representer version for this language. Bump it whenever the
    # output for any solution changes. Versions start at 2, because the old
    # per-track representers all reported 1.
    def version(number = nil)
      return @version unless number
      raise ArgumentError, "A version must be from 2 to 32767" unless (2..32_767).cover?(number)

      @version = number
    end

    # The grammar's name in grammars.yml.
    def grammar(name = nil) = name ? @grammar = name : @grammar

    # The file extensions of the language's source files. Solution and
    # exercise files with other extensions (such as Cargo.toml or
    # .meta/config.json) are ignored.
    def extensions(*list) = list.empty? ? @extensions : @extensions = list

    def source_file?(filename) = extensions.any? { |extension| filename.downcase.end_with?(extension) }

    # The leaf types that hold names, which the rename rules may rename.
    # A keyword gives a prefix that is not part of the name, such as Ruby's
    # `simple_symbol: ":"` for `:name`.
    def names(*types, **prefixed)
      return @names if types.empty? && prefixed.empty?

      @names = types.to_h { |type| [type.to_s, ""] }.merge(prefixed.transform_keys(&:to_s))
    end

    # For languages that treat some spellings of a name as the same name (Nim
    # ignores case after the first letter, and underscores). The block takes
    # a name and returns its one canonical spelling. Names are then compared,
    # renamed and written in that spelling, and a mapping keeps the
    # student's first spelling.
    def fold_names(&block) = block ? @name_folding = block : @name_folding || IDENTITY_FOLD

    def folds_names? = !@name_folding.nil?

    # A file of library names, one per line (the language's core and
    # standard library). If the student defines a method or property with
    # one of these names, it is kept, so `def sum(a) = a.sum` and
    # `def max(a) = a.max` stay apart.
    def library_names(path)
      @library_names = File.readlines(path, chomp: true).reject { |line| line.empty? || line.start_with?("#") }.to_set
    end

    def library = @library_names || Set.new
  end
end
