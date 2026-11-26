class SimpleCalculator
  class UnsupportedOperation < StandardError
  end

  ALLOWED_OPERATIONS = ['+', '/', '*'].freeze

  def self.calculate(first_operand, second_operand, operation)
    if ALLOWED_OPERATIONS.include?(operation) == false or operation == nil
      raise UnsupportedOperation
    end

    if first_operand.is_a?(Integer) == false or second_operand.is_a?(Integer) == false
      raise ArgumentError
    end

    if second_operand == 0 and operation == '/'
        return "Division by zero is not allowed."
    end

    if operation == '+'
      result = first_operand + second_operand
    elsif operation == '/'
      result = first_operand / second_operand
    else
      result = first_operand * second_operand
    end

    "#{first_operand} #{operation} #{second_operand} = #{result}"
  end
end
