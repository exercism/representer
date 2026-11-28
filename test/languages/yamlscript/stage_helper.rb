require "test_helper"

# Runs YAMLScript's stages by hand, for the tests of each stage.
module YAMLScriptStages
  YAMLScript = Rosetta::Languages::YAMLScript

  def parse(source)
    Rosetta::Engine::Grammar["yamlscript"].parse(Rosetta::Engine.clean(source),
                                                   **YAMLScript::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the code, in a file that starts with `!YS-v0`.
  def generate_ast(code) = YAMLScript::Common::GenerateAST.(parse("!YS-v0\n#{code}\n"))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(code) = Rosetta::Engine::PrepareFile.(YAMLScript::Common::Spec, "!YS-v0\n#{code}\n")

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
