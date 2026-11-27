require_relative "stage_helper"

# Checks C's declarations of which nodes are names and which nodes define
# them (see c/representation.rb), through the engine's renaming.
class CNamesTest < Minitest::Test
  include CStages

  def test_renames_types_and_macros
    source = "struct A { int x; };\nunion B { int y; };\nenum C { D };\ntypedef int E;\ntypedef struct { int z; } *F;\n" \
             "#define G 1\n#define H(n) n\n"
    assert_equal %w[A B C D E F G H x y z], renamed(source)
  end

  def test_renames_functions_and_fields
    source = "struct A { int b, *c; int d[2]; };\nint e(void);\nint f(struct A a) { return a.b + *a.c; }"
    assert_equal %w[A a b c d e f], renamed(source)
  end

  def test_renames_variables_and_parameters
    source = "int f(int a, char **b, int c[]) {\n  int d = a, e;\n  int g[2], h;\n  int *i = &d;\n  int (*j)(int) = 0;\n" \
             "  for (int k = 0; k < 1; k++) { }\n  return a;\n}"
    assert_equal %w[a b c d e f g h i j k], renamed(source)
  end

  def test_renames_labels
    assert_equal %w[done f], renamed("void f(void) { goto done; done: return; }")
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("struct point { int x; };\nint f(struct point p) { return p.x; }\nint g(void) { return f((struct point){ 1 }); }")
    assert(marks.select { |text, _| %w[point x f p].include?(text) }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    source = "size_t f(const char *s) { char *t = malloc(strlen(s)); free(t); return SIZE_MAX; }"
    assert_equal %w[f s t], renamed(source)
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[a abs main], renamed("int abs(int a) { return a; }\nint main(void) { return abs(1); }")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], C::Representation)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if C::Representation.name?(node) }
    leaves
  end
end
