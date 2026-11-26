require_relative "stage_helper"

class RubyRenameTest < Minitest::Test
  include RubyStages

  def test_renames_locals_and_parameters
    source = "def f(a, b = 1, *c, d:, **e, &g)\n  h = a\n  i, *j = c\n  xs.each { |k, (l, m); n| k }\n  ->(o) { o }\n  " \
             "for p in xs do p end\n  begin\n  rescue => q\n  end\n  r += 1\nend"
    assert_equal %w[a b c e f g h i j k l m n o p q r], renamed(source)
  end

  def test_keeps_keyword_parameters
    refute_includes renamed("def f(layers:) = layers"), "layers"
  end

  def test_renames_instance_and_class_variables
    assert_equal %w[@@b @a], renamed("@a = @@b")
  end

  def test_renames_only_the_globals_the_solution_assigns
    assert_equal %w[$count x], renamed("$count = 1\nx = $stdout")
    assert_equal %w[$a $b], renamed("$a, $b = 1, 2")
  end

  def test_renames_instance_methods_classes_modules_and_attributes
    source = "module M\n  class C < Base\n    attr_reader :r\n    attr_writer :w\n    attr_accessor :a\n" \
             "    def helper = 1\n  end\nend\nclass A::B\nend"
    assert_equal %w[B C M a helper r w], renamed(source)
  end

  def test_keeps_singleton_methods_and_constants
    assert_empty renamed("class A\n  LIMIT = 1\n  def self.helper = LIMIT\nend") - %w[A]
  end

  def test_keeps_methods_named_after_library_methods
    assert_empty renamed("def sum = 1\ndef initialize = 1\ndef to_s = 'x'")
    assert_equal %w[sum], renamed("sum = 0")
  end

  def test_renames_a_name_after_a_dot_only_if_the_solution_defines_it
    assert_equal %w[count], renamed("count = xs.count")
    assert_equal [[:count, false]], marks("count = xs.count").select { |name, _| name == :count }.drop(1)
    assert_equal %w[helper x], renamed("def helper = 1\nx = self.helper")
    assert_equal [true, true], marks("def helper = 1\nx = self.helper").select { |name, _| name == :helper }.map(&:last)
  end

  def test_renames_a_symbol_only_if_the_solution_defines_the_method
    assert_equal([[:":count", false]], marks("count = 0\nxs.map(&:count)").select { |name, _| name == :":count" })
    assert_equal([[:":double", true]], marks("def double = 1\nxs.map(&:double)").select { |name, _| name == :":double" })
  end

  def test_keeps_the_names_it_is_given
    assert_equal %w[b], renamed("def f(a) = b = a", kept: Set["a", "f"])
  end

  def test_returns_the_members_the_trees_define
    tree = normalise("class A\n  attr_reader :r\n  def m = 1\n  def self.s = 1\nend")
    assert_equal Set["A", "r", "m"], Ruby::Rename.([tree], Set.new)
  end

  private
  # The names that Rename marks as the student's, sorted.
  def renamed(source, kept: Set.new) = marks(source, kept:).select(&:last).map { |name, _| name.to_s.delete_prefix(":") }.uniq.sort

  # Each name leaf's text, and whether Rename marked it, in source order.
  def marks(source, kept: Set.new)
    tree = normalise(source)
    Ruby::Rename.([tree], kept)
    leaves = []
    Representer::Engine::Names.each_name(Ruby, tree) { |leaf, _| leaves << [leaf.text.to_sym, leaf.renamed] }
    leaves
  end
end
