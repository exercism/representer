require "test_helper"

# Runs Ruby's stages by hand, for the tests of each stage.
module RubyStages
  Ruby = Representer::Languages::Ruby

  # GenerateAST's tree for the source.
  def generate_ast(source) = Ruby::Common::GenerateAST.(Representer::Engine::Grammar["ruby"].parse(Representer::Engine.clean(source)))

  # The tree after GenerateAST and the engine's dropping of imports (see
  # Engine::PrepareFile).
  def prepare(source) = Representer::Engine::PrepareFile.(Ruby::Spec, source)

  def write(tree) = Representer::Engine::Serialize.(tree)
end

# Runs Ruby's analysis for an exercise, for the tests of its rules.
module RubyAnalysis
  # Each comment as its key, with its params if it has any.
  def comments(slug, source)
    analysis = Representer::Generate.("ruby", { "solution.rb" => source }, outputs: %i[analysis], exercise_slug: slug)[:analysis]
    analysis.fetch(:comments).map { |comment| comment[:params] ? [comment[:comment], comment[:params]] : comment[:comment] }
  end
end
