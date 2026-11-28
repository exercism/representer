require_relative "stage_helper"

# Checks Free Pascal's declarations of which nodes are names and which nodes
# define them (see free_pascal/representation/spec.rb), through the engine's
# renaming.
class FreePascalNamesTest < Minitest::Test
  include FreePascalStages

  def test_renames_functions_parameters_and_variables
    code = "function f(const a, b: integer; var c: real): boolean; var d: integer; begin d := a; result := true end;"
    assert_equal %w[a b c d f u], renamed(code)
  end

  def test_renames_constants_and_exception_variables
    assert_equal %w[e m p u], renamed("const m = 1; procedure p; begin try x except on e: exception do raise end end;")
  end

  def test_renames_types_fields_properties_and_enumerations
    code = "type tp = record x, y: integer; end; tc = class private fn: string; public property n: string read fn; end; " \
           "te = (red, green);"
    assert_equal %w[fn green n red tc te tp u x y], renamed(code)
  end

  def test_renames_generic_types_and_their_parameters
    assert_equal %w[t tbox u v], renamed("type generic tbox<t> = class v: t; end;")
  end

  def test_renames_methods_where_they_are_defined
    code = "type tc = class procedure go; end; procedure tc.go; begin end;"
    assert_equal %w[go tc u], renamed(code)
  end

  def test_renames_the_result_of_an_operator
    assert_equal %w[a b r tr u], renamed("type tr = record end; operator + (a, b: tr) r: tr; begin end;")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[p u], renamed("procedure p; begin result := inttostr(length(s)); writeln(x.create) end;")
  end

  def test_ignores_the_case_of_names
    assert_equal %w[count p u], renamed("var Count: integer; procedure P; begin COUNT := 1 end;")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(code) = marks(code).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(code)
    tree = prepare(code)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], FreePascal::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if FreePascal::Representation::Spec.name?(node) }
    leaves
  end
end
