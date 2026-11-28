require "test_helper"

# Tests Rosetta as a whole on Cairo solutions. The tests of each stage are in
# test/languages/cairo/.
class CairoTest < RosettaTest
  track "cairo"

  def wrap(body) = "fn f(a: u32, b: u32) -> u32 {\n#{body}\n}\n"

  def test_comments_and_formatting
    assert_same_representation "// c\nfn f() -> u32 {\n    1 // x\n}\n", "fn f() -> u32 { 1 }"
    assert_same_representation wrap("let c = (a + b);\nc"), wrap("let c = a + b; c")
    refute_same_representation wrap("(a + b) * a"), wrap("a + b * a")
  end

  def test_names_the_solution_defines_are_renamed
    assert_same_representation wrap("let total = a + b;\ntotal"), wrap("let sum = a + b;\nsum")
    assert_same_representation "fn add(x: u32) -> u32 { x }\nfn g() -> u32 { add(1) }",
      "fn plus(y: u32) -> u32 { y }\nfn g() -> u32 { plus(1) }"
    assert_same_representation "fn main() {}", "fn other() {}"
    refute_same_representation wrap("let total = a + b;\ntotal"), wrap("let total = a + a;\ntotal")
  end

  def test_names_the_solution_does_not_define_are_kept
    refute_same_representation wrap("let mut v = array![];\nv.append(a);\na"), wrap("let mut v = array![];\nv.pop_front();\na")
  end

  def test_a_method_named_like_a_library_method_is_renamed_where_it_is_called_too
    refute_same_representation "fn len(a: u32) -> u32 { a.len() }", "fn size(a: u32) -> u32 { a.len() }"
  end

  def test_use_is_dropped
    assert_same_representation "use core::array::ArrayTrait;\nfn f() -> u32 {\n    1\n}\n", "fn f() -> u32 {\n    1\n}\n"
  end

  def test_numbers_are_their_values
    assert_same_representation wrap("a + 1_000 + 0x1F + 10_u32"), wrap("a + 1000 + 31 + 10_u32")
    refute_same_representation wrap("a + 10_u8"), wrap("a + 10")
  end

  def test_shorthand_fields
    assert_same_representation "fn f(x: u32) -> P { P { x } }", "fn f(x: u32) -> P { P { x: x } }"
  end
end
