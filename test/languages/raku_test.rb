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

  ### Formatting ###

  def test_comments_and_pod_are_dropped
    assert_same_representation "# note\n=begin pod\ndocs\n=end pod\nsub f($x) { #`(inline) $x }", "sub f($x) { $x }"
  end

  def test_semicolons_and_parentheses
    assert_same_representation wrap("$x + $y;"), wrap("($x + $y)")
    assert_same_representation "sub f($x) { if ($x) { 1 } }", "sub f($x) { if $x { 1 } }"
  end

  def test_numbers_with_underscores
    assert_same_representation wrap("1_000"), wrap("1000")
    refute_same_representation wrap("1000"), wrap("100")
  end

  def test_strings
    assert_same_representation wrap("'a b'"), wrap('"a b"')
    assert_same_representation wrap("'it\\'s'"), wrap('"it\'s"')
    assert_same_representation wrap("‘a’"), wrap("'a'")
    assert_same_representation wrap('"a\\nb"'), wrap("\"a\nb\"")
    refute_same_representation wrap("'a\\nb'"), wrap('"a\\nb"')
    refute_same_representation wrap("'a'"), wrap("'b'")
  end

  def test_interpolation_stays
    refute_same_representation wrap('"a $x"'), wrap("'a $x'")
    refute_same_representation wrap('"a $x"'), wrap('"a $y"')
  end

  ### Statement modifiers ###

  def test_statement_modifiers
    assert_same_representation wrap("say $x if $y;"), wrap("if $y { say $x }")
    assert_same_representation wrap("say $x unless $y;"), wrap("unless $y { say $x }")
    assert_same_representation wrap("say $_ for $x;"), wrap("for $x { say $_ }")
    refute_same_representation wrap("say $x if $y;"), wrap("say $x unless $y;")
  end

  ### Names ###

  def test_variables_are_renamed
    assert_same_representation "sub f($a) { my $b = $a + 1; $b }", "sub g($c) { my $d = $c + 1; $d }"
    refute_same_representation "sub f($a) { my $b = $a + 1; $b }", "sub f($a) { my $b = $a + 1; $a }"
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

  def test_core_names_are_kept
    refute_same_representation "sub f($x) { $x.sum }", "sub f($x) { $x.max }"
    refute_same_representation "method sum { 1 }", "method max { 1 }"
    refute_same_representation "sub f($x) { say $x }", "sub f($x) { put $x }"
  end

  def test_public_attributes_and_named_parameters_are_kept
    refute_same_representation "class A { has $.size }", "class A { has $.width }"
    refute_same_representation "sub f(:$size) { 1 }", "sub f(:$width) { 1 }"
  end

  def test_names_the_tests_use_are_kept
    tests = { "f.rakutest" => "use Foo; is two-fer(), 1;" }
    refute_same_representation "sub two-fer() { 1 }", "sub other() { 1 }", exercise_files: tests
    assert_equal({}, represent("sub two-fer() { 1 }", exercise_files: tests).mapping)
  end

  ### Unrepresentable ###

  def test_unbalanced_code_is_unrepresentable
    assert_unrepresentable "sub f($x) { $x "
  end

  def test_heredoc_indentation_is_removed
    assert_same_representation "sub f {\n    my $x = q:to/END/;\n        hello\n          world\n        END\n    return $x;\n}\n",
      "sub f {\n    my $x = q:to/END/;\n    hello\n      world\n    END\n    return $x;\n}\n"
    refute_same_representation "sub f {\n    my $x = q:to/END/;\n    hello\n      world\n    END\n    return $x;\n}\n",
      "sub f {\n    my $x = q:to/END/;\n    hello\n    world\n    END\n    return $x;\n}\n"
  end

  def test_module_imports_are_dropped_and_pragmas_stay
    assert_same_representation "use Test;\nuse JSON::Fast;\nneed Foo;\nsub f($x) { $x }", "sub f($x) { $x }"
    refute_same_representation "use v6;\nsub f($x) { $x }", "sub f($x) { $x }"
    refute_same_representation "use lib 'lib';\nsub f($x) { $x }", "sub f($x) { $x }"
  end

  def test_numbers_are_their_values
    assert_same_representation wrap("$x + 1_000 + 0x1F"), wrap("$x + 1000 + 31")
    assert_same_representation wrap("$x * 1.50"), wrap("$x * 1.5")
    refute_same_representation wrap("$x * 1e0"), wrap("$x * 1.0")
    refute_same_representation wrap("$x * 1.0"), wrap("$x * 1")
  end
end
