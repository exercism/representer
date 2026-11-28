require "test_helper"

class NumbersTest < Minitest::Test
  Numbers = Rosetta::Engine::Numbers

  def test_integers
    assert_equal 1000, Numbers.integer("1_000")
    assert_equal 31, Numbers.integer("0x1F")
    assert_equal 15, Numbers.integer("0o17")
    assert_equal 5, Numbers.integer("0b101")
    assert_equal(-7, Numbers.integer("-7"))
    assert_equal 1000, Numbers.integer("1'000", separator: "'")
    assert_nil Numbers.integer("0x1F", prefixes: {})
    assert_equal 0, Numbers.integer("0", prefixes: { "0" => 8 })
    assert_nil Numbers.integer("0x")
    assert_nil Numbers.integer("1.5")
    assert_nil Numbers.integer("12abc")
  end

  def test_decimals
    assert_equal Rational(3, 2), Numbers.decimal("1.50")
    assert_equal Rational(1, 2), Numbers.decimal(".5")
    assert_equal 1000, Numbers.decimal("1e3")
    assert_equal 31_557_600, Numbers.decimal("31_557_600.0")
    assert_nil Numbers.decimal("1.5f")
    assert_nil Numbers.decimal("1e999")
  end

  def test_writing
    assert_equal "1.5", Numbers.write_decimal(Rational(3, 2))
    assert_equal "1000.0", Numbers.write_decimal(Rational(1000))
    assert_equal "-0.25", Numbers.write_decimal(Rational(-1, 4))
    assert_equal "1", Numbers.write_number(Rational(1))
    assert_equal "0.5", Numbers.write_number(Rational(1, 2))
  end
end
