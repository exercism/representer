require "test_helper"

# Runs Clojure's stages by hand, for the tests of each stage.
module ClojureStages
  Clojure = Inspector::Languages::Clojure

  def parse(source)
    Inspector::Engine::Grammar["clojure"].parse(Inspector::Engine.clean(source), **Clojure::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Clojure::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST, the engine's dropping of imports and
  # Normalise (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Clojure::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
