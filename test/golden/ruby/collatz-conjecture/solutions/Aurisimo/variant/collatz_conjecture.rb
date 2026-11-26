class CollatzConjecture
  def self.steps(number)
    raise ArgumentError if number < 1
    
    reminder = number
    count = 0
    while reminder >= 1 do
      count += 1
      reminder = reminder.even? ? reminder / 2 : 3 * reminder + 1
    end
    count
  end
end