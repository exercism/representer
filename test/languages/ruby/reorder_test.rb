require_relative "stage_helper"

class RubyReorderTest < Minitest::Test
  include RubyStages

  def test_keeps_the_order
    source = "def b = 2\ndef a = 1\nattr_reader :y, :x"
    assert_equal write(normalise(source)), write(Ruby::Reorder.(normalise(source)))
  end
end
