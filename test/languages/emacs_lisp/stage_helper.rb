require "test_helper"

# Runs Emacs Lisp's stages by hand, for the tests of each stage.
module EmacsLispStages
  EmacsLisp = Inspector::Languages::EmacsLisp

  def parse(source)
    Inspector::Engine::Grammar["elisp"].parse(Inspector::Engine.clean(source), **EmacsLisp::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = EmacsLisp::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(EmacsLisp::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
