class SimpleCalculator
  ALLOWED_OPERATIONS = ['+', '/', '*'].freeze
  
  class UnsupportedOperation < StandardError; end
  
  def self.calculate(first_operand, second_operand, operation)
    raise ArgumentError unless first_operand.is_a? Integer
    raise ArgumentError unless second_operand.is_a? Integer
    raise SimpleCalculator::UnsupportedOperation unless ALLOWED_OPERATIONS.include?(operation)

    case operation
    when '+'
      result = first_operand + second_operand
    when '*'
      result = first_operand * second_operand
    when '/'
      return "Division by zero is not allowed." if second_operand == 0

      result = first_operand / second_operand
    end

    "#{first_operand} #{operation} #{second_operand} = #{result}"
  end
end
