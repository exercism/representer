require_relative "stage_helper"

# Tests Ruby's Normalise stage, which marks each method with its visibility.
class RubyNormaliseTest < Minitest::Test
  include RubyStages

  def test_a_visibility_line_marks_each_method_and_attribute_after_it
    assert_includes tree("class A\n  def a; end\n  private\n  def b; end\nend"), "(method a)\n      (method b private)"
    assert_includes tree("class A\n  private\n  attr_reader :x\nend"), "(argument_list :x) private)"
    refute_includes tree("class A\n  private\nend"), "private"
  end

  def test_a_mark_lasts_until_the_next_visibility_line
    assert_equal tree("class A\n  def a; end\n  protected\n  def b; end\n  public\n  def c; end\nend"),
      tree("class A\n  def a; end\n  protected def b; end\n  public def c; end\nend")
  end

  def test_a_visibility_before_def_marks_the_method
    %w[private protected public].each do |visibility|
      assert_equal tree("class A\n  #{visibility}\n  def a(x) = x\nend"), tree("class A\n  #{visibility} def a(x) = x\nend")
    end
  end

  def test_private_with_a_symbol_stays_a_call
    assert_includes tree("class A\n  def a; end\n  private :a\nend"), "(call private"
  end

  def test_code_other_than_methods_and_attributes_gets_no_mark
    assert_includes tree("class A\n  private\n  X = 1\nend"), "(assignment X 1)"
  end

  private
  def tree(source) = write(prepare(source))
end
