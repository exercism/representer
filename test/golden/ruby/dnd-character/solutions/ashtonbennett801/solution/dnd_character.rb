class DndCharacter
  attr_reader :strength, :dexterity, :constitution, :intelligence, :wisdom , :charisma
  
  def self.modifier(input)
    ((input - 10) / 2).floor
  end

  def initialize
    @strength = rand(3..18)
    @dexterity = rand(3..18)
    @constitution = rand(3..18)
    @intelligence = rand(3..18)
    @wisdom = rand(3..18)
    @charisma = rand(3..18)
  end

  def hitpoints
    10 + DndCharacter.modifier(@constitution)
  end
end