# Implement the InvalidCowsError here
class InvalidCowsError < Exception
  def initialize(@message : String)
  end
end

module TheFarm
  def self.divide_food(food : FodderCalculator, number_of_cows : Int32)
    food.fodder_amount! / number_of_cows * food.fattening_factor!
  rescue
    0
  end

  def self.validate_input_and_divide_food(food : FodderCalculator, number_of_cows : Int32)
    if number_of_cows <= 0
      raise "Number of cows must be greater than 0"
    end

    divide_food food, number_of_cows
  end

  def self.validate_number_of_cows(number_of_cows : Int32)
    if number_of_cows < 0
      raise InvalidCowsError.new("#{number_of_cows} cows are invalid: there are no negative cows")
    elsif number_of_cows == 0
      raise InvalidCowsError.new("0 cows are invalid: no cows don't need food")
    end
  end
end
