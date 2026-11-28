require_relative "stage_helper"

# Checks Go's declarations of which nodes are names and which nodes define
# them (see go/representation.rb), through the engine's renaming.
class GoNamesTest < Minitest::Test
  include GoStages

  def test_renames_types_and_functions
    source = "package p\n\ntype A struct{}\ntype B = int\ntype I interface{ M() }\n\nfunc F() {}\n\nfunc (a A) G() {}\n"
    assert_equal %w[A B F G I M a], renamed(source)
  end

  def test_renames_variables_constants_and_fields
    source = "package p\n\nvar a, b int\n\nconst c = 1\n\ntype T struct{ d, e int }\n"
    assert_equal %w[T a b c d e], renamed(source)
  end

  def test_renames_parameters
    source = "package p\n\nfunc F[X any](a, b int, cs ...X) (d int) { return a }\n"
    assert_equal %w[F X a b cs d], renamed(source)
  end

  def test_renames_the_variables_of_statements
    source = in_function("a := 1\nfor b, c := range xs {\n}\nselect {\ncase d := <-ch:\n}\n" \
                         "switch e := a.(type) {\n}\nl: for {\nbreak l\n}")
    assert_equal %w[F a b c d e l], renamed(source)
  end

  def test_keeps_the_blank_identifier
    refute_includes renamed(in_function("for _, v := range xs {\n_ = v\n}")), "_"
  end

  def test_renames_struct_fields_and_methods_after_a_dot
    marks = marks("package p\n\ntype T struct{ a int }\n\nfunc (t T) A() int { return t.a + t.A() }\n")
    assert(marks.select { |text, _| %w[a A].include?(text) }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[F s], renamed("package p\n\nfunc F(s string) { fmt.Println(strings.ToUpper(s)) }\n")
  end

  def test_renames_library_names_the_solution_defines
    source = "package p\n\ntype T int\n\nfunc (t T) String() string { return \"\" }\n\nfunc main() {}\n"
    assert_equal %w[String T main t], renamed(source)
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Go::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Go::Representation::Spec.name?(node) }
    leaves
  end
end
