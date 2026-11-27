module Representer::Engine
  # Reads number literals, so that a language's rules can write every
  # number in one canonical form (see Language.numbers). `1_000` and
  # `1000`, `0x10` and `16`, and `0.90` and `0.9` are the same number.
  #
  # Each reader returns nil for text it doesn't understand, and the rule
  # then keeps the text as it is. So a spelling these readers don't know
  # can never merge with a different number.
  module Numbers
    PREFIXES = { "0x" => 16, "0o" => 8, "0b" => 2 }.freeze
    DIGITS = { 2 => /\A[01]+\z/, 8 => /\A[0-7]+\z/, 10 => /\A\d+\z/, 16 => /\A\h+\z/ }.freeze

    # `1e400` is written out as a 1 and 400 zeros. A larger exponent keeps its
    # own text, so a huge number can't use up the memory.
    MAX_EXPONENT = 400

    # An integer literal's value, or nil. separator is the digit separator
    # (such as "_" or "'"), and prefixes maps each base prefix to its base.
    def self.integer(text, separator: "_", prefixes: PREFIXES)
      sign, digits = split_sign(text.delete(separator))
      base = 10
      prefixes.each do |prefix, prefix_base|
        next unless digits.downcase.start_with?(prefix.downcase)

        base = prefix_base
        digits = digits[prefix.size..]
        break
      end
      return nil unless digits.match?(DIGITS.fetch(base))

      value = digits.to_i(base)
      sign == "-" ? -value : value
    end

    # A decimal literal's exact value, as a Rational, or nil. It reads
    # `1.5`, `.5`, `1.`, `1.5e3` and `15E-1`, with digit separators.
    def self.decimal(text, separator: "_")
      sign, rest = split_sign(text.delete(separator))
      match = rest.match(/\A(\d*)(?:\.(\d*))?(?:[eE]([-+]?\d+))?\z/)
      return nil unless match

      whole, fraction, exponent = match.captures
      return nil if "#{whole}#{fraction}".empty? || exponent.to_i.abs > MAX_EXPONENT

      fraction = fraction.to_s
      value = Rational("#{whole.empty? ? 0 : whole}#{fraction}".to_i, 10**fraction.size) * (Rational(10)**exponent.to_i)
      sign == "-" ? -value : value
    end

    # Writes a decimal value with at least one digit after the point, such
    # as `31557600.0` or `0.25`.
    def self.write_decimal(value)
      sign = value.negative? ? "-" : ""
      value = value.abs
      whole = value.floor
      fraction = value - whole
      digits = +""
      until fraction.zero?
        fraction *= 10
        digits << fraction.floor.to_s
        fraction -= fraction.floor
      end
      "#{sign}#{whole}.#{digits.empty? ? '0' : digits}"
    end

    # Writes a value that the language stores the same way whether it is
    # written as an integer or a decimal (as JavaScript does): an integer
    # without a point, and anything else as a decimal.
    def self.write_number(value) = value.denominator == 1 ? value.to_i.to_s : write_decimal(value)

    def self.split_sign(text)
      sign = text[/\A[-+]/]
      [sign, sign ? text[1..] : text]
    end
  end
end
