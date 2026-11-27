require_relative "toy_language"

class JoinFilesTest < Minitest::Test
  include ToyLanguage::Trees

  def test_orders_the_files_by_their_code_with_renamed_names_left_blank
    first = node(:program, node(:def, renamed(leaf("a"))), leaf("z"))
    second = node(:program, node(:def, renamed(leaf("b"))), leaf("y"))
    assert_equal "(program\n  (def b) y\n  (def a) z)", join([first, second])
    assert_equal "(program\n  (def b) y\n  (def a) z)", join([second, first])
  end

  def test_breaks_a_tie_with_the_names_as_written
    first = node(:program, node(:def, renamed(leaf("b"))))
    second = node(:program, node(:def, renamed(leaf("a"))))
    assert_equal "(program\n  (def a)\n  (def b))", join([first, second])
  end

  def test_a_file_with_another_root_joins_as_one_child
    assert_equal "(program\n  (class y) x)", join([node(:program, leaf("x")), node(:class, leaf("y"))])
  end

  private
  def renamed(leaf) = leaf.tap { leaf.renamed = true }
  def join(trees) = Representer::Engine::Serialize.(Representer::Engine::JoinFiles.(trees, "program", nil), nil)
end
