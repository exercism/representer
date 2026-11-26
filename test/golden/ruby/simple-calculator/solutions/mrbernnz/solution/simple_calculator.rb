class SimpleCalculator
  ALLOWED_OPERATIONS = ['+', '/', '*'].freeze
  UnsupportedOperation = ''

  def self.calculate(first_operand, second_operand, operator)
    evaluate(
      first_operand: first_operand,
      second_operand: second_operand,
      operator: operator
    )
  rescue ZeroDivisionError => e
    'Division by zero is not allowed.'
  end

  def self.validate_argument_type(first_operand:, second_operand:)
    raise(ArgumentError) unless first_operand.is_a?(Integer) && second_operand.is_a?(Integer)

  end

  def self.validate_operator(operator:)
    raise(SimpleCalculator::UnsupportedOperation) unless SimpleCalculator::ALLOWED_OPERATIONS.include?(operator)
  end

  def self.evaluate(first_operand:, second_operand:, operator:)
    validate_argument_type(first_operand: first_operand, second_operand: second_operand)

    validate_operator(operator: operator)

    result = first_operand.method(operator).call(second_operand)

    "#{first_operand} #{operator} #{second_operand} = #{result}"
  end

  private_class_method  :evaluate, :validate_operator, :validate_argument_type
end
