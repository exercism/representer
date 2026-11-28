require_relative "stage_helper"

# Checks Idris's declarations of which nodes are names and which nodes
# define them (see idris/representation.rb), through the engine's renaming.
class IdrisNamesTest < Minitest::Test
  include IdrisStages

  def test_renames_modules_types_and_functions
    source = "module A\ndata B c = D | E c\ndata F : Type where\n  G : F\nrecord H where\n  constructor I\n  j : Int\n" \
             "interface K l where\n  m : l -> Int\nnamespace N\n  o : Int\n  o = 1\n"
    assert_equal %w[A B D E F G H I K N c j l m o], renamed(source)
  end

  def test_renames_variables_and_parameters
    source = "f : (n : Nat) -> Vect n a -> a\nf n (x :: xs) = let y = x in g y\n  where g z = case z of\n" \
             "    w@(Just v) => \\u => u\n    _ => do\n      t <- s\n      pure t\n"
    assert_equal %w[a f g n t u v w x xs y z], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f x], renamed("f : List Int -> Int\nf x = sum (map abs x) + length x\n")
    assert_equal %w[f xs], renamed("f : Vect (length xs) Int -> Int\nf = sum\n")
  end

  def test_keeps_constructors_the_solution_does_not_define
    assert_equal %w[f x], renamed("f : Maybe Int -> Int\nf Nothing = 0\nf (Just x) = x\n")
  end

  def test_renames_fields_in_record_updates
    assert_equal %w[MkR R count f r], renamed("record R where\n  constructor MkR\n  count : Nat\nf r = {count $= S} r\n")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Idris::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Idris::Representation::Spec.name?(node) }
    leaves
  end
end
