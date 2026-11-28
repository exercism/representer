require_relative "stage_helper"

# Checks C++'s declarations of which nodes are names and which nodes define
# them (see cpp/representation.rb), through the engine's renaming.
class CppNamesTest < Minitest::Test
  include CppStages

  def test_renames_namespaces_types_and_macros
    source = "namespace a { namespace b::c { } }\nclass D { };\nstruct E { };\nunion F { int x; };\nenum class G { H };\n" \
             "using I = int;\ntypedef int J;\n#define K 1\n#define L(x) x\n"
    assert_equal %w[D E F G H I J K L a b c x], renamed(source)
  end

  def test_renames_template_parameters
    assert_equal %w[T Ts f g], renamed("template <typename T> T f();\ntemplate <typename... Ts> void g();")
  end

  def test_renames_functions_methods_and_fields
    source = "class A {\n  int b;\n  int* c;\n  int d[2];\n  int e() const;\n  int f, g;\n};\nint A::e() const { return b; }"
    assert_equal %w[A b c d e f g], renamed(source)
  end

  def test_renames_a_function_defined_with_its_scope
    assert_equal %w[f g], renamed("int A::B::f() { return 1; }\nint C<int>::g() { return 2; }")
  end

  def test_renames_variables_and_parameters
    source = "int f(int a, char** b, const int& c, int d = 1) {\n  int e = a, g;\n  int h[2], i;\n  int* j = &e;\n" \
             "  auto [k, l] = pair();\n  for (auto m : v) { }\n  return a;\n}"
    assert_equal %w[a b c d e f g h i j k l m], renamed(source)
  end

  def test_renames_labels
    assert_equal %w[done f], renamed("void f() { goto done; done: return; }")
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("namespace a { int f(int n) { return n; } }\nint g() { return a::f(1); }")
    assert(marks.select { |text, _| %w[a f].include?(text) }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    source = "int f(std::vector<int> v) { std::string s; return std::count(v.begin(), v.end(), 1) + v.size(); }"
    assert_equal %w[f s v], renamed(source)
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[a count main], renamed("int count(int a) { return a; }\nint main() { return count(1); }")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Cpp::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Cpp::Representation::Spec.name?(node) }
    leaves
  end
end
