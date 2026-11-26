class SimpleCalculator
  class UnsupportedOperation < StandardError
  end

  ALLOWED_OPERATIONS = ['+', '/', '*'].freeze

  def self.calculate(first_operand, second_operand, operation)
    raise ArgumentError.new unless first_operand.is_a?(Integer) && second_operand.is_a?(Integer)
    raise UnsupportedOperation.new unless ALLOWED_OPERATIONS.include? operation
    return "Division by zero is not allowed." if operation == '/' && second_operand == 0

   "#{first_operand} #{operation} #{second_operand} = #{result(first_operand, second_operand, operation)}"
  end

  def self.result(first_operand, second_operand, operation)
    case operation
    when '+'
      first_operand + second_operand
    when '/'
      first_operand / second_operand
    when '*'
      first_operand * second_operand
    end
  end
end
