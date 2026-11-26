class CollatzConjecture
  def self.steps(decimal_number)
    new(decimal_number).steps
  end

  def initialize(decimal_number)
    raise ArgumentError unless decimal_number > 0

    @decimal_number = decimal_number
    @steps = calculate
  end

  attr_reader :steps

  private

  def calculate
    num = @decimal_number.dup
    steps = 0

    while num != 1
      num = num.even? ? (num / 2) : (num * 3 + 1)
      steps += 1
    end

    steps
  end
end