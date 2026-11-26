defmodule Darts do
  @type position :: {number, number}

  @spec score(position) :: integer
  def score({x, y}) do    
    
    distance = :math.sqrt(x*x + y*y)
    cond do         
         distance >5 && distance <=10 -> 1
         distance >1 && distance <=5 -> 5
         distance >=0 && distance <=1 -> 10
        true -> 0
    end

  end
end
