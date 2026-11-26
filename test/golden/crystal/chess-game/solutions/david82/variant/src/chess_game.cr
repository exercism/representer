module Chess
  extend self

  # Define the 'RANKS' constant
  RANKS = 1..8

  # Define the 'FILES' constant
  FILES = 'A'..'H'

  def valid_square?(rank : Int32, file : Char) : Bool
    RANKS.includes?(rank) || FILES.includes?(file)
  end

  def nickname(first_name : String, last_name : String) : String
    "#{first_name[0, 2]}#{last_name[-2, 2]}".upcase
  end

  def move_message(first_name : String, last_name : String, square : String) : String
    return "Invalid square format" unless square.size == 2

    nickname = nickname(first_name, last_name)
    rank = square[-1].to_i
    file = square[0]

    if valid_square?(rank, file)
      "#{nickname} moved to #{square}"
    else
      "#{nickname} attempted to move to #{square}, but that is not a valid square"
    end
  end
end
