module Chess
  FILES = 'A'..'H'
  RANKS = 1..8

  def self.valid_square?(rank, file)
    RANKS.includes?(rank) && FILES.includes?(file)
  end

  def self.nickname(first_name, last_name)
    "#{first_name[0..1]}#{last_name[-2..]}".upcase
  end

  def self.move_message(first_name, last_name, square)
    if valid_square?(file: square[0], rank: square[1].to_i)
      "#{nickname(first_name, last_name)} moved to #{square}"
    else
      "#{nickname(first_name, last_name)} attempted to move to #{square}, but that is not a valid square"
    end
  end
end
