require_relative "stage_helper"

# Checks C#'s declarations of which nodes are names and which nodes define
# them (see csharp/spec.rb), through the engine's renaming.
class CSharpNamesTest < Minitest::Test
  include CSharpStages

  def test_renames_namespaces_and_types
    source = "namespace N { class A<T> { } struct B { } interface I { } record R(int X); enum E { F } delegate int D(int y); }"
    assert_equal %w[A B D E F I N R T X y], renamed(source)
  end

  def test_renames_members
    source = "class A { int f; int P { get; set; } event Action V { add { } remove { } } void M() { int L() => 1; } }"
    assert_equal %w[A L M P V f], renamed(source)
  end

  def test_renames_parameters_and_local_variables
    source = "class A { void M(int a, (int b, int c) t) { var d = 1; var (e, g) = t; Func<int, int> h = i => i; " \
             "Func<int, int> j = (k) => k; foreach (var l in xs) { } try { } catch (Exception m) { } } }"
    assert_equal %w[A M a b c d e g h i j k l m t], renamed(source)
  end

  def test_renames_the_variables_of_patterns_and_out_var
    source = "class A { void M() { if (o is int a) { } if (o is { X: 0 } b) { } if (o is var c) { } " \
             "var x = o switch { var (d, e) => d }; if (o is [1] f) { } int.TryParse(s, out var g); } }"
    assert_equal %w[A M a b c d e f g x], renamed(source)
  end

  def test_renames_the_variables_of_queries
    assert_equal %w[a b c q], renamed("var q = from a in xs let b = a join c in ys on b equals c select c;")
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("class A { static int Go() => 1; int B() => A.Go() + this.Go(); }")
    assert(marks.select { |text, _| %w[A Go].include?(text) }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[A M x], renamed("class A { void M() { var x = Math.Max(1, 2); Console.WriteLine(x.ToString()); } }")
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[A Main ToString], renamed("class A { static void Main() { } public override string ToString() => \"\"; }")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], CSharp::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if CSharp::Representation::Spec.name?(node) }
    leaves
  end
end
