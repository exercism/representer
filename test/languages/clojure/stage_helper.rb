require "test_helper"

# Runs Clojure's stages by hand, for the tests of each stage.
module ClojureStages
  Clojure = Representer::Languages::Clojure

  def parse(source)
    Representer::Engine::Grammar["clojure"].parse(Representer::Engine.clean(source), **Clojure::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Clojure::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Clojure::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree, nil)
end
