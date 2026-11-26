defmodule Username do
  def sanitize([]) do
    []
  end


  def sanitize([head | tail]) do

    case head do
      head when head >= ?a and head <= ?z -> [head]
      ?_ -> [head]
      ?ü -> [?u, ?e]
      ?ä -> [?a, ?e]
      ?ö -> [?o, ?e]
      ?ß -> [?s, ?s]
      _ -> []
    end ++ sanitize(tail)
  end




end
