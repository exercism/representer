class PartyRobot
  def self.welcome(name : String) : String
    "Welcome to my party, #{name}!"
  end

  def self.happy_birthday(name : String, age : Int) : String
    "Happy birthday #{name}! You are now #{age} years old!"
  end

  def self.assign_table(name : String, direction : String, table : Int, distance : Float64, neighbor : String) : String
    d = distance.round(1)
    n = neighbor.split(' ')[0]
    n = "" + n[0] + n[-1]
    "Welcome to my party, #{name}!
You have been assigned to table #{table}. Your table is #{direction}, exactly #{d} meters from here.
You will be sitting next to #{n}."
  end
end
