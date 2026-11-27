module Representer::Engine
  # Writes each number leaf as its value, with the readers in Numbers (see
  # GenerateAST.numbers_are), so `1_000` and `1000` become the same leaf.
  #
  # - An integer of the integer types becomes its value, such as `31` for
  #   `0x1F`. prefixes maps each base prefix to its base.
  # - A decimal of the decimal types becomes its value with at least one
  #   digit after the point, such as `1.5` for `1.50`. If it ends with one
  #   of the suffixes, the suffix stays, in lower case.
  # - If a type is both, the leaf becomes an integer if the integer reader
  #   can read it, and a decimal otherwise, as in Clojure.
  # - A number of the number types becomes its value, and a whole value has
  #   no point, because the language stores every number the same way, as
  #   JavaScript does. So `1.0` and `1` become `1`.
  #
  # separators lists the characters that may separate digits, such as `_`.
  #
  # A number that a reader doesn't understand keeps its text, so it can
  # never merge with a different number.
  class WriteNumbersAsValues
    include Mandate

    initialize_with :tree, integer: [], decimal: [], number: [], prefixes: Numbers::PREFIXES, suffixes: [],
                           separators: ["_"]

    def call
      return tree if integer.empty? && decimal.empty? && number.empty?

      tree.each_descendant do |node|
        next unless node.named? && node.leaf?

        text = value(node)
        node.text = text if text
      end
      tree
    end

    private
    def value(node)
      return number_value(node.text) if number.include?(node.type)

      value = integer_value(node.text) if integer.include?(node.type)
      value || (decimal_value(node.text) if decimal.include?(node.type))
    end

    def integer_value(text) = Numbers.integer(text, separator:, prefixes:)&.to_s

    def decimal_value(text)
      suffix = suffixes.find { |candidate| text.downcase.end_with?(candidate.downcase) }
      value = Numbers.decimal(suffix ? text[0...-suffix.size] : text, separator:)
      value && "#{Numbers.write_decimal(value)}#{suffix&.downcase}"
    end

    def number_value(text)
      value = Numbers.integer(text, separator:, prefixes:) || Numbers.decimal(text, separator:)
      value && Numbers.write_number(value.to_r)
    end

    def separator = separators.join
  end
end
