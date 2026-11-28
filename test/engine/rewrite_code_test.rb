require "test_helper"

# Checks RewriteCode with Ruby's grammar and GenerateAST stage.
class RewriteCodeTest < Minitest::Test
  CodePattern = Rosetta::Engine::CodePattern
  Ruby = Rosetta::Languages::Ruby

  def test_rewrites_every_match
    assert_equal write(tree("n = xs.size")), rewrite("n = xs.length", "{{list}}.length", "{{list}}.size")
  end

  def test_rewrites_only_inside_a_scope_with_the_same_code
    source = "class A\n  def f = A.b + C.b\nend\nx = A.b"
    expected = "class A\n  def f = b + C.b\nend\nx = A.b"
    assert_equal write(tree(expected)), rewrite(source, "{{type}}.{{name}}", "{{name}}", scopes: ["class {{type}}\n{{...}}\nend"])
  end

  private
  def rewrite(source, code, replacement, scopes: [])
    patterns = [code, replacement, *scopes].map { |text| CodePattern[Ruby::Common::Spec, text] }
    write(Rosetta::Engine::RewriteCode.(tree(source), patterns[0], patterns[1], scopes: patterns[2..]))
  end

  def tree(source) = Ruby::Common::GenerateAST.(Rosetta::Engine::Grammar["ruby"].parse(source))
  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
