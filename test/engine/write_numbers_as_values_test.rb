require_relative "toy_language"

class WriteNumbersAsValuesTest < Minitest::Test
  include ToyLanguage::Trees

  def test_writes_integers_and_decimals_as_their_values
    tree = node(:program, leaf("1_000", :int), leaf("0x1F", :int), leaf("1.50", :float), leaf("1.50", :int))
    assert_equal "(program 1000 31 1.5 1.50)", write(tree, integer: %w[int], decimal: %w[float])
  end

  def test_reads_the_prefixes_given
    tree = node(:program, leaf("017", :int), leaf("0d10", :int))
    assert_equal "(program 15 10)", write(tree, integer: %w[int], prefixes: { "0d" => 10, "0" => 8 })
  end

  def test_keeps_a_decimal_suffix_in_lower_case
    tree = node(:program, leaf("1E7F", :real), leaf("1f", :real), leaf("1.50m", :real))
    assert_equal "(program 10000000.0f 1.0f 1.50m)", write(tree, decimal: %w[real], suffixes: %w[f d])
  end

  def test_keeps_text_that_no_reader_understands
    tree = node(:program, leaf("10L", :int))
    assert_equal "(program 10L)", write(tree, integer: %w[int])
  end

  private
  def write(tree, **numbers) = Representer::Engine::Serialize.(Representer::Engine::WriteNumbersAsValues.(tree, **numbers))
end
