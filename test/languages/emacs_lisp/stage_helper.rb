require "test_helper"

# Runs Emacs Lisp's stages by hand, for the tests of each stage.
module EmacsLispStages
  EmacsLisp = Representer::Languages::EmacsLisp

  def parse(source)
    Representer::Engine::Grammar["elisp"].parse(Representer::Engine.clean(source), **EmacsLisp::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = EmacsLisp::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(EmacsLisp::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
