require_relative "stage_helper"

# Tests Cairo's Normalise stage, which gives one form to spellings that Cairo
# reads the same way.
class CairoNormaliseTest < Minitest::Test
  include CairoStages

  def test_drops_use
    assert_same "use core::array::ArrayTrait;\npub use core::dict::{Felt252Dict, Felt252DictTrait};\nfn f() {}",
      "fn f() {}"
  end

  def test_writes_shorthand_fields_in_full
    assert_same "fn f(x: u32) -> P { P { x } }", "fn f(x: u32) -> P { P { x: x } }"
    assert_same "fn f(p: P) -> u32 { let P { x } = p; x }", "fn f(p: P) -> u32 { let P { x: x } = p; x }"
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
end
