# Please implement your solution to leap in this file

class Year
  def self.leap?(y)
    y % 4 == 0 && (y % 100 != 0 || y % 400 == 0)
  end
end