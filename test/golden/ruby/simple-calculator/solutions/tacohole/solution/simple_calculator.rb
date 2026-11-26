class SimpleCalculator
  ALLOWED_OPERATIONS = ['+', '/', '*'].freeze

  class UnsupportedOperation < StandardError; end

  def self.calculate(first_operand, second_operand, operation)
    if first_operand.class != Integer || second_operand.class != Integer
      raise ArgumentError
    end
    
    case operation
      when '+' 
        result = first_operand + second_operand
      when  '/'
        begin
        result = first_operand / second_operand
        rescue ZeroDivisionError => e
          return "Division by zero is not allowed."
        end
      when '*'
        result = first_operand * second_operand
    else
      raise SimpleCalculator::UnsupportedOperation
    end
    return "#{first_operand} #{operation} #{second_operand} = #{result}"
  end
end
