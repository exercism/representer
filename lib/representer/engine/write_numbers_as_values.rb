module Representer::Engine
  # Writes each number leaf as its value, with the readers in Numbers (see
  # GenerateAST.numbers_are), so `1_000` and `1000` become the same leaf.
  #
  # - An integer of the integer types becomes its value, such as `31` for
  #   `0x1F`. prefixes maps each base prefix to its base.
  # - A decimal of the decimal types becomes its value with at least one
  #   digit after the point, such as `1.5` for `1.50`. If it ends with one
  #   of the suffixes, the suffix stays, in lower case.
  #
  # A number that a reader doesn't understand keeps its text, so it can
  # never merge with a different number.
  class WriteNumbersAsValues
    include Mandate

    initialize_with :tree, integer: [], decimal: [], prefixes: Numbers::PREFIXES, suffixes: []

    def call
      return tree if integer.empty? && decimal.empty?

      tree.each_descendant do |node|
        next unless node.named? && node.leaf?

        text = value(node)
        node.text = text if text
      end
      tree
    end

    private
    def value(node)
      return Numbers.integer(node.text, prefixes:)&.to_s if integer.include?(node.type)

      decimal_value(node.text) if decimal.include?(node.type)
    end

    def decimal_value(text)
      suffix = suffixes.find { |candidate| text.downcase.end_with?(candidate.downcase) }
      value = Numbers.decimal(suffix ? text[0...-suffix.size] : text)
      value && "#{Numbers.write_decimal(value)}#{suffix&.downcase}"
    end
  end
end
