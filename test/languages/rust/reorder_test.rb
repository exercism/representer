require_relative "stage_helper"

# Tests Rust's Reorder stage, through Inspector as a whole, because it
# sorts by the code with the renamed names left out.
class RustReorderTest < InspectorTest
  track "rust"

  def test_the_order_of_items_in_a_file_makes_no_difference
    assert_same_representation "struct A(u32);\nfn f() -> u32 { 1 }\n", "fn f() -> u32 { 1 }\nstruct A(u32);\n"
  end

  def test_the_order_of_items_in_an_impl_makes_no_difference
    assert_same_representation "struct A;\nimpl A { fn b(&self) -> u32 { 1 } fn a(&self) {} }",
      "struct A;\nimpl A { fn a(&self) {} fn b(&self) -> u32 { 1 } }"
  end

  def test_an_attribute_moves_with_its_item
    assert_same_representation "#[derive(Debug)]\nstruct A(u32);\nfn f() -> u32 { 1 }\n",
      "fn f() -> u32 { 1 }\n#[derive(Debug)]\nstruct A(u32);\n"
    refute_same_representation "#[derive(Debug)]\nstruct A(u32);\nstruct B(u64);\n",
      "struct A(u32);\n#[derive(Debug)]\nstruct B(u64);\n"
  end

  def test_the_order_of_statements_in_a_function_stays
    refute_same_representation "fn f() { let a = 1; g(a); }", "fn f() { g(a); let a = 1; }"
  end
end
