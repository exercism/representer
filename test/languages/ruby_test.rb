require "test_helper"

class RubyTest < RepresenterTest
  extend UpstreamTests

  track "ruby"

  DEVIATIONS = {
    "examples-lasagna" => {
      add: %w[EXPECTED_MINUTES_IN_OVEN PREPARATION_MINUTES_PER_LAYER number_of_layers],
      remove: ["actual_minutes_in_oven:", "number_of_layers:"],
      why: "Constants and keyword parameters are names the solution defines, so they are renamed. The old " \
           "representer kept constants, and listed keyword parameters with their colon."
    },
    "mapping-attr_accessors" => {
      remove: %w[foobar barfood misc other1 other2],
      why: "A call to attr_reader, attr_writer or attr_accessor defines no name for this representer, so its " \
           "symbols keep their names. Strings keep their values, so attr_reader \"other1\" leaves \"other1\" as it is."
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

  def test_library_names_are_renamed_if_the_solution_defines_them
    assert_same_representation "count = 0\nxs.map(&:count)", "sum = 0\nxs.map(&:sum)"
    assert_same_representation "def f(name) = name", "def f(who) = who"
  end

  def test_a_trailing_comma_in_block_parameters_is_kept
    refute_same_representation "[[1, 2]].each { |a,| p a }", "[[1, 2]].each { |a| p a }"
  end

  def test_methods_named_after_library_methods_are_renamed
    assert_same_representation "def sum(a) = a.sum", "def max(a) = a.max"
  end

  def test_attributes_named_after_library_methods_stay_apart
    refute_same_representation "attr_reader :first\ndef initialize(x) = @first = x.first",
      "attr_reader :last\ndef initialize(x) = @first = x.last"
  end

  def test_protocol_methods_are_renamed_if_the_solution_defines_them
    assert_same_representation "def initialize(a) = @a = a", "def setup(a) = @a = a"
    assert_same_representation "def to_s = 'x'", "def show = 'x'"
  end

  def test_library_calls_stay_apart
    refute_same_representation "s.upcase", "s.downcase"
  end

  def test_a_defined_name_is_renamed_after_a_dot_too
    result = represent("total = xs.total")
    assert_equal({ "PLACEHOLDER_1" => "total" }, result.mapping)
    assert_includes result.representation, "(call xs PLACEHOLDER_1)"
  end

  ### Names ###

  def test_student_names_are_renamed
    assert_same_representation "def two_fer(person = 'you') = person", "def hello(who = 'you') = who"
    assert_same_representation "def f(a:) = a\nf(a: 1)", "def g(b:) = b\ng(b: 1)"
    assert_same_representation "total = 0\nxs.map(&:total)", "acc = 0\nxs.map(&:acc)"
  end

  def test_the_exercise_files_make_no_difference
    tests = { "two_fer_test.rb" => "class TwoFerTest\n  def test_x\n    assert_equal 'x', TwoFer.two_fer\n  end\nend" }
    source = "class TwoFer\n  def self.two_fer(who) = who\nend"
    result = represent(source, filename: "two_fer.rb", exercise_files: tests)
    assert_equal %w[TwoFer two_fer who], result.mapping.values
    assert_equal represent(source, filename: "two_fer.rb").representation, result.representation
  end

  ### Unrepresentable solutions ###

  def test_syntax_errors_are_unrepresentable_with_the_ruby_version
    result = represent("def x(")
    assert_nil result.representation
    assert_equal "parse_error", result.reason
    assert_equal Representer::Languages::Ruby::Spec.version, result.version
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
