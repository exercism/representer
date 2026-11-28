require_relative "stage_helper"

# Checks Swift's declarations of which nodes are names and which nodes define
# them (see swift/representation.rb), through the engine's renaming.
class SwiftNamesTest < Minitest::Test
  include SwiftStages

  def test_renames_types_and_their_parameters
    source = "struct S<T> { }\nclass C { }\nenum E { }\nprotocol P { associatedtype A }\ntypealias G = [Int]\n" \
             "extension Array { }"
    assert_equal %w[A C E G P S T], renamed(source)
  end

  def test_renames_functions_properties_enum_cases_and_labels
    source = "struct S { var x = 1; let y: Int; func area() -> Int { x } }\n" \
             "protocol P { func size() -> Int; var count: Int { get } }\n" \
             "enum E { case red, green; case circle(radius: Double) }\n" \
             "let t: (name: String, score: Int) = (name: \"a\", score: 1)"
    assert_equal %w[E P S area circle count green name radius red score size t x y], renamed(source)
  end

  def test_renames_parameters_their_labels_and_locals
    source = in_function("let a = x; var b = a\nlet c = { d, e in d + e }\n" \
                         "let g = { [h = a] in h }\nouter: for i in 0..<x { break outer }\nreturn b")
    assert_equal %w[a b c d e f g h i outer x], renamed(source)
    assert_equal %w[by f n step], renamed("func f(by step: Int, _ n: Int) { }")
  end

  def test_renames_the_variables_that_patterns_and_conditions_bind
    source = in_function("if let a = g() { }\nguard let b = g() else { return 0 }\nwhile let c = g() { }\n" \
                         "for (d, e) in g() { }\nlet (h, i) = (1, 2)\n" \
                         "switch x { case let (j, k): break; case .some(let l): break; case let .some(m): break; " \
                         "case n: break; default: break }\n" \
                         "do { } catch let o { }\nreturn 0")
    assert_equal %w[a b c d e f h i j k l m o x], renamed(source)
  end

  def test_keeps_names_the_solution_does_not_define
    source = "import Foundation\nfunc f(_ s: String) -> Bool { s.uppercased() == s && s.contains { $0.isLetter } }"
    assert_equal %w[f s], renamed(source)
  end

  def test_keeps_the_wildcard
    assert_equal %w[a f x], renamed(in_function("for _ in 0..<x { }\n_ = x\nlet a = { _ in 1 }\nreturn x"))
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Rosetta::Engine::RenameUserDefinedNodes.([tree], Swift::Representation::Spec)
    leaves = []
    tree.each_descendant { |node| leaves << node.text if Swift::Representation::Spec.name?(node) && node.renamed }
    leaves.uniq.sort
  end
end
