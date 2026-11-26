class Allergies
  ALLERGEN_SCORES = {
    'eggs' => 1,
    'peanuts' => 2,
    'shellfish' => 4,
    'strawberries' => 8,
    'tomatoes' => 17,
    'chocolate' => 32,
    'pollen' => 64,
    'cats' => 128,
  }

  attr_reader :score

  def initialize(score)
    @score = score
  end

  def allergic_to?(food)
    (score & ALLERGEN_SCORES[food]).nonzero?
  end

  def list
    ALLERGEN_SCORES.keys.select { |food| allergic_to?(food) }
  end
end