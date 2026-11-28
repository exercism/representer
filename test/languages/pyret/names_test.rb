require_relative "stage_helper"

# Checks Pyret's declarations of which nodes are names and which nodes define
# them (see pyret/representation/spec.rb), through the engine's renaming.
class PyretNamesTest < Minitest::Test
  include PyretStages

  def test_renames_functions_parameters_and_bindings
    source = "fun f(a, shadow b) -> Number: c = a + b\n var d = c\n for map(e from [list: 1]): e end end"
    assert_equal %w[a b c d e f], renamed(source)
  end

  def test_renames_tuple_bindings_and_cases_bindings
    assert_equal %w[a b c], renamed("{a; b} as c = t")
    assert_equal %w[h t], renamed("cases(List) xs: | empty => 0 | link(h, t) => h end")
  end

  def test_renames_data_types_variants_and_fields
    assert_equal %w[Shape circle r square], renamed("data Shape: | circle(r :: Number) | square end")
  end

  def test_renames_type_parameters_and_aliases
    assert_equal %w[A Point f xs], renamed("type Point = Number\nfun f<A>(xs :: List<A>): xs end")
  end

  def test_renames_object_keys
    assert_equal %w[count o self total], renamed("o = { count: 0, method total(self): self.count end }")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal [], renamed("num-modulo(year, 4) == 0")
    assert_equal ["x"], renamed("x :: Number = L.map(string-length, [list: 1])")
    assert_equal ["r"], renamed("r = reactor: init: 0, on-tick: num-sqr end")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Pyret::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Pyret::Representation::Spec.name?(node) }
    leaves
  end
end
