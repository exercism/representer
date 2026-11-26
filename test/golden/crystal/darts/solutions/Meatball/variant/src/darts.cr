# Please implement your solution to darts in this file
class Darts
  def self.score(x,y)
    hypotenusan = Math.hypot(x,y)
    if hypotenusan <= 1
      return 10
    elsif hypotenusan < 5
      return 5
    elsif hypotenusan <= 10
      return 1
    end
    0
  end
end