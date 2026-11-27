require "test_helper"

# Checks AddBraces with C#'s grammar and GenerateAST stage.
class AddBracesTest < Minitest::Test
  CSharp = Representer::Languages::CSharp

  def test_wraps_a_body_without_braces_in_a_block
    assert_equal write(tree("if (a) { b(); }")), add_braces("if (a) b();", "if ({{...}}) { }")
  end

  def test_leaves_a_block_alone
    assert_equal write(tree("if (a) { b(); }")), add_braces("if (a) { b(); }", "if ({{...}}) { }")
  end

  def test_uses_the_last_empty_braces
    assert_equal write(tree("if (a) b(); else { c(); }")), add_braces("if (a) b(); else c();", "if ({{...}}) { } else { }")
  end

  private
  def add_braces(source, braced)
    pattern = Representer::Engine::CodePattern[CSharp::Spec, braced]
    write(Representer::Engine::AddBraces.(tree(source), pattern))
  end

  def tree(source) = CSharp::Common::GenerateAST.(Representer::Engine::Grammar["c_sharp"].parse(source))
  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
