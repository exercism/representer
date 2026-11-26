class PartyRobot
  def self.welcome(name : String) : String
    "Welcome to my party, #{name}!"
  end

  def self.happy_birthday(name : String, age : Int) : String
    "Happy birthday #{name}! You are now #{age} years old!"
  end

  def self.assign_table(name : String, direction : String, table : Int, distance : Float64, neighbor : String) : String
    "Welcome to my party, #{name}!\n" + "You have been assigned to table #{table}. Your table is #{direction}, exactly #{distance.round(1)} meters from here.\n" + "You will be sitting next to #{neighbor[0]}#{neighbor[-1]}."
  end
end


# "Welcome to my party, Chihiro!\n" + "You have been assigned to table 22. Your table is straight ahead, exactly 9.2 meters from here.\n" + "You will be sitting next to Ai." 

# "Welcome to my party, Chihiro!\n" + "You have been assigned to table 22. Your table is on the straight ahead, exactly 9.2 meters from here.\n" + "You will be sitting next to Ai."