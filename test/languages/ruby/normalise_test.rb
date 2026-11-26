require_relative "stage_helper"

class RubyNormaliseTest < Minitest::Test
  include RubyStages

  def test_drops_requires
    assert_equal write(normalise("x = 1")), write(normalise("require 'set'\nrequire_relative \"helper\"\nx = 1"))
  end

  def test_keeps_other_calls
    refute_equal write(normalise("x = 1")), write(normalise("load 'x.rb'\nx = 1"))
    refute_equal write(normalise("x = 1")), write(normalise("require name\nx = 1"))
    refute_equal write(normalise("x = 1")), write(normalise("Kernel.require 'set'\nx = 1"))
  end
end
