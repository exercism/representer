require "test_helper"

# Runs OCaml's stages by hand, for the tests of each stage.
module OCamlStages
  OCaml = Representer::Languages::OCaml

  def parse(source)
    Representer::Engine::Grammar["ocaml"].parse(Representer::Engine.clean(source), **OCaml::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = OCaml::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(OCaml::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end
