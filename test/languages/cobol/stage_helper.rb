require "test_helper"

# Runs COBOL's stages by hand, for the tests of each stage.
module CobolStages
  Cobol = Inspector::Languages::Cobol

  def parse(source)
    Inspector::Engine::Grammar["cobol"].parse(Inspector::Engine.clean(source), **Cobol::Common::Spec.parse_options)
  end

  # GenerateAST's tree for the source.
  def generate_ast(source) = Cobol::Common::GenerateAST.(parse(source))

  # The tree after GenerateAST and the engine's dropping of comments and
  # imports (see Engine::PrepareFile).
  def prepare(source) = Inspector::Engine::PrepareFile.(Cobol::Common::Spec, source)

  def write(tree) = Inspector::Engine::Serialize.(tree)

  # A program with these lines in its PROCEDURE DIVISION, or in its DATA
  # DIVISION, written from the eighth column, as COBOL's fixed format needs.
  def program(statements = "", data: "")
    lines = ["IDENTIFICATION DIVISION.", "PROGRAM-ID. P.", "DATA DIVISION.", "WORKING-STORAGE SECTION.",
             *data.lines, "PROCEDURE DIVISION.", *statements.lines]
    lines.map { |line| "       #{line.chomp}\n" }.join
  end
end
