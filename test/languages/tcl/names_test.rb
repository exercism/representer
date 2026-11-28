require_relative "stage_helper"

# Checks which names Tcl's GenerateAST marks as defined (see
# tcl/representation/spec.rb), through the engine's renaming.
class TclNamesTest < Minitest::Test
  include TclStages

  def test_renames_variables_that_are_set
    assert_equal %w[total], renamed("set total 0\nputs $total")
    assert_equal %w[::count], renamed("set ::count 0\nputs $::count")
  end

  def test_renames_procedures_and_their_parameters
    assert_equal %w[area h w], renamed("proc area {w h} { expr {$w * $h} }")
    assert_equal %w[b f], renamed("proc f {{b 1}} { return $b }")
    assert_equal %w[f n], renamed("proc f n { return $n }")
  end

  def test_keeps_args_which_takes_the_rest_of_the_arguments
    assert_equal %w[f], renamed("proc f args { return $args }")
    assert_equal %w[a f], renamed("proc f {a args} { list $a $args }")
  end

  def test_renames_loop_variables
    assert_equal %w[x], renamed("foreach x $list { puts $x }")
    assert_equal %w[k v], renamed("foreach {k v} $pairs { puts $k$v }")
    assert_equal %w[x], renamed("lmap x $list { expr {$x * 2} }")
    assert_equal %w[k v], renamed("dict for {k v} $d { puts $k }")
  end

  def test_renames_the_variables_that_commands_create
    assert_equal %w[out], renamed("lappend out 1")
    assert_equal %w[n], renamed("incr n")
    assert_equal %w[s], renamed("append s x")
    assert_equal %w[a b], renamed("lassign $pair a b")
    assert_equal %w[counts], renamed("dict incr counts $word")
    assert_equal %w[counts], renamed("array set counts {}")
    assert_equal %w[line], renamed("gets stdin line")
    assert_equal %w[x y], renamed("scan $s %d%d x y")
    assert_equal %w[total], renamed("upvar 1 $name total")
    assert_equal %w[a b], renamed("upvar x a y b")
  end

  def test_renames_the_variables_that_matching_sets
    assert_equal %w[-> m], renamed("regexp -nocase {(a)} $s -> m")
    assert_equal %w[m], renamed("regexp -start 2 -- {a} $s m")
    assert_equal %w[out], renamed("regsub -all {a} $s b out")
    assert_equal %w[e], renamed("catch {f} e")
    assert_equal %w[e], renamed("try { f } on error {e} { puts $e }")
  end

  def test_renames_namespaces_classes_and_methods
    assert_equal %w[counter], renamed("namespace eval counter {}")
    assert_equal %w[Shape a area], renamed("oo::class create Shape { method area {a} { return $a } }")
    assert_equal %w[n], renamed("oo::class create S { constructor {n} {} }") - %w[S]
    assert_equal %w[items], renamed("oo::class create S { variable items }") - %w[S]
    assert_equal %w[items], renamed("my variable items")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal [], renamed("puts [string toupper $s]")
    assert_equal [], renamed("global counter")
  end

  def test_renames_every_use_of_a_defined_name
    source = "proc f {x} { return [g $x] }\nproc g {y} { return $y }\nf 1"
    expected = [["f", true], ["x", true], ["g", true], ["x", true], ["g", true], ["y", true], ["y", true], ["f", true],
                ["1", false]]
    assert_equal(expected, marks(source).reject { |text, _| text == "return" })
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Tcl::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Tcl::Representation::Spec.name?(node) }
    leaves
  end
end
