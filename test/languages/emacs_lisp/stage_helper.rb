require "test_helper"

# Runs Emacs Lisp's stages by hand, for the tests of each stage.
module EmacsLispStages
  EmacsLisp = Rosetta::Languages::EmacsLisp

  def parse(source)
    Rosetta::Engine::Grammar["elisp"].parse(Rosetta::Engine.clean(source), **EmacsLisp::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = EmacsLisp::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(EmacsLisp::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
