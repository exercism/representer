class HighScores
  property scores : Array(Int32)

  def initialize(@scores)
  end

  def latest
    scores[-1]
  end

  def personal_best
    scores.max
  end

  def personal_top_three
    scores.max(4)
  end
end
