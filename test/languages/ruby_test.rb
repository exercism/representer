require "test_helper"

class RubyTest < RepresenterTest
  extend UpstreamTests

  track "ruby"

  DEVIATIONS = {
    "examples-lasagna" => {
      remove: ["actual_minutes_in_oven", "actual_minutes_in_oven:", "number_of_layers:"],
      add: %w[EXPECTED_MINUTES_IN_OVEN PREPARATION_MINUTES_PER_LAYER],
      why: "Keyword parameter names stay, because callers use them (renaming goes by name, so that keeps " \
           "actual_minutes_in_oven everywhere). Constants the solution defines are renamed. The old representer " \
           "left constants, and renamed one keyword parameter but not the other."
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

  ### Formatting and spelling ###

  def test_modifier_if_is_block_if
    assert_same_representation "return 1 if x", "if x\n  return 1\nend"
    assert_same_representation "return 1 if x", "if x then return 1 end"
  end

  def test_modifier_unless_is_block_unless
    assert_same_representation "y unless x", "unless x\n  y\nend"
  end

  def test_modifier_loops_are_block_loops
    assert_same_representation "y while x", "while x\n  y\nend"
    assert_same_representation "y until x", "until x do y end"
  end

  def test_begin_end_while_runs_first_so_stays_apart
    refute_same_representation "begin\n  y\nend while x", "while x\n  y\nend"
  end

  def test_endless_methods_are_normal_methods
    assert_same_representation "def two_fer(name = 'you') = \"One for \#{name}\"",
      "def two_fer(name = 'you')\n  \"One for \#{name}\"\nend"
    assert_same_representation "def self.x = 1", "def self.x\n  1\nend"
  end

  def test_empty_parameter_brackets
    assert_same_representation "def x()\nend", "def x\nend"
  end

  def test_block_styles
    assert_same_representation "xs.map { |x| x * 2 }", "xs.map do |x|\n  x * 2\nend"
  end

  def test_word_operators
    assert_same_representation "a and b", "a && b"
    assert_same_representation "not a", "!a"
  end

  def test_hash_key_styles
    assert_same_representation "{ a: 1 }", "{ :a => 1 }"
  end

  def test_quotes
    assert_same_representation "x = 'a b'", 'x = "a b"'
    assert_same_representation "x = 'it\\'s'", 'x = "it\'s"'
  end

  ### Must not merge ###

  def test_strings_keep_their_spaces
    refute_same_representation '"One for you"', '"Oneforyou"'
  end

  def test_escapes_differ_between_quote_styles
    refute_same_representation "'a\\nb'", '"a\\nb"'
  end

  def test_kinds_of_variable_stay_apart
    refute_same_representation "@x = 1", "$x = 1"
    refute_same_representation "@x = 1", "x = 1"
    refute_same_representation "X = 1", "x = 1"
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

  ### Fallback ###

  def test_syntax_errors_fall_back_with_the_ruby_version
    result = represent("def x(")
    assert_equal Representer::Languages::Basic, result.representer
    assert_equal Representer::Languages::Ruby.version, result.version
  end

  def test_deep_nesting_falls_back
    assert_falls_back("[" * 2_000 + "]" * 2_000)
  end
end
