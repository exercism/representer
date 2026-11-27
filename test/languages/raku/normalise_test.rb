require_relative "stage_helper"

# Tests Raku's Normalise stage, which gives one form to code that works the
# same way, and the engine's dropping of imports.
class RakuNormaliseTest < Minitest::Test
  include RakuStages

  def test_drops_the_imports_of_modules
    assert_same "use Test;\nuse JSON::Fast;\nneed Foo;\nrequire Bar;\nimport Baz;\nsay 1;", "say 1;"
  end

  def test_keeps_pragmas
    refute_same "use v6;\nsay 1;", "say 1;"
    refute_same "use lib 'lib';\nsay 1;", "say 1;"
    refute_same "use MONKEY-SEE-NO-EVAL;\nsay 1;", "say 1;"
  end

  def test_writes_each_statement_with_a_modifier_as_a_block
    assert_same "say $x if $y;", "if $y { say $x }"
    assert_same "say $x unless $y;", "unless $y { say $x }"
    assert_same "say $_ for @x;", "for @x { say $_ }"
    refute_same "say $x if $y;", "say $x unless $y;"
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
