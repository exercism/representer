require "test_helper"

# Runs Common Lisp's stages by hand, for the tests of each stage.
module CommonLispStages
  CommonLisp = Representer::Languages::CommonLisp

  def parse(source)
    Representer::Engine::Grammar["common_lisp"].parse(Representer::Engine.clean(source), **CommonLisp::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = CommonLisp::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(CommonLisp::Common::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
