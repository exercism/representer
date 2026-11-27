require_relative "stage_helper"

# Tests the analysis's Normalise stage, which writes every method that a
# class or module defines on itself as `def self.name`.
class RubyAnalysisNormaliseTest < Minitest::Test
  include RubyStages

  def test_a_method_on_the_class_name_is_a_method_on_self
    assert_equal tree("class A\n  def self.f = 1\nend"), tree("class A\n  def A.f = 1\nend")
    assert_includes tree("class A\n  def B.f = 1\nend"), "(singleton_method B f"
  end

  def test_a_method_in_class_self_is_a_method_on_self
    assert_equal tree("class A\n  def self.f = 1\nend"), tree("class A\n  class << self\n    def f = 1\n  end\nend")
    assert_includes tree("class A\n  class << self\n    attr_reader :x\n    def f = 1\n  end\nend"), "(singleton_class self"
  end

  def test_a_module_function_is_a_method_on_self
    assert_equal tree("module A\n  def self.f = 1\nend"), tree("module A\n  module_function\n  def f = 1\nend")
    assert_includes tree("module A\n  def f = 1\n  module_function :f\nend"), "(singleton_method self f"
    assert_includes tree("module A\n  def f = 1\nend"), "(method f"
  end

  private
  def tree(source) = write(Ruby::Analysis::Normalise.(Ruby::Common::Normalise.(generate_ast(source))))
end
