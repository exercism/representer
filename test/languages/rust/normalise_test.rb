require_relative "stage_helper"

# Tests Rust's Normalise stage, which gives one form to spellings that Rust
# reads the same way.
class RustNormaliseTest < Minitest::Test
  include RustStages

  def test_drops_use_and_extern_crate
    assert_same "use std::collections::HashMap;\npub use std::fmt;\nuse std::{a, b};\nextern crate foo;\nfn f() {}",
      "fn f() {}"
    refute_same "fn f() { std::cmp::max(1, 2); }", "fn f() { std::cmp::min(1, 2); }"
  end

  def test_moves_each_attribute_into_its_item
    assert_includes tree("#[derive(Debug)]\nstruct A;"), "(struct_item A\n    (attribute_item"
  end

  def test_drops_the_semicolon_after_an_assignment
    assert_same "fn f(x: &mut u32) { *x = 1 }", "fn f(x: &mut u32) { *x = 1; }"
    assert_same "fn f(x: &mut u32) { *x += 1 }", "fn f(x: &mut u32) { *x += 1; }"
  end

  def test_unwraps_a_match_arm_block_that_holds_one_expression
    assert_same wrap("match 1 { 1 => { 2 }, _ => 3 };"), wrap("match 1 { 1 => 2, _ => 3 };")
    refute_same wrap("match 1 { 1 => { g(); 2 }, _ => 3 };"), wrap("match 1 { 1 => 2, _ => 3 };")
    assert_same wrap("match 1 { 1 => {}, _ => () };"), wrap("match 1 { 1 => (), _ => {} };")
  end

  def test_writes_shorthand_fields_in_full
    assert_same "fn f(x: u32) -> P { P { x } }", "fn f(x: u32) -> P { P { x: x } }"
    assert_same "fn f(p: P) { let P { x } = p; }", "fn f(p: P) { let P { x: x } = p; }"
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
