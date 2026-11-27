require_relative "stage_helper"

# Checks Cairo's declarations of which nodes are names and which nodes define
# them (see cairo/representation.rb), through the engine's renaming.
class CairoNamesTest < Minitest::Test
  include CairoStages

  def test_renames_types_and_their_parameters
    source = "mod m { } struct S<T> { x: T } enum E { V, W: u8 } trait Tr<T> { } impl I of Tr<S> { } type G = u8;"
    assert_equal %w[E G I S T Tr V W m x], renamed(source)
  end

  def test_leaves_the_trait_of_an_impl_alone
    assert_equal ["I"], renamed("impl I of Into { }")
  end

  def test_renames_functions_constants_and_fields
    source = "const C: u8 = 1; struct P { x: u8 } trait Q { fn q(self: @P) -> u8; } " \
             "impl R of Q { fn q(self: @P) -> u8 { *self.x } }"
    assert_equal %w[C P Q R q self x], renamed(source)
  end

  def test_renames_parameters_and_locals
    source = "fn f(a: u8, ref v: Array<u8>) { let b = a; let mut c = |d, e: u8| d; }"
    assert_equal %w[a b c d e f v], renamed(source)
  end

  def test_renames_the_variables_that_patterns_bind
    source = "fn f() { for (a, mut b) in x { } if let Option::Some(c) = y { } match z { [d, _] => 0, " \
             "P { x: h, .. } => 0, j => 0 }; }"
    assert_equal %w[a b c d f h j], renamed(source)
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("enum E { A } fn f() -> E { E::A }")
    assert(marks.select { |text, _| %w[A E].include?(text) }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f v], renamed("fn f() { let mut v = array![]; v.append(1); core::num::traits::Pow::pow(2, 3); }")
  end

  def test_keeps_the_variants_in_patterns
    assert_equal %w[f r v], renamed("fn f(r: Result<u8, u8>) -> u8 { match r { Ok(v) => v, Err(_) => 0 } }")
    assert_equal %w[f o], renamed("fn f(o: Option<u8>) -> u8 { match o { None => 0, _ => 1 } }")
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[a len main], renamed("fn main() { } fn len(a: u32) -> u32 { a.len() }")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Cairo::Representation)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Cairo::Representation.name?(node) }
    leaves
  end
end
