class SimpleCalculator
  class UnsupportedOperation < StandardError; end
  ALLOWED_OPERATIONS = ['+', '/', '*'].freeze

  def self.calculate(first_operand, second_operand, operation)
    raise UnsupportedOperation unless ALLOWED_OPERATIONS.include?(operation)
    raise ArgumentError unless [first_operand, second_operand].all? { _1.is_a?(Numeric) }

    begin
      "#{[first_operand, operation, second_operand].join(' ')} = #{first_operand.public_send(operation, second_operand)}"
    rescue ZeroDivisionError
      "Division by zero is not allowed."
    end
  end
end
