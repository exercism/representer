class SimpleCalculator
  ALLOWED_OPERATIONS = ['+', '/', '*'].freeze

  class UnsupportedOperation < ::StandardError
  end

  def self.calculate(first_operand, second_operand, operation)
    raise UnsupportedOperation.new("Invalid operator.") if !ALLOWED_OPERATIONS.include?(operation)
    raise ArgumentError if !first_operand.is_a?(Numeric) or !second_operand.is_a?(Numeric)
    return "Division by zero is not allowed." if operation == '/' and second_operand == 0
    result = case operation
      when '+'
        first_operand + second_operand
      when '/'
        first_operand / second_operand
      when '*'
        first_operand * second_operand
    end
    return "#{first_operand} #{operation} #{second_operand} = #{result}"
  end
end
