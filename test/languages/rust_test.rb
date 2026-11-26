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

  DEVIATIONS = {
    "generics" => IMPL_TYPE,
    "ignore_comments" => IMPL_TYPE,
    "impl_blocks" => IMPL_TYPE,
    "sort_by_ascii_file_items" => IMPL_TYPE,
    "user_defined_traits" => IMPL_TYPE,
    "fn_calls" => { restore: { "PLACEHOLDER_2" => "square" }, remove: ["square"], why: format(UNDEFINED, "square") },
    "for_loops" => { restore: { "PLACEHOLDER_3" => "lines" }, remove: ["lines"], why: format(UNDEFINED, "lines") },
    "if_expressions" => { restore: { "PLACEHOLDER_1" => "x" }, remove: ["x"], why: format(UNDEFINED, "x") },
    "if_let_expressions" => { restore: { "PLACEHOLDER_2" => "my_func" }, remove: ["my_func"], why: format(UNDEFINED, "my_func") },
    "loops" => { restore: { "PLACEHOLDER_1" => "x" }, remove: ["x"], why: format(UNDEFINED, "x") },
    "method_calls" => { restore: { "PLACEHOLDER_2" => "pi" }, remove: ["pi"], why: format(UNDEFINED, "pi") },
    "while_loops" => { restore: { "PLACEHOLDER_2" => "x" }, remove: ["x"], why: format(UNDEFINED, "x") },
    "type_aliases" => {
      add: ["T"],
      why: "The old representer left the type parameter T of a type alias. This representer renames it, as it does in a " \
           "struct, so the equivalent has a placeholder for T."
    },
    "union_names" => {
      add: %w[A B x y],
      why: "The old representer left the type parameters and fields of a union. This representer renames them, as it " \
           "does in a struct, so the equivalent has placeholders for them."
    }
  }.freeze

  upstream_tests ".rs", deviations: DEVIATIONS

  def wrap(body) = "fn f() {\n#{body}\n}\n"

  def test_semicolons_after_statements_are_dropped
    assert_same_representation wrap("let a = 1; let b = 2;"), wrap("let a = 1;\nlet b = 2;")
    assert_same_representation "struct A;", "struct A;;"
  end

  def test_a_trailing_semicolon_still_changes_the_result
    refute_same_representation wrap("1"), wrap("1;")
  end

  def test_array_repeat_is_not_an_array_list
    refute_same_representation wrap("let a = [0; 5];"), wrap("let a = [0, 5];")
    refute_same_representation wrap("let a = vec![0; 5];"), wrap("let a = vec![0, 5];")
  end

  def test_parentheses
    assert_same_representation wrap("let a = (1 + 2);"), wrap("let a = 1 + 2;")
    refute_same_representation wrap("let a = (1 + 2) * 3;"), wrap("let a = 1 + 2 * 3;")
  end

  def test_shorthand_fields
    assert_same_representation "struct P { x: u32 }\nfn f(x: u32) -> P { P { x } }",
      "struct P { x: u32 }\nfn f(x: u32) -> P { P { x: x } }"
    assert_same_representation "struct P { x: u32 }\nfn f(p: P) { let P { x } = p; }",
      "struct P { x: u32 }\nfn f(p: P) { let P { x: x } = p; }"
  end

  def test_strings
    assert_same_representation wrap('let s = "a\\u{41}";'), wrap('let s = "aA";')
    assert_same_representation wrap('let s = r"a";'), wrap('let s = "a";')
    refute_same_representation wrap('let s = b"a";'), wrap('let s = "a";')
    refute_same_representation wrap('let s = r"\\n";'), wrap('let s = "\\n";')
  end

  def test_items_are_sorted_with_their_attributes
    assert_same_representation "#[derive(Debug)]\nstruct A(u32);\nfn f() -> u32 { 1 }\nuse std::fmt;\n",
      "use std::fmt;\nfn f() -> u32 { 1 }\n#[derive(Debug)]\nstruct A(u32);\n"
    refute_same_representation "#[derive(Debug)]\nstruct A(u32);\nstruct B(u32);\n",
      "struct A(u32);\n#[derive(Debug)]\nstruct B(u32);\n"
  end

  def test_names_in_a_different_order_in_impls
    assert_same_representation "struct A;\nimpl A { fn b(&self) -> u32 { 1 } fn a(&self) {} }",
      "struct A;\nimpl A { fn a(&self) {} fn b(&self) -> u32 { 1 } }"
  end

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

  def test_a_method_named_like_a_library_method_keeps_its_name
    code = "struct S(u32);\nimpl S { fn %s(&self) -> u32 { self.0 } }"
    refute_same_representation format(code, "len"), format(code, "size")
    assert_same_representation format(code, "total"), format(code, "amount")
  end

  def test_trait_methods_keep_their_names
    code = "struct S;\nimpl std::fmt::Display for S { fn %s(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result { Ok(()) } }"
    refute_same_representation format(code, "fmt"), format(code, "show")
  end

  def test_names_the_tests_use_are_kept
    refute_same_representation "pub fn f() {}", "pub fn g() {}",
      exercise_files: { "tests/t.rs" => "use p::*;\n#[test]\nfn t() { f(); }\n" }
  end

  def test_syntax_errors_are_unrepresentable
    assert_unrepresentable "fn f( {\n"
  end

  # A rule that drops ";" tokens also matched the contents of the string ";",
  # and kept matching it.
  def test_a_string_holding_a_semicolon
    refute_same_representation 'fn f() -> &str { ";" }', 'fn f() -> &str { ":" }'
  end

  def test_files_in_other_formats_are_ignored
    code = "pub fn f() {}"
    assert_equal represent(code, filename: "src/lib.rs").representation,
      Representer::RepresentSolution.(track, { "src/lib.rs" => code, "Cargo.toml" => "[package]\nname = \"p\"\n" }, {}).representation
  end

  def test_a_solution_with_no_source_files
    result = Representer::RepresentSolution.(track, { "Cargo.toml" => "[package]" }, {})
    assert_nil result.representation
    assert_equal "no_source_files", result.reason
  end

  def test_windows_line_endings_are_plain_line_breaks
    assert_same_representation "fn f() -> &str {\n    \"a\n b\"\n}\n", "fn f() -> &str {\r\n    \"a\r\n b\"\r\n}\r\n"
    refute_same_representation 'fn f() -> &str { "a\\r\\nb" }', 'fn f() -> &str { "a\\nb" }'
  end

  # A macro's tokens have no syntax tree, so commas and brackets count.
  def test_every_token_in_a_macro_is_kept
    refute_same_representation "fn f(a: i32) -> Vec<i32> { vec![a - 1] }", "fn f(a: i32) -> Vec<i32> { vec![a, -1] }"
    refute_same_representation "fn f() { g(vec![[1, 2]]) }", "fn f() { g(vec![(1, 2)]) }"
  end
end
