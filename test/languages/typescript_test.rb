require "test_helper"

class TypeScriptTest < InspectorTest
  extend UpstreamTests

  track "typescript"

  LIBRARY_NAMES = "Inspector renames only the names that the solution defines, so names from JavaScript's " \
                  "library (Math, abs, console, log...) keep their names.".freeze

  DEVIATIONS = {
    "clock-pass" => {
      add: %w[constructor toString],
      remove: %w[length Math abs floor],
      why: "#{LIBRARY_NAMES} The solution defines the methods constructor and toString, so they are renamed."
    },
    "two-fer-fail" => { remove: %w[console debug log], why: LIBRARY_NAMES },
    "two-fer-error-syntax" => {
      parse_error: true,
      why: "The solution has a syntax error, so it gets Basic's representation. The fixture " \
           "expects an error, and has no output to compare."
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
    assert_same_representation "export function twoFer() {}", "export function twoMore() {}"
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

  def test_syntax_errors_get_a_basic_representation_with_the_typescript_version
    assert_basic_representation "const = ;"
  end
end
