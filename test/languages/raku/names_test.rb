require_relative "stage_helper"

# Checks Raku's declarations of which nodes are names and which nodes define
# them (see raku/representation.rb), through the engine's renaming.
class RakuNamesTest < Minitest::Test
  include RakuStages

  def test_renames_subs_methods_classes_modules_and_constants
    source = "unit module M;\nclass A { method area($x) { $x } }\nsub add($a) { $a }\nconstant LIMIT = 3;"
    assert_equal ["$a", "$x", "A", "LIMIT", "M", "add", "area"], renamed(source)
  end

  def test_renames_variables_and_parameters
    assert_equal ["$a", "$b", "$c", "@d", "\\x", "f"], renamed("sub f($a, @d) { my $b = $a; my ($c) = 1; my \\x = 2; }")
  end

  def test_renames_the_parameters_of_pointy_blocks
    assert_equal ["$i"], renamed("for @a -> $i { say $i }")
  end

  def test_renames_a_sigilless_variable_where_it_is_used
    assert_equal([["\\x", true], ["x", true]], marks("my \\x = 1; f(x);").select { |text, _| text.include?("x") })
  end

  def test_renames_private_attributes
    assert_equal ["$!count", "A", "m"], renamed("class A { has $!count; method m { $!count } }")
  end

  def test_keeps_public_attributes_and_named_parameters
    assert_equal %w[A f], renamed("class A { has $.size; }\nsub f(:$size) { $size }")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal ["$x", "f"], renamed("sub f($x) { say $x.sum + $_ }")
  end

  def test_keeps_a_sigil_apart_from_a_name
    assert_equal([["$count", true], ["count", false]], marks("my $count = count(1);").select { |text, _| text.include?("count") })
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], Raku::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Raku::Representation::Spec.name?(node) }
    leaves
  end
end
