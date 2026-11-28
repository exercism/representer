require_relative "stage_helper"

# Checks Rust's declarations of which nodes are names and which nodes define
# them (see rust/representation.rb), through the engine's renaming.
class RustNamesTest < Minitest::Test
  include RustStages

  def test_renames_types_and_their_parameters
    source = "mod m { } struct S<'a, T, const N: usize>(&'a T); enum E { V } union U { x: u8 } trait Tr { type A; } " \
             "type G = u8;"
    assert_equal %w[A E G N S T Tr U V a m x], renamed(source)
  end

  def test_renames_functions_constants_fields_and_methods
    source = "const C: u8 = 1; static D: u8 = 2; struct P { x: u8 } " \
             "impl P { fn get(&self) -> u8 { self.x } } trait Q { fn q(&self); }"
    assert_equal %w[C D P Q get q x], renamed(source)
  end

  def test_renames_parameters_locals_and_labels
    source = "fn f(a: u8) { let b = a; let mut c = |d, e: u8| d; 'outer: loop { break 'outer; } }"
    assert_equal %w[a b c d e f outer], renamed(source)
  end

  def test_renames_the_variables_that_patterns_bind
    source = "fn f() { for (a, mut b) in x { } if let Some(c) = y { } match z { [d, ..] => 0, e @ 1 => 0, " \
             "&g => 0, P { x: h, .. } => 0, Some(ref i) => 0, j => 0 }; }"
    assert_equal %w[a b c d e f g h i j], renamed(source)
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("enum E { A } fn f() -> E { E::A }")
    assert(marks.select { |text, _| %w[A E].include?(text) }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f x], renamed("fn f() { let x = std::cmp::max(1, 2); println!(\"{}\", x.to_string()); }")
  end

  def test_keeps_the_variants_and_constants_in_patterns
    assert_equal %w[f r v], renamed("fn f(r: Result<u8, u8>) -> u8 { match r { Ok(v) => v, Err(_) => 0 } }")
    assert_equal %w[f o], renamed("fn f(o: Option<u8>) -> u8 { match o { None => 0, _ => 1 } }")
  end

  def test_renames_library_names_the_solution_defines
    source = "fn main() { } impl Iterator for S { type Item = u8; fn next(&mut self) -> Option<u8> { None } }"
    assert_equal %w[Item main next], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Rust::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Rust::Representation::Spec.name?(node) }
    leaves
  end
end
