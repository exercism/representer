require_relative "stage_helper"

# Checks Nim's declarations of which nodes are names and which nodes define
# them (see nim/representation.rb), through the engine's renaming.
class NimNamesTest < Minitest::Test
  include NimStages

  def test_renames_types_fields_and_enum_values
    source = "type\n  Dollar* = object\n    amount*, cents: int\n  Color = enum red, green = 2\n"
    assert_equal %w[Color Dollar amount cents green red], renamed(source)
  end

  def test_renames_routines
    source = "proc a*() = discard\nfunc b() = discard\nmethod c(x: int) = discard\niterator d(): int = yield 1\n" \
             "template e() = discard\nmacro g() = discard\nconverter h(x: int): bool = true\n"
    assert_equal %w[a b c d e g h x], renamed(source)
  end

  def test_renames_parameters_and_generic_parameters
    assert_equal %w[T a b f], renamed("proc f[T](a, b: T): T = a")
  end

  def test_renames_variables_and_loop_variables
    source = "let a = 1\nvar b = a\nconst c = 2\nlet (d, e) = (1, 2)\nfor i, j in pairs(s): echo i\n"
    assert_equal %w[a b c d e i j], renamed(source)
  end

  def test_renames_names_in_fmt_strings
    assert_equal %w[f name], renamed("proc f(name: string): string = fmt\"hi {name} {other}\"")
  end

  def test_renames_every_spelling_of_a_name_as_one
    assert_equal ["helloworld"], renamed("proc helloWorld() = discard\nhello_world()")
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[f s], renamed("proc f(s: string): int = s.toUpper.len + result")
  end

  def test_keeps_operators_the_solution_defines
    assert_equal %w[a b], renamed("proc `+`(a, b: int): int = a")
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Nim::Representation)
    names = []
    tree.each_descendant { |node| names << Nim::Representation.name_text(node) if node.renamed }
    names.uniq.sort
  end
end
