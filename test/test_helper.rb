$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "minitest/autorun"
require "minitest/pride" if $stdout.tty?
require "inspector"

class InspectorTest < Minitest::Test
  # Every language's test sets this, and the helpers below use it.
  def self.track(slug = nil) = slug ? @track = slug : @track
  def track = self.class.track

  def represent(code, filename: default_filename) = Inspector::RepresentSolution.(track, { filename => code })

  # A solution file with the language's first extension, as the engine
  # ignores files with other extensions.
  def default_filename
    language = Inspector::Languages.for(track)
    language.respond_to?(:extensions) ? "solution#{language.extensions.first}" : "solution"
  end

  def assert_same_representation(code, other, **options)
    assert_equal represent(code, **options).representation, represent(other, **options).representation
  end

  # Both solutions must get a representation, so a syntax error in one of
  # them can't pass the test.
  def refute_same_representation(code, other, **options)
    representations = [code, other].map { |source| represent(source, **options).representation }
    representations.each { |representation| refute_nil representation }
    refute_equal(*representations)
  end

  # Checks that the solution gets no representation, with this reason.
  def assert_unrepresentable(code, reason)
    result = represent(code)
    assert_nil result.representation
    assert_empty result.mapping
    assert_equal reason, result.reason
    assert_equal Inspector::Languages.for(track).version, result.version
  end

  # Checks that the solution doesn't parse, so it gets Basic's representation
  # with the language's version.
  def assert_basic_representation(code)
    result = represent(code)
    basic = Inspector::Languages::Basic.(track, { default_filename => code })
    assert_equal Inspector::RepresentSolution::BASIC_PREFIX + basic.representation, result.representation
    assert_equal Inspector::Languages.for(track).version, result.version
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
# Where Inspector deliberately differs, a deviation says how and why:
#
# - restore: placeholders in equivalent.<ext> to turn back into names, for
#   names the old representer renamed but Inspector keeps.
# - replace: text in equivalent.<ext> to replace with other text, for names
#   that Inspector renames and the old one kept.
# - add / remove: names to add to or remove from the old mapping.
# - parse_error: the input has a syntax error, so it gets Basic's
#   representation. The test checks that, and nothing else.
# - merges_with: the names of other tests that Inspector gives the
#   same representation, although the old one kept them apart (such as two
#   solutions that differ only in their imports).
# - why: the reason, which every deviation must give.
#
# A test whose mapping has names that the old representer didn't rename (it
# kept the names of library methods, even if the solution defined them) is
# listed by the names in upstream_tests' renamed: argument, with one reason
# for all of them in renamed_why:.
module UpstreamTests
  Case = Struct.new(:name, :solution_files, :equivalent, :key, :mapping_names, :deviation, keyword_init: true)

  # renamed maps a list of names to the tests whose mapping has them,
  # although the old representer's mapping didn't.
  def upstream_tests(extension, deviations: {}, renamed: {}, renamed_why: nil)
    raise ArgumentError, "renamed needs a renamed_why" if renamed.any? && !renamed_why

    renamed_by_test = Hash.new { |hash, name| hash[name] = [] }
    renamed.each { |names, tests| tests.each { |test| renamed_by_test[test].concat(names) } }
    cases = load_cases(extension, deviations, renamed_by_test)
    unknown = (deviations.keys | renamed_by_test.keys) - cases.map(&:name)
    raise ArgumentError, "Deviations for unknown tests: #{unknown.join(', ')}" if unknown.any?

    cases.each do |test_case|
      raise ArgumentError, "The deviation for #{test_case.name} must say why" if test_case.deviation.any? && !test_case.deviation[:why]

      if test_case.deviation[:parse_error]
        define_method("test_upstream_#{test_case.name}_gets_a_basic_representation") do
          result = Inspector::RepresentSolution.(track, test_case.solution_files)
          assert_equal Inspector::Languages::Basic, result.representer
          assert result.representation.start_with?(Inspector::RepresentSolution::BASIC_PREFIX)
        end
        next
      end

      define_method("test_upstream_#{test_case.name}_equivalence") do
        filename = test_case.solution_files.keys.first
        expected = Inspector::RepresentSolution.(track, { filename => test_case.equivalent })
        actual = Inspector::RepresentSolution.(track, test_case.solution_files)
        assert_equal expected.representation, actual.representation
        refute_nil actual.representation, "#{test_case.name} has no representation (#{actual.reason})"
      end

      define_method("test_upstream_#{test_case.name}_mapping") do
        actual = Inspector::RepresentSolution.(track, test_case.solution_files)
        assert_equal test_case.mapping_names.uniq.sort, actual.mapping.values.uniq.sort
      end
    end

    define_method(:test_upstream_distinctness) do
      represented = cases.reject { |test_case| test_case.deviation[:parse_error] }
      representations = represented.to_h do |test_case|
        [test_case.name, Inspector::RepresentSolution.(track, test_case.solution_files).representation]
      end
      represented.combination(2).each do |a, b|
        if a.key == b.key || UpstreamTests.merged?(a, b)
          assert_equal representations[a.name], representations[b.name], "#{a.name} and #{b.name} should match"
        else
          refute_equal representations[a.name], representations[b.name], "#{a.name} and #{b.name} should differ"
        end
      end
    end
  end

  def self.merged?(first, second)
    Array(first.deviation[:merges_with]).include?(second.name) || Array(second.deviation[:merges_with]).include?(first.name)
  end

  PLACEHOLDER_KEY = /\A@?(PLACEHOLDER|IDENTIFIER|IDENT|FUNCVAR|FUNC|fn|v|C|m)_?\d+@?\z/i

  private
  def load_cases(extension, deviations, renamed)
    Dir[File.join(__dir__, "fixtures", track, "*")].sort.map do |dir|
      name = File.basename(dir)
      deviation = deviations.fetch(name, {})
      files = Dir.children(dir).sort
      solution_names = files.reject { |file| file.start_with?("equivalent", "expected_") }
      equivalent = restore(File.read(File.join(dir, "equivalent#{extension}")), deviation[:restore])
      equivalent = (deviation[:replace] || {}).reduce(equivalent) { |code, (from, to)| code.gsub(from, to) }
      expected_path = File.join(dir, "expected_representation.txt")
      expected_text = File.exist?(expected_path) ? File.read(expected_path) : equivalent

      Case.new(
        name:,
        solution_files: solution_names.to_h { |file| [file, File.read(File.join(dir, file))] },
        equivalent:,
        key: expected_text.strip,
        mapping_names: mapping_names(File.join(dir, "expected_mapping.json"), deviation, renamed.fetch(name, [])),
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
  def mapping_names(path, deviation, renamed)
    mapping = JSON.parse(File.read(path))
    names = mapping.keys.all? { |key| key.match?(PLACEHOLDER_KEY) } ? mapping.values : mapping.keys
    names - (deviation.fetch(:remove, []) - renamed) + deviation.fetch(:add, []) + renamed
  end
end
