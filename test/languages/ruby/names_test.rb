require_relative "stage_helper"

# Checks Ruby's declarations of which nodes are names and which nodes define
# them (see ruby/spec.rb), through the engine's renaming.
class RubyNamesTest < Minitest::Test
  include RubyStages

  def test_renames_locals_and_every_kind_of_parameter
    source = "def f(a, b = 1, *c, d:, **e, &g)\n  h = a\n  i, *j = c\n  xs.each { |k, (l, m); n| k }\n  ->(o) { o }\n  " \
             "for p in xs do p end\n  begin\n  rescue => q\n  end\n  r += 1\nend"
    assert_equal %w[a b c d e f g h i j k l m n o p q r], renamed(source)
  end

  def test_renames_instance_class_and_global_variables_and_constants
    assert_equal %w[$c @@b @a D], renamed("@a = @@b = $c = D = 1")
  end

  def test_renames_methods_classes_and_modules
    assert_equal %w[C M helper other], renamed("module M\n  class C < Base\n    def helper = 1\n    def self.other = 1\n  end\nend")
  end

  def test_renames_every_use_of_a_defined_name
    assert_equal [true, true, true], marks("def go = 1\nself.go\nxs.map(&:go)").select { |text, _| text.end_with?("go") }.map(&:last)
  end

  def test_keeps_names_the_solution_does_not_define
    assert_equal %w[x], renamed("x = $stdout.puts(Base.new.count)")
  end

  def test_renames_library_names_the_solution_defines
    assert_equal %w[count initialize sum], renamed("def sum = 1\ndef initialize = 1\ncount = 0").sort
  end

  private
  # The names that the engine renames, sorted.
  def renamed(source) = marks(source).select(&:last).map { |text, _| text.delete_prefix(":") }.uniq.sort

  # Each name leaf's text, and whether the engine renames it, in source order.
  def marks(source)
    tree = prepare(source)
    Representer::Engine::RenameUserDefinedNodes.([tree], Ruby::Representation)
    leaves = []
    tree.each_descendant { |node| leaves << [node.text, node.renamed] if Ruby::Representation.name?(node) }
    leaves
  end
end
