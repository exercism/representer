$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "minitest/autorun"
require "minitest/pride" if $stdout.tty?
require "representer"

class RepresenterTest < Minitest::Test
  # Every language's test sets this, and the helpers below use it.
  def self.track(slug = nil) = slug ? @track = slug : @track
  def track = self.class.track

  def represent(code, filename: default_filename, exercise_files: {})
    Representer::RepresentSolution.(track, { filename => code }, exercise_files)
  end

  # A solution file with the language's first extension, as the engine
  # ignores files with other extensions.
  def default_filename
    language = Representer::Languages.for(track)
    language.respond_to?(:extensions) ? "solution#{language.extensions.first}" : "solution"
  end

  def assert_same_representation(code, other, **options)
    assert_equal represent(code, **options).representation, represent(other, **options).representation
  end

  def refute_same_representation(code, other, **options)
    refute_equal represent(code, **options).representation, represent(other, **options).representation
  end

  # Checks that the solution gets no representation, with this reason.
  def assert_unrepresentable(code, reason = "parse_error")
    result = represent(code)
    assert_nil result.representation
    assert_empty result.mapping
    assert_equal reason, result.reason
    assert_equal Representer::Languages.for(track).version, result.version
  end
end

# Ports the golden tests of an old per-track representer. Each test lives in
# test/fixtures/<track>/<name>/ and holds:
#
# - The test's input files, unchanged.
# - equivalent.<ext>: code that the old representer treats as the same as
#   the input. Where the old representer printed normalised code, this is
#   its expected output, unchanged. Otherwise it was written by hand.
# - expected_mapping.json: the old representer's expected mapping.
# - expected_representation.txt (optional): the old representer's expected
#   output, if it isn't code.
#
# Each test checks three things:
#
# 1. Equivalence: the input and equivalent.<ext> get the same representation.
# 2. Mapping: the names renamed are the ones the old representer renamed.
# 3. Distinctness: two tests get the same representation exactly when the old
#    representer gave them the same expected output.
#
# Where this representer deliberately differs, a deviation says how and why:
#
# - restore: placeholders in equivalent.<ext> to turn back into names, for
#   names the old representer renamed but this one keeps (such as library
#   method names).
# - add / remove: names to add to or remove from the old mapping.
# - unrepresentable: the input has a syntax error, so it gets no
#   representation. The test checks that, and nothing else.
# - why: the reason, which every deviation must give.
module UpstreamTests
  Case = Struct.new(:name, :solution_files, :equivalent, :key, :mapping_names, :deviation, keyword_init: true)

  def upstream_tests(extension, deviations: {})
    cases = load_cases(extension, deviations)
    unknown = deviations.keys - cases.map(&:name)
    raise ArgumentError, "Deviations for unknown tests: #{unknown.join(', ')}" if unknown.any?

    cases.each do |test_case|
      raise ArgumentError, "The deviation for #{test_case.name} must say why" if test_case.deviation.any? && !test_case.deviation[:why]

      if test_case.deviation[:unrepresentable]
        define_method("test_upstream_#{test_case.name}_is_unrepresentable") do
          result = Representer::RepresentSolution.(track, test_case.solution_files, {})
          assert_nil result.representation
          assert_equal "parse_error", result.reason
        end
        next
      end

      define_method("test_upstream_#{test_case.name}_equivalence") do
        filename = test_case.solution_files.keys.first
        expected = Representer::RepresentSolution.(track, { filename => test_case.equivalent }, {})
        actual = Representer::RepresentSolution.(track, test_case.solution_files, {})
        assert_equal expected.representation, actual.representation
        refute_nil actual.representation, "#{test_case.name} has no representation (#{actual.reason})"
      end

      define_method("test_upstream_#{test_case.name}_mapping") do
        actual = Representer::RepresentSolution.(track, test_case.solution_files, {})
        assert_equal test_case.mapping_names.sort, actual.mapping.values.sort
      end
    end

    define_method(:test_upstream_distinctness) do
      represented = cases.reject { |test_case| test_case.deviation[:unrepresentable] }
      representations = represented.to_h do |test_case|
        files = test_case.solution_files
        # A language that merges files takes them as they are. The others
        # have one file, which is renamed so that file names don't matter.
        files = { "solution#{extension}" => files.values.join("\n") } unless Representer::Languages.for(track).merges_files?
        [test_case.name, Representer::RepresentSolution.(track, files, {}).representation]
      end
      represented.combination(2).each do |a, b|
        if a.key == b.key
          assert_equal representations[a.name], representations[b.name], "#{a.name} and #{b.name} should match"
        else
          refute_equal representations[a.name], representations[b.name], "#{a.name} and #{b.name} should differ"
        end
      end
    end
  end

  PLACEHOLDER_KEY = /\A@?(PLACEHOLDER|IDENTIFIER|IDENT|FUNCVAR|FUNC|fn|v|C|m)_?\d+@?\z/i

  private
  def load_cases(extension, deviations)
    Dir[File.join(__dir__, "fixtures", track, "*")].sort.map do |dir|
      name = File.basename(dir)
      deviation = deviations.fetch(name, {})
      files = Dir.children(dir).sort
      solution_names = files.reject { |file| file.start_with?("equivalent", "expected_") }
      equivalent = restore(File.read(File.join(dir, "equivalent#{extension}")), deviation[:restore])
      expected_path = File.join(dir, "expected_representation.txt")
      expected_text = File.exist?(expected_path) ? File.read(expected_path) : equivalent

      Case.new(
        name:,
        solution_files: solution_names.to_h { |file| [file, File.read(File.join(dir, file))] },
        equivalent:,
        key: expected_text.strip,
        mapping_names: mapping_names(File.join(dir, "expected_mapping.json"), deviation),
        deviation:
      )
    end
  end

  def restore(code, placeholders)
    (placeholders || {}).sort_by { |placeholder, _| -placeholder.length }.reduce(code) do |result, (placeholder, name)|
      result.gsub(/\b#{placeholder}\b/, name)
    end
  end

  # Old representers wrote mappings either way round (name to placeholder,
  # or placeholder to name). PHP's placeholders are fn0, v0, C0 and m0, and
  # Wren's are @IDENT1@.
  def mapping_names(path, deviation)
    mapping = JSON.parse(File.read(path))
    names = mapping.keys.all? { |key| key.match?(PLACEHOLDER_KEY) } ? mapping.values : mapping.keys
    names - deviation.fetch(:remove, []) + deviation.fetch(:add, [])
  end
end
