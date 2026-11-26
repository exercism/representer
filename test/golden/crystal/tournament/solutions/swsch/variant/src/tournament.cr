module Tournament
  class Score
    include Comparable(Score)
    property name : String
    property wins : Int32 = 0
    property draws : Int32 = 0
    property losses : Int32 = 0

    def initialize(@name)
    end

    def points
      wins * 3 + draws
    end

    def matches
      wins + draws + losses
    end

    def <=>(other : Score)
      dp = other.points - self.points
      if dp != 0
        self.name <=> other.name
      else
        dp
      end
    end

    def tally_home(result : String)
      case result
      when "win"  then @wins += 1
      when "draw" then @draws += 1
      when "loss" then @losses += 1
      else             raise ArgumentError.new("invalid result")
      end
    end

    def tally_away(result : String)
      case result
      when "win"  then @losses += 1
      when "draw" then @draws += 1
      when "loss" then @wins += 1
      else             raise ArgumentError.new("invalid result")
      end
    end
  end

  def self.tally(lines : Array(String)) : Array(String)
    scores = Hash(String, Score).new { |hash, key| hash[key] = Score.new(key) }
    data = lines.map(&.split(';'))
    data.each do |(home, away, result)|
      scores[home].tally_home(result)
      scores[away].tally_away(result)
    end
    table = ["Team                           | MP |  W |  D |  L |  P"]
    scores.values.sort!.each do |score|
      table << sprintf("%-30s | %2d | %2d | %2d | %2d | %2d", score.name, score.matches, score.wins, score.draws, score.losses, score.points)
    end
    table
  end
end
