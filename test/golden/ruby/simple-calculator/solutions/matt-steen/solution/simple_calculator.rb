class SimpleCalculator
  ALLOWED_OPERATIONS = ['+', '/', '*'].freeze

  class UnsupportedOperation < StandardError
  end

  def self.calculate(first_operand, second_operand, operation)
    raise UnsupportedOperation.new("invalid operation: #{operation}") unless ALLOWED_OPERATIONS.include? operation

    if first_operand.class != Integer
      raise ArgumentError.new("invalid argument type: #{first_operand}")
    end

    if second_operand.class != Integer
      raise ArgumentError.new("invalid argument type: #{second_operand}")
    end
    
    answer = if operation == "+"
      first_operand + second_operand
    elsif operation == "/"
      if second_operand.zero?
        return "Division by zero is not allowed."
      end
  
      first_operand / second_operand
    elsif operation == "*"
      first_operand * second_operand
    end

    "#{first_operand} #{operation} #{second_operand} = #{answer}"
  end
end
