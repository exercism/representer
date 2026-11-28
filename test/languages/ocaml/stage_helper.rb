require "test_helper"

# Runs OCaml's stages by hand, for the tests of each stage.
module OCamlStages
  OCaml = Inspector::Languages::OCaml

  def parse(source)
    Inspector::Engine::Grammar["ocaml"].parse(Inspector::Engine.clean(source), **OCaml::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = OCaml::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(OCaml::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
