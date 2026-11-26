class Yacht
  def initialize(dice, category)
    @category = category
    @dice     = dice.sort
  end

  def score
    case @category
    when 'ones'   then sum_number(1)
    when 'twos'   then sum_number(2)
    when 'threes' then sum_number(3)
    when 'fours'  then sum_number(4)
    when 'fives'  then sum_number(5)
    when 'sixes'  then sum_number(6)
    when 'full house'
      case groups
      in [[_, _, _], [_, _]] then @dice.sum
      in [[_, _], [_, _, _]] then @dice.sum
      in _                   then 0
      end
    when 'four of a kind'
      case groups
      in [[_, _, _, _, _]]             then @dice[1..].sum
      in [[_], [_, _, _, _] => values] then values.sum
      in [[_, _, _, _] => values, [_]] then values.sum
      in _                             then 0
      end
    when 'little straight' then @dice == [1, 2, 3, 4, 5] ? 30 : 0
    when 'big straight'    then @dice == [2, 3, 4, 5, 6] ? 30 : 0
    when 'choice'          then @dice.sum
    when 'yacht'           then groups.one? ? 50 : 0
    else 0
    end
  end

  private

  def sum_number(n)
    @dice.sum { |m| m == n ? m : 0 }
  end

  def groups
    @dice.group_by(&:itself).values
  end
end
