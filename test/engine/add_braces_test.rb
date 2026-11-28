require "test_helper"

# Checks AddBraces with C#'s grammar and GenerateAST stage.
class AddBracesTest < Minitest::Test
  CSharp = Inspector::Languages::CSharp

  def test_wraps_a_body_without_braces_in_a_block
    assert_equal write(tree("if (a) { b(); }")), add_braces("if (a) b();", "if ({{...}}) { }")
  end

  def test_leaves_a_block_alone
    assert_equal write(tree("if (a) { b(); }")), add_braces("if (a) { b(); }", "if ({{...}}) { }")
  end

  def test_uses_the_last_empty_braces
    assert_equal write(tree("if (a) b(); else { c(); }")), add_braces("if (a) b(); else c();", "if ({{...}}) { } else { }")
  end

  def test_a_block_type_given_finds_the_body_by_its_placeholder
    assert_equal write(tree("if (a) b(); else { c(); }")),
      add_braces("if (a) b(); else c();", "if ({{...}}) { } else {{body}}();", block: :block)
  end

  private
  def add_braces(source, braced, block: nil)
    pattern = Inspector::Engine::CodePattern[CSharp::Common::Spec, braced]
    write(Inspector::Engine::AddBraces.(tree(source), pattern, block:))
  end

  def tree(source) = CSharp::Common::GenerateAST.(Inspector::Engine::Grammar["c_sharp"].parse(source))
  def write(tree) = Inspector::Engine::Serialize.(tree)
end
