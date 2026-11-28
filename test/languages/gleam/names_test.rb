require_relative "stage_helper"

# Checks Gleam's declarations of which nodes are names and which nodes define
# them (see gleam/representation.rb), through the engine's renaming.
class GleamNamesTest < Minitest::Test
  include GleamStages

  def test_renames_functions_constants_and_parameters
    source = "const limit = 1\npub fn area(width: Int, with height: Int) { width * height * limit }\n" \
             "pub fn g() { fn(y) { y } }\n"
    assert_equal %w[area g height limit width y], renamed(source)
  end

  def test_renames_types_constructors_and_fields
    source = "pub type Shape {\n  Circle(radius: Float)\n}\npub type Size = Int\n" \
             "pub fn f(s: Shape) { s.radius }\n"
    assert_equal %w[Circle Shape Size f radius s], renamed(source)
  end

  def test_renames_the_variables_bound_by_patterns
    source = "pub fn f(xs) {\n  let a = 1\n  let assert [h, ..t] = xs\n  use z <- g(xs)\n" \
             "  case xs { [p] as whole -> p\n _ -> a }\n}\n"
    assert_equal %w[a f h p t whole xs z], renamed(source)
  end

  def test_renames_external_functions
    assert_equal ["now"], renamed("@external(erlang, \"os\", \"timestamp\")\nfn now() -> Int\n")
  end

  def test_keeps_names_the_solution_does_not_define
    source = "pub fn f(name n: String) { case n { \"\" -> option.None\n _ -> list.length([]) } }\n"
    assert_equal %w[f n], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Gleam::Representation::Spec)
    names = []
    tree.each_descendant { |node| names << Gleam::Representation::Spec.name_text(node) if node.renamed }
    names.uniq.sort
  end
end
