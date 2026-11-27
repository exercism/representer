require "test_helper"

# The old raku-representer has two golden tests, normalize-whitespace and
# remove-comments. Both are ported. Differences:
#
# - The old representer replaced every name in Rakudo's AST dump, including
#   `export` and `return`, which Raku defines. This one only renames the
#   module and sub that the student defines, so the old mapping's `export` and
#   `return` are removed, and the others are written without the quotes that
#   the old mapping kept.
# - Each test's `.meta/config.json` is not copied, because it only said which
#   file was the solution.
class RakuTest < RepresenterTest
  extend UpstreamTests

  track "raku"

  OLD_NAMES = ["\"HelloWorld\"", "\"hello\"", "\"export\"", "\"return\""].freeze
  DEVIATIONS = %w[normalize-whitespace remove-comments].to_h do |name|
    [name, { remove: OLD_NAMES, add: %w[HelloWorld hello],
             why: "The old representer renamed every name, even `export` and `return`, and wrote the names in quotes." }]
  end.freeze

  upstream_tests ".rakumod", deviations: DEVIATIONS

  def wrap(body) = "sub f($x, $y) { #{body} }"

  def test_variables_are_renamed
    assert_same_representation "sub f($a) { my $b = $a + 1; $b }", "sub g($c) { my $d = $c + 1; $d }"
    refute_same_representation "sub f($a) { my $b = $a + 1; $b }", "sub f($a) { my $b = $a + 1; $a }"
    refute_same_representation wrap('"a $x"'), wrap('"a $y"')
  end

  def test_the_sigil_is_part_of_the_name
    refute_same_representation "sub f(@a) { @a[0] }", "sub f($a) { $a[0] }"
    assert_same_representation "my @list = 1; my $count = 2;", "my @items = 1; my $n = 2;"
  end

  def test_sigilless_variables_and_loops
    assert_same_representation "sub f($x) { my \\a = $x; a }", "sub f($x) { my \\b = $x; b }"
    assert_same_representation "sub f(@a) { for @a -> $i { say $i } }", "sub f(@b) { for @b -> $j { say $j } }"
    assert_same_representation "my ($a, $b) = 1, 2; say $a + $b", "my ($c, $d) = 1, 2; say $c + $d"
  end

  def test_subs_methods_and_classes_are_renamed
    assert_same_representation "class Foo { method area($x) { $x } }", "class Bar { method size($y) { $y } }"
    assert_same_representation "sub add($a, $b) { $a + $b }\nsay add(1, 2)", "sub plus($a, $b) { $a + $b }\nsay plus(1, 2)"
  end

  def test_core_names_are_kept_if_the_solution_only_calls_them
    refute_same_representation "sub f($x) { $x.sum }", "sub f($x) { $x.max }"
    assert_same_representation "method sum { 1 }", "method max { 1 }"
    refute_same_representation "sub f($x) { say $x }", "sub f($x) { put $x }"
  end

  def test_public_attributes_and_named_parameters_are_kept
    refute_same_representation "class A { has $.size }", "class A { has $.width }"
    refute_same_representation "sub f(:$size) { 1 }", "sub f(:$width) { 1 }"
  end

  def test_unbalanced_code_is_unrepresentable
    assert_unrepresentable "sub f($x) { $x "
  end
end
