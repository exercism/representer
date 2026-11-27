require "test_helper"

class RustTest < RepresenterTest
  extend UpstreamTests

  track "rust"

  UNDEFINED = "The old representer renamed every name it met, including ones the solution never defines (a name " \
              "from the surrounding code). This representer only renames names the solution defines, so %s keeps its name.".freeze

  IMPL_TYPE = {
    why: "The old representer left the names in an impl header (`impl Test`) as they were, even where it renamed " \
         "the type, so its output isn't valid code. This representer renames them, so the equivalent has the placeholder."
  }.freeze

  CAPITALS = "This representer reads a capitalised name in a pattern as an enum variant or a constant, which binds " \
             "nothing, so the equivalent writes its placeholders in lower case.".freeze

  # The deviation for a test with a placeholder in a pattern, such as
  # `Some(PLACEHOLDER_1)`: its equivalent writes the placeholders in lower case.
  def self.lower_case(**deviation)
    { **deviation, replace: { "PLACEHOLDER_" => "placeholder_" }, why: [deviation[:why], CAPITALS].compact.join(" ") }
  end

  DEVIATIONS = {
    "generics" => IMPL_TYPE,
    "ignore_comments" => IMPL_TYPE,
    "impl_blocks" => IMPL_TYPE,
    "sort_by_ascii_file_items" => IMPL_TYPE,
    "user_defined_traits" => IMPL_TYPE,
    "fn_calls" => { restore: { "PLACEHOLDER_2" => "square" }, remove: ["square"], why: format(UNDEFINED, "square") },
    "for_loops" => lower_case(restore: { "PLACEHOLDER_3" => "lines" }, remove: ["lines"], why: format(UNDEFINED, "lines")),
    "if_expressions" => { restore: { "PLACEHOLDER_1" => "x" }, remove: ["x"], why: format(UNDEFINED, "x") },
    "if_let_expressions" => lower_case(restore: { "PLACEHOLDER_2" => "my_func" }, remove: ["my_func"],
      why: format(UNDEFINED, "my_func")),
    "match_arms" => lower_case,
    "match_expressions" => lower_case,
    "loops" => { restore: { "PLACEHOLDER_1" => "x" }, remove: ["x"], why: format(UNDEFINED, "x") },
    "method_calls" => { restore: { "PLACEHOLDER_2" => "pi" }, remove: ["pi"], why: format(UNDEFINED, "pi") },
    "while_loops" => { restore: { "PLACEHOLDER_2" => "x" }, remove: ["x"], why: format(UNDEFINED, "x") },
    "type_aliases" => {
      add: ["T"],
      replace: { "std::result::Result" => "std::result::PLACEHOLDER_1" },
      why: "The old representer left the type parameter T of a type alias. This representer renames it, as it does in a " \
           "struct, so the equivalent has a placeholder for T. The solution defines the name Result, so this " \
           "representer also renames it in `std::result::Result`."
    },
    "union_names" => {
      add: %w[A B x y],
      why: "The old representer left the type parameters and fields of a union. This representer renames them, as it " \
           "does in a struct, so the equivalent has placeholders for them."
    }
  }.freeze

  MAIN = %w[blocks closure_expressions fn_calls for_loops if_expressions if_let_expressions ignore_comments
            ignore_doc_comments let_bindings loops macro_inputs match_arms match_expressions method_calls
            replace_same_identifier typed_let_binding while_loops].freeze

  upstream_tests ".rs", deviations: DEVIATIONS, renamed: { ["main"] => MAIN },
    renamed_why: "The old representer kept the name main. This representer renames every name the solution defines."

  def test_locals_and_parameters_are_renamed
    assert_same_representation "fn f(a: u32) -> u32 { let b = a; b }", "fn g(x: u32) -> u32 { let y = x; y }"
  end

  def test_fields_and_methods_are_renamed_after_a_dot
    code = "struct S { %s: u32 }\nimpl S { fn %s(&self) -> u32 { self.%s } }\nfn f(s: S) -> u32 { s.%s() }"
    assert_same_representation format(code, "a", "b", "a", "b"), format(code, "c", "d", "c", "d")
  end

  def test_enum_variants_are_renamed_through_their_path
    code = "enum E { %s }\nfn f() -> E { E::%s }"
    assert_same_representation format(code, "A", "A"), format(code, "B", "B")
  end

  def test_a_method_named_like_a_library_method_is_renamed
    code = "struct S(u32);\nimpl S { fn %s(&self) -> u32 { self.0 } }"
    assert_same_representation format(code, "len"), format(code, "size")
    assert_same_representation format(code, "total"), format(code, "amount")
  end

  # A method that implements a library trait is defined by the solution too.
  def test_trait_methods_are_renamed
    code = "use std::fmt::{Display, Formatter, Result};\nstruct S;\n" \
           "impl Display for S { fn %s(&self, f: &mut Formatter) -> Result { Ok(()) } }"
    assert_same_representation format(code, "fmt"), format(code, "show")
  end

  # A pattern names the variants it matches, so swapping them changes the
  # program.
  def test_swapping_the_variants_of_a_match_changes_the_result
    code = "fn f(r: Result<u8, u8>) -> u8 { match r { %s(v) => v, %s(_) => 0 } }"
    refute_same_representation format(code, "Ok", "Err"), format(code, "Err", "Ok")
  end

  def test_syntax_errors_get_a_basic_representation
    assert_basic_representation "fn f( {\n"
  end

  def test_files_in_other_formats_are_ignored
    code = "pub fn f() {}"
    assert_equal represent(code, filename: "src/lib.rs").representation,
      Representer::RepresentSolution.(track, { "src/lib.rs" => code, "Cargo.toml" => "[package]\nname = \"p\"\n" }).representation
  end

  def test_a_solution_with_no_source_files
    result = Representer::RepresentSolution.(track, { "Cargo.toml" => "[package]" })
    assert_nil result.representation
    assert_equal "no_source_files", result.reason
  end

  def test_windows_line_endings_are_plain_line_breaks
    assert_same_representation "fn f() -> &str {\n    \"a\n b\"\n}\n", "fn f() -> &str {\r\n    \"a\r\n b\"\r\n}\r\n"
    refute_same_representation 'fn f() -> &str { "a\\r\\nb" }', 'fn f() -> &str { "a\\nb" }'
  end
end
