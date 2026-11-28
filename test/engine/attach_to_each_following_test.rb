require_relative "toy_language"

class AttachToEachFollowingTest < Minitest::Test
  include ToyLanguage::Trees

  def test_marks_each_definition_after_the_line_until_the_next_line
    tree = node(:body, node(:def, leaf("a")), leaf("private"), node(:def, leaf("b")), leaf("public"), node(:def, leaf("c")))
    assert_equal "(body\n  (def a)\n  (def b private)\n  (def c public))", mark(tree)
  end

  def test_marks_only_definitions
    tree = node(:body, leaf("private"), node(:assignment, leaf("x"), leaf("1")), node(:def, leaf("b")))
    assert_equal "(body\n  (assignment x 1)\n  (def b private))", mark(tree)
  end

  def test_a_mark_ends_with_its_node
    tree = node(:program, node(:class, leaf("private"), node(:def, leaf("a"))), node(:def, leaf("b")))
    assert_equal "(program\n  (class\n    (def a private))\n  (def b))", mark(tree)
  end

  def test_a_line_has_no_field_name
    tree = node(:body, node(:call, leaf("private").tap { |name| name.field = "method" }, node(:def, leaf("a"))))
    assert_equal "(body\n  (call private\n    (def a)))", mark(tree)
  end

  def test_each_definition_gets_its_own_copy
    tree = node(:body, leaf("private"), node(:def, leaf("a")), node(:def, leaf("b")))
    result = Inspector::Engine::AttachToEachFollowing.(tree, LINES, ["(def)"])
    refute_same result.children[0].children.last, result.children[1].children.last
  end

  private
  LINES = ['(identifier /\A(private|public)\z/)'].freeze

  def mark(tree)
    Inspector::Engine::Serialize.(Inspector::Engine::AttachToEachFollowing.(tree, LINES, ["(def)"]))
  end
end
