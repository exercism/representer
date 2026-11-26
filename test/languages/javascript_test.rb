require "test_helper"

class JavaScriptTest < RepresenterTest
  extend UpstreamTests

  track "javascript"

  LIBRARY_NAMES = "This representer never renames names from JavaScript's library (console, log, indexOf...), " \
                  "so mentors' comments on different library calls stay apart. The old representer renamed them.".freeze

  DEVIATIONS = {
    "general-normalize-quotes" => {
      restore: { "IDENTIFIER_11" => "indexOf" },
      remove: ["indexOf"],
      why: LIBRARY_NAMES
    },
    "two-fer-fail" => {
      restore: { "IDENTIFIER_2" => "console", "IDENTIFIER_3" => "debug", "IDENTIFIER_4" => "log" },
      remove: %w[console debug log],
      why: LIBRARY_NAMES
    },
    "clock-pass" => {
      restore: { "IDENTIFIER_5" => "console", "IDENTIFIER_6" => "log", "IDENTIFIER_9" => "padStart", "IDENTIFIER_14" => "equals" },
      remove: %w[console log padStart equals],
      why: "#{LIBRARY_NAMES} The student's equals method also keeps its name, because equals is a library name."
    }
  }.freeze

  upstream_tests ".js", deviations: DEVIATIONS

  def test_quotes_and_plain_template_strings
    assert_same_representation "const x = 'a b'", 'const x = "a b"'
    assert_same_representation "const x = 'a b'", "const x = `a b`"
    assert_same_representation "const x = 'it\\'s'", 'const x = "it\'s"'
  end

  def test_template_strings_with_substitutions
    assert_same_representation "const f = (n) => `a ${n}`", "const f = (m) => `a ${m}`"
    refute_same_representation "const f = (n) => `a ${n}`", "const f = (n) => `a${n}`"
  end

  def test_templates_made_only_of_substitutions
    assert_same_representation "const f = (n) => `${n}`", "const f = (m) => `${m}`"
    refute_same_representation "const f = (n) => `${n}`", "const f = (n) => `${n}${n}`"
  end

  def test_arrow_parameter_brackets_and_semicolons
    assert_same_representation "const f = (x) => x;", "const f = x => x"
  end

  def test_grouping_brackets
    assert_same_representation "const y = (a * b) + c", "const y = a * b + c"
    refute_same_representation "const y = a * (b + c)", "const y = a * b + c"
  end

  def test_library_calls_stay_apart
    refute_same_representation "export const f = (s) => s.toUpperCase()", "export const f = (s) => s.toLowerCase()"
  end

  def test_methods_named_after_library_methods_stay_apart
    refute_same_representation "function max(a) { return a.max }", "function min(a) { return a.min }"
    refute_same_representation "class A { size() { return this.a.size } }", "class A { count() { return this.a.count } }"
  end

  def test_shorthand_properties_keep_their_names
    refute_same_representation "const a = 1; export const f = () => ({ a })", "const b = 1; export const f = () => ({ b })"
  end

  def test_exports_and_names_in_the_tests_are_kept
    tests = { "two-fer.spec.js" => "import { twoFer } from './two-fer';\ntest('x', () => expect(twoFer()).toEqual('x'));" }
    result = represent("export const twoFer = (name = 'you') => name", filename: "two-fer.js", exercise_files: tests)
    assert_equal ["name"], result.mapping.values
  end

  def test_syntax_errors_are_unrepresentable_with_the_javascript_version
    result = represent("const = ;")
    assert_nil result.representation
    assert_equal "parse_error", result.reason
    assert_equal Representer::Languages::JavaScript.version, result.version
  end

  # The empty first or second part of a `for` shows which part is missing.
  def test_the_parts_of_a_for_loop_stay_apart
    refute_same_representation "for (;; i++) {}", "for (i++;;) {}"
    refute_same_representation "for (; i++;) {}", "for (i++;;) {}"
    refute_same_representation "for (i; i;) {}", "for (; i; i) {}"
  end
end
