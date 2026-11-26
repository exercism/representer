class SimpleCalculator
  UnsupportedOperation = StandardError
  ALLOWED_OPERATIONS = ['+', '/', '*'].freeze
    def self.calculate(first_operand, second_operand, operation)
    raise ArgumentError.new() unless first_operand.is_a?(Integer) && second_operand.is_a?(Integer)
    result = case operation
      when '+'
       first_operand + second_operand
      when '/'
        begin  
         first_operand / second_operand
        rescue
          return "Division by zero is not allowed."
        end
      when '*'
         first_operand * second_operand
      else
        raise UnsupportedOperation.new()
    end
    "#{first_operand} #{operation} #{second_operand} = #{result}"
  end
end
