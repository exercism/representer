require "test_helper"

# Runs Tcl's stages by hand, for the tests of each stage.
module TclStages
  Tcl = Inspector::Languages::Tcl

  def parse(source)
    Inspector::Engine::Grammar["tcl"].parse(Inspector::Engine.clean(source), **Tcl::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Tcl::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Tcl::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)
end
