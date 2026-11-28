require_relative "stage_helper"

# Checks PHP's declarations of which nodes are names and which nodes define
# them (see php/representation.rb), through the engine's renaming.
class PHPNamesTest < Minitest::Test
  include PHPStages

  def test_renames_classes_and_their_kin
    source = "<?php class A {} interface I {} trait T {} enum E { case F; }"
    assert_equal %w[A E F I T], renamed(source)
  end

  def test_renames_functions_methods_constants_and_properties
    source = "<?php function f() {} class A { const LIMIT = 1; private $count = 0; function m() { return $this->count; } }"
    assert_equal %w[A LIMIT count f m], renamed(source)
  end

  def test_renames_parameters
    source = "<?php function f(int $a, ...$b) {} class A { function __construct(private $c) {} }"
    assert_equal ["$a", "$b", "$c", "A", "__construct", "f"], renamed(source)
  end

  def test_renames_the_variables_of_assignments
    assert_equal ["$a", "$b", "$c", "$d", "$e"], renamed("<?php $a = 1; $b += 1; $c = &$a; [$d, $e] = $f;")
  end

  def test_renames_the_variables_of_loops_catch_global_static_and_closures
    source = "<?php foreach ($xs as $a) {} foreach ($xs as $b => &$c) {} try {} catch (Exception $d) {} " \
             "$f = function () use ($g) { global $h; static $i = 1; };"
    assert_equal ["$a", "$b", "$c", "$d", "$f", "$g", "$h", "$i"], renamed(source)
  end

  def test_renames_the_variables_passed_to_a_function
    assert_equal ["$matches"], renamed("<?php preg_match('/a/', 'abc', $matches);")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal ["$a", "A", "f"], renamed("<?php class A { function f() { $a = strlen($this->name); return Foo::BAR; } }")
  end

  def test_keeps_variables_apart_from_functions_with_the_same_name
    assert_equal [["$count", true], ["count", false]], marks("<?php $count = count([1, 2]);")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Inspector::Engine::RenameUserDefinedNodes.([tree], PHP::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if PHP::Representation::Spec.name?(node) }
    leaves
  end
end
