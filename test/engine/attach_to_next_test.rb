require_relative "toy_language"

class AttachToNextTest < Minitest::Test
  include ToyLanguage::Trees

  def test_moves_each_match_into_the_next_statement
    tree = node(:body, node(:spec, leaf("a")), node(:def, leaf("a")), node(:def, leaf("b")))
    assert_equal "(body\n  (def a\n    (spec a))\n  (def b))", attach(tree)
  end

  def test_moves_several_matches_in_their_order
    tree = node(:body, node(:spec, leaf("1")), node(:spec, leaf("2")), node(:def, leaf("a")))
    assert_equal "(body\n  (def a\n    (spec 1)\n    (spec 2)))", attach(tree)
  end

  def test_leaves_a_match_with_nothing_after_it_or_a_leaf_after_it
    tree = node(:body, node(:def, leaf("a")), node(:spec, leaf("1")))
    assert_equal "(body\n  (def a)\n  (spec 1))", attach(tree)
    tree = node(:body, node(:spec, leaf("1")), leaf("x"))
    assert_equal "(body\n  (spec 1) x)", attach(tree)
  end

  def test_works_in_every_node
    tree = node(:program, node(:module, node(:spec, leaf("1")), node(:def, leaf("a"))))
    assert_equal "(program\n  (module\n    (def a\n      (spec 1))))", attach(tree)
  end

  def test_moves_past_the_statements_given_in_past
    tree = node(:body, node(:spec, leaf("1")), node(:doc, leaf("d")), node(:def, leaf("a")))
    assert_equal "(body\n  (doc d)\n  (def a\n    (spec 1)))", attach(tree, past: ["(doc)"])
  end

  private
  def attach(tree, past: []) = Inspector::Engine::Serialize.(Inspector::Engine::AttachToNext.(tree, ["(spec)"], past:))
end
