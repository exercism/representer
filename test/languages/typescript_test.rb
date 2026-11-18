require "test_helper"

class TypeScriptTest < RepresenterTest
  extend UpstreamTests

  track "typescript"

  LIBRARY_NAMES = "This representer never renames names from JavaScript's library (Math, abs, console, log...), " \
                  "so mentors' comments on different library calls stay apart. The old representer renamed them.".freeze
  EXPORTS = "This representer keeps the names a solution exports, because the exercise's tests use them. " \
            "The old representer renamed them.".freeze

  DEVIATIONS = {
    "clock-pass" => {
      remove: %w[length equals Math abs floor],
      why: "#{LIBRARY_NAMES} The student's equals method also keeps its name, because equals is a library name, " \
           "and length is kept because JavaScript itself uses it. #{EXPORTS}"
    },
    "two-fer-pass" => { remove: ["twoFer"], why: EXPORTS },
    "two-fer-fail" => { remove: %w[twoFer console debug log], why: "#{LIBRARY_NAMES} #{EXPORTS}" },
    "two-fer-error-syntax" => {
      unrepresentable: true,
      why: "The solution has a syntax error, so it gets no representation. The old representer's test " \
           "expected an error, and has no output to compare. The old test 'two-fer/error/missing' has no " \
           "solution file, so there is nothing to port."
    }
  }.freeze

  upstream_tests ".ts", deviations: DEVIATIONS

  def test_arrow_parameter_brackets
    assert_same_representation "const f = (x) => x", "const f = x => x"
    refute_same_representation "const f = (x: number) => x", "const f = x => x"
  end

  def test_types_that_the_student_names_are_renamed
    assert_same_representation "class A { x = 1 }\nconst a: A = new A()", "class B { x = 1 }\nconst b: B = new B()"
    assert_same_representation "interface Shape { area(): number }", "interface Form { volume(): number }"
    assert_same_representation "type Pair<A> = { a: A }", "type Duo<T> = { a: T }"
    assert_same_representation "enum Color { Red, Green }", "enum Hue { Blue, Pink }"
  end

  def test_type_keywords_are_not_strings
    refute_same_representation "const x: string = ''", "const x: number = ''"
  end

  def test_different_types_stay_apart
    refute_same_representation "const x: string = ''", "const x: string[] = ''"
    refute_same_representation "function f(a: number): number { return a }", "function f(a: number): string { return a }"
    refute_same_representation "interface A { a: number }", "type A = { a: number }"
  end

  def test_access_modifiers_stay_apart
    refute_same_representation "class A { private x = 1 }", "class A { public x = 1 }"
    refute_same_representation "class A { x = 1 }", "class A { readonly x = 1 }"
  end

  def test_parameter_properties_are_members
    assert_same_representation "class A { constructor(private total: number) {} get() { return this.total } }",
      "class A { constructor(private sum: number) {} get() { return this.sum } }"
  end

  def test_exported_types_and_exports_are_kept
    refute_same_representation "export interface Shape { a: number }", "export interface Form { a: number }"
    refute_same_representation "export function twoFer() {}", "export function twoMore() {}"
  end

  def test_names_in_the_tests_are_kept
    tests = { "two-fer.test.ts" => "import { twoFer } from './two-fer';\ntest('x', () => expect(twoFer()).toEqual('x'));" }
    result = represent("export const twoFer = (name: string = 'you'): string => name", filename: "two-fer.ts", exercise_files: tests)
    assert_equal ["name"], result.mapping.values
  end

  def test_syntax_errors_are_unrepresentable_with_the_typescript_version
    result = represent("const = ;")
    assert_nil result.representation
    assert_equal "parse_error", result.reason
    assert_equal Representer::Languages::TypeScript.version, result.version
  end

  def test_javascript_rules_still_apply
    assert_same_representation "const x = 'a b'", 'const x = "a b"'
    assert_same_representation "const y = (a * b) + c", "const y = a * b + c"
    refute_same_representation "export const f = (s: string) => s.toUpperCase()", "export const f = (s: string) => s.toLowerCase()"
  end
end
