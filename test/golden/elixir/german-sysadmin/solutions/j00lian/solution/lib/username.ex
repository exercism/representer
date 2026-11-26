defmodule Username do 
  def sanitize(username) do
    username
    |> Enum.reduce([], fn x, acc ->
      acc ++ case x do
        x when x >= ?a and x <= ?z -> [x]
        ?_ -> [x]
        ?ä -> 'ae'
        ?ü -> 'ue'
        ?ö -> 'oe'
        ?ß -> 'ss'
        _ -> ''
      end
    end)
  end
end
