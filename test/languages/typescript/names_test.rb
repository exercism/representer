require_relative "stage_helper"

# Checks TypeScript's declarations of which nodes are names and which nodes
# define them (see typescript/representation.rb), through the engine's
# renaming.
class TypeScriptNamesTest < Minitest::Test
  include TypeScriptStages

  def test_renames_types_and_their_type_parameters
    source = "class A<T> {}\nabstract class B {}\ninterface I {}\ntype P<U> = U extends Array<infer V> ? V : never\nenum E { F }"
    assert_equal %w[A B E F I P T U V], renamed(source)
  end

  def test_renames_functions
    source = "function a() {}\nfunction* b() {}\nconst c = function d() {}\nfunction e(): void;"
    assert_equal %w[a b c d e], renamed(source)
  end

  def test_renames_members
    source = "class A { b = 1; #c = 2; d() {} constructor(private e: number) {} }\n" \
             "interface I { f: number; g(): void }\nabstract class J { abstract h(): void }\nenum K { l, m = 1 }"
    assert_equal %w[#c A I J K b constructor d e f g h l m], renamed(source)
  end

  def test_renames_variables_and_parameters
    source = "const a = 1\nlet [b, c = 2] = xs\nd = 3\nfunction f(g: number, h?: string, ...i: number[]) {}\n" \
             "xs.map(j => j)\nfor (const k of xs) {}\ntry {} catch (l) {}\nm: for (;;) { break m }"
    assert_equal %w[a b c d f g h i j k l m], renamed(source)
  end

  def test_renames_the_names_in_types
    source = "type A = { [b: string]: number }\nfunction c(d: unknown): d is string { return true }\ntype E = { [F in G]: number }"
    assert_equal %w[A E F b c d], renamed(source)
  end

  def test_renames_every_use_of_a_defined_name
    marks = marks("class A { go() { return 1 } }\nconst b: A = new A()\nb.go()")
    assert(marks.select { |text, _| %w[A go].include?(text) }.all?(&:last))
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[x], renamed("const x = Math.abs(-1)\nconsole.log(x.toFixed(2))")
  end

  def test_renames_shorthand_properties_and_properties_set_on_this
    marks = marks("const a = 1\nconst o = { a }\nclass B { constructor() { this.c = 1 } }")
    assert(marks.select { |text, _| %w[a c].include?(text) }.all?(&:last))
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[A toString], renamed("class A { toString() { return '' } }")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map(&:first).uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], TypeScript::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if TypeScript::Representation::Spec.name?(node) }
    leaves
  end
end
