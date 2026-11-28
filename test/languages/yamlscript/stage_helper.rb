require "test_helper"

# Runs YAMLScript's stages by hand, for the tests of each stage.
module YAMLScriptStages
  YAMLScript = Inspector::Languages::YAMLScript

  def parse(source)
    Inspector::Engine::Grammar["yamlscript"].parse(Inspector::Engine.clean(source),
                                                   **YAMLScript::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the code, in a file that starts with `!YS-v0`.
  def generate_ast(code) = YAMLScript::Common::GenerateAST.(parse("!YS-v0\n#{code}\n"))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(code) = Inspector::Engine::PrepareFile.(YAMLScript::Common::Spec, "!YS-v0\n#{code}\n")

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
