require "test_helper"

class JavaScriptTest < InspectorTest
  extend UpstreamTests

  track "javascript"

  LIBRARY_NAMES = "Inspector never renames names from JavaScript's library (console, log, indexOf...), " \
                  "so mentors' comments on different library calls stay apart. The old representer renamed them.".freeze

  EXPORTS = "The old representer kept the names that a solution exports. Inspector renames every name " \
            "the solution defines, including the exported ones.".freeze

  OWN_METHODS = "Inspector renames every method the solution defines, including the ones that JavaScript " \
                "itself calls (constructor, toString, valueOf). The old representer kept them.".freeze

  DEVIATIONS = {
    "general-normalize-quotes" => {
      restore: { "IDENTIFIER_11" => "indexOf" },
      remove: ["indexOf"],
      add: ["decodedValue"],
      why: "#{LIBRARY_NAMES} #{EXPORTS}"
    },
    "general-remove-comments" => { add: ["twoFer"], why: EXPORTS },
    "general-normalize-whitespace" => { add: ["twoFer"], why: EXPORTS },
    "two-fer-pass" => { add: ["twoFer"], why: EXPORTS },
    "two-fer-fail" => {
      restore: { "IDENTIFIER_2" => "console", "IDENTIFIER_3" => "debug", "IDENTIFIER_4" => "log" },
      remove: %w[console debug log],
      add: ["twoFer"],
      why: "#{LIBRARY_NAMES} #{EXPORTS}"
    },
    "clock-pass" => {
      restore: { "IDENTIFIER_5" => "console", "IDENTIFIER_6" => "log", "IDENTIFIER_9" => "padStart" },
      remove: %w[console log padStart],
      add: %w[Clock clockPad constructor toString valueOf],
      why: "#{LIBRARY_NAMES} #{EXPORTS} #{OWN_METHODS}"
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

  def test_methods_named_after_library_methods_are_renamed
    assert_same_representation "function max(a) { return 1 }", "function min(a) { return 1 }"
    assert_same_representation "class A { size() { return this.a.size } }", "class A { count() { return this.a.count } }"
  end

  # A shorthand property is also a variable, and the old representer renamed
  # it with the variable.
  def test_shorthand_properties_are_renamed_with_their_variable
    assert_same_representation "const a = 1; export const f = () => ({ a })", "const b = 1; export const f = () => ({ b })"
  end

  def test_syntax_errors_get_a_basic_representation_with_the_javascript_version
    assert_basic_representation "const = ;"
  end

  # The empty first or second part of a `for` shows which part is missing.
  def test_the_parts_of_a_for_loop_stay_apart
    refute_same_representation "for (;; i++) {}", "for (i++;;) {}"
    refute_same_representation "for (; i++;) {}", "for (i++;;) {}"
    refute_same_representation "for (i; i;) {}", "for (; i; i) {}"
  end

  def test_a_hash_bang_line_is_dropped
    assert_same_representation "#!/usr/bin/env node\nexport const a = 1;\n", "export const a = 1;\n"
  end

  def test_imports_requires_and_export_lists_are_dropped
    assert_same_representation "import { a } from './b'\nimport c from 'c'\nconst x = 1", "const x = 1"
    assert_same_representation "const fs = require('fs')\nconst x = 1", "const x = 1"
    assert_same_representation "function f() {}\nexport { f }", "function f() {}"
    assert_same_representation "function f() {}\nmodule.exports = { f }", "function f() {}"
    refute_same_representation "import './setup'\nconst x = 1", "const x = 1"
    refute_same_representation "import { a } from './b'\nconst x = a()", "import { b } from './b'\nconst x = b()"
  end

  def test_numbers_are_their_values
    assert_same_representation "const x = 1_000 + 0x1F + 1e3", "const x = 1000 + 31 + 1000"
    assert_same_representation "const x = 1.0 + .5", "const x = 1 + 0.5"
    refute_same_representation "const x = 1n", "const x = 1"
    refute_same_representation "const x = 1.5", "const x = 1.6"
  end
end
