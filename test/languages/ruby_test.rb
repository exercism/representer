require "test_helper"

class RubyTest < RepresenterTest
  extend UpstreamTests

  track "ruby"

  DEVIATIONS = {
    "examples-lasagna" => {
      remove: ["actual_minutes_in_oven", "actual_minutes_in_oven:", "number_of_layers:"],
      why: "Keyword parameter names stay, because callers use them (renaming goes by name, so that keeps " \
           "actual_minutes_in_oven everywhere). The old representer renamed one keyword parameter but not the other."
    },
    "mapping-attr_accessors" => {
      remove: %w[other1 other2],
      why: "Strings keep their values, so attr_reader \"other1\" leaves \"other1\" as it is. The old representer " \
           "listed other1 in its mapping, but also left the string as it was."
    },
    "naming_normalisation-complex_method" => {
      remove: ["initialize"],
      why: "Ruby calls initialize itself, so it keeps its name."
    }
  }.freeze

  upstream_tests ".rb", deviations: DEVIATIONS

  # The tests in test/languages/ruby/ cover each stage on its own. These
  # cover the whole representer.

  ### Must not merge ###

  def test_kinds_of_variable_stay_apart
    refute_same_representation "@x = 1", "$x = 1"
    refute_same_representation "@x = 1", "x = 1"
    refute_same_representation "X = 1", "x = 1"
  end

  def test_globals_that_ruby_defines_keep_their_names
    refute_same_representation "x = $stdout", "x = $stderr"
  end

  def test_symbols_named_like_a_local_keep_their_names
    refute_same_representation "count = 0\nxs.map(&:count)", "sum = 0\nxs.map(&:sum)"
  end

  def test_a_trailing_comma_in_block_parameters_is_kept
    refute_same_representation "[[1, 2]].each { |a,| p a }", "[[1, 2]].each { |a| p a }"
  end

  def test_methods_named_after_library_methods_stay_apart
    refute_same_representation "def sum(a) = a.sum", "def max(a) = a.max"
  end

  def test_attributes_named_after_library_methods_stay_apart
    refute_same_representation "attr_reader :first\ndef initialize(x) = @first = x.first",
      "attr_reader :last\ndef initialize(x) = @first = x.last"
  end

  def test_protocol_methods_stay_apart
    refute_same_representation "def initialize(a) = @a = a", "def setup(a) = @a = a"
    refute_same_representation "def to_s = 'x'", "def show = 'x'"
  end

  def test_library_calls_stay_apart
    refute_same_representation "s.upcase", "s.downcase"
  end

  def test_local_named_like_a_method_after_a_dot
    assert_equal "PLACEHOLDER_1", represent("count = xs.count").mapping.keys.first
    assert_includes represent("count = xs.count").representation, "(call xs count)"
  end

  ### Names ###

  def test_student_names_are_renamed
    assert_same_representation "def two_fer(name = 'you') = name", "def two_fer(who = 'you') = who"
  end

  def test_names_in_the_tests_are_kept
    tests = { "two_fer_test.rb" => "class TwoFerTest\n  def test_x\n    assert_equal 'x', TwoFer.two_fer\n  end\nend" }
    result = represent("class TwoFer\n  def self.two_fer(name) = name\nend", filename: "two_fer.rb", exercise_files: tests)
    assert_equal ["name"], result.mapping.values
    assert_includes result.representation, "two_fer"
  end

  def test_stub_names_are_kept_but_not_its_parameters
    stub = { "two_fer.rb" => "class TwoFer\n  def self.two_fer(name)\n  end\nend" }
    result = represent("class TwoFer\n  def self.two_fer(name) = name\nend", filename: "two_fer.rb", exercise_files: stub)
    assert_equal ["name"], result.mapping.values
  end

  ### Unrepresentable solutions ###

  def test_syntax_errors_are_unrepresentable_with_the_ruby_version
    result = represent("def x(")
    assert_nil result.representation
    assert_equal "parse_error", result.reason
    assert_equal Representer::Languages::Ruby.version, result.version
  end

  def test_missing_nodes_are_unrepresentable
    # tree-sitter repairs this by inserting a MISSING "end" node.
    assert_unrepresentable "def x\n  1\n"
  end

  def test_large_solutions_are_unrepresentable
    assert_unrepresentable "x = 1\n" * 40_000, "too_large"
  end

  def test_deep_nesting_is_unrepresentable
    assert_unrepresentable("[" * 2_000 + "]" * 2_000, "too_deep")
  end
  ### Spellings ###

  def test_spellings_that_ruby_reads_the_same_are_the_same
    assert_same_representation "def two_fer(name = 'you') = \"One for \#{name}\"",
      "def two_fer(name = %q(you))\n  \"One for \#{name}\"\nend"
    assert_same_representation "require 'set'\nx = <<~EOS\n  a\nEOS\n", "x = \"a\\n\""
  end
end
