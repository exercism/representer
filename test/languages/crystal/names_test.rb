require_relative "stage_helper"

# Checks Crystal's declarations of which nodes are names and which nodes
# define them (see crystal/representation.rb), through the engine's renaming.
class CrystalNamesTest < Minitest::Test
  include CrystalStages

  def test_renames_types_and_their_type_variables
    source = "module Shop::Counting\nend\nclass Box(T) < Base\nend\nstruct Point\nend\nenum Color\n  Red\n  Green = 2\nend\n" \
             "alias Count = Int32\nLIMIT = 10\n"
    assert_equal %w[Box Color Count Counting Green LIMIT Point Red Shop T], renamed(source)
  end

  def test_renames_methods_and_macros
    source = "def area\nend\nabstract class A\n  abstract def size\nend\nmacro define(name)\nend\n"
    assert_equal %w[A area define name size], renamed(source)
  end

  def test_renames_parameters
    source = "def f(a, b = 1, *c, **d, &e) forall T\n  xs.each { |x| x }\nend\n"
    assert_equal %w[T a b c d e f x], renamed(source)
  end

  def test_renames_variables
    source = "def f\n  a = 1\n  b, c = 1, 2\n  a += 1\n  d : Int32 = 0\nrescue e : Exception\nend\n"
    assert_equal %w[a b c d e f], renamed(source)
  end

  def test_renames_instance_and_class_variables_with_the_names_of_their_accessors
    source = "class C\n  getter x\n  property y : Int32 = 0\n  @@z = 1\n  def initialize(@x : Int32)\n  end\n" \
             "  def g\n    @y + @@z + x\n  end\nend\n"
    assert_equal %w[C g initialize x y z], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f s], renamed("def f(s)\n  puts s.upcase + Math::PI.to_s\nend\n")
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[C sum to_s], renamed("class C\n  def to_s\n  end\n  def sum\n  end\nend\n")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Crystal::Representation::Spec)
    names = []
    tree.each_descendant { |node| names << Crystal::Representation::Spec.name_text(node) if node.renamed }
    names.uniq.sort
  end
end
