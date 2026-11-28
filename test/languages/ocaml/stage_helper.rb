require "test_helper"

# Runs OCaml's stages by hand, for the tests of each stage.
module OCamlStages
  OCaml = Rosetta::Languages::OCaml

  def parse(source)
    Rosetta::Engine::Grammar["ocaml"].parse(Rosetta::Engine.clean(source), **OCaml::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = OCaml::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Rosetta::Engine::PrepareFile.(OCaml::Common::Spec, source)

  def write(tree) = Rosetta::Engine::Serialize.(tree)
end
