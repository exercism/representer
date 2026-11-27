require "test_helper"

class TypeScriptTest < RepresenterTest
  extend UpstreamTests

  track "typescript"

  LIBRARY_NAMES = "This representer renames only the names that the solution defines, so names from JavaScript's " \
                  "library (Math, abs, console, log...) keep their names. The old representer renamed every name.".freeze

  DEVIATIONS = {
    "clock-pass" => {
      add: %w[constructor toString],
      remove: %w[length Math abs floor],
      why: "#{LIBRARY_NAMES} The solution defines the methods constructor and toString, so they are renamed."
    },
    "two-fer-fail" => { remove: %w[console debug log], why: LIBRARY_NAMES },
    "two-fer-error-syntax" => {
      unrepresentable: true,
      why: "The solution has a syntax error, so it gets no representation. The old representer's test " \
           "expected an error, and has no output to compare. The old test 'two-fer/error/missing' has no " \
           "solution file, so there is nothing to port."
    }
  }.freeze

  upstream_tests ".ts", deviations: DEVIATIONS

  def test_types_that_the_student_names_are_renamed
    assert_same_representation "class A { x = 1 }\nconst a: A = new A()", "class B { x = 1 }\nconst b: B = new B()"
    assert_same_representation "interface Shape { area(): number }", "interface Form { volume(): number }"
    assert_same_representation "type Pair<A> = { a: A }", "type Duo<T> = { a: T }"
    assert_same_representation "enum Color { Red, Green }", "enum Hue { Blue, Pink }"
  end

  def test_different_types_stay_apart
    refute_same_representation "function f(a: number): number { return a }", "function f(a: number): string { return a }"
    refute_same_representation "interface A { a: number }", "type A = { a: number }"
  end

  def test_parameter_properties_are_members
    assert_same_representation "class A { constructor(private total: number) {} get() { return this.total } }",
      "class A { constructor(private sum: number) {} get() { return this.sum } }"
  end

  def test_exported_names_are_renamed
    assert_same_representation "export interface Shape { a: number }", "export interface Form { a: number }"
    tests = { "two-fer.test.ts" => "import { twoFer } from './two-fer'\ntwoFer()" }
    assert_same_representation "export function twoFer() {}", "export function twoMore() {}", exercise_files: tests
  end

  def test_enum_names_are_renamed
    assert_same_representation "export enum ResistorValues { black = 0, brown = 1 }\nconst x = ResistorValues.black",
      "export enum ResistorBranding { black = 0, brown = 1 }\nconst x = ResistorBranding.black"
    refute_same_representation "export enum A { black = 0 }\nconst x = A.black", "export enum A { black = 1 }\nconst x = A.black"
  end

  def test_imported_names_stay_apart
    refute_same_representation "import { a } from './b'\nconst x = a()", "import { b } from './b'\nconst x = b()"
  end

  def test_library_calls_stay_apart
    refute_same_representation "export const f = (s: string) => s.toUpperCase()", "export const f = (s: string) => s.toLowerCase()"
  end

  def test_names_in_the_tests_are_renamed
    tests = { "two-fer.test.ts" => "import { twoFer } from './two-fer';\ntest('x', () => expect(twoFer()).toEqual('x'));" }
    result = represent("export const twoFer = (name: string = 'you'): string => name", filename: "two-fer.ts", exercise_files: tests)
    assert_equal %w[twoFer name], result.mapping.values
  end

  def test_syntax_errors_are_unrepresentable_with_the_typescript_version
    result = represent("const = ;")
    assert_nil result.representation
    assert_equal "parse_error", result.reason
    assert_equal Representer::Languages::TypeScript::Spec.version, result.version
  end
end
