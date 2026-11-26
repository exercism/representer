defmodule Rectangles do
  @doc """
  Count the number of ASCII rectangles.
  """
  @spec count(input :: String.t()) :: integer
  def count(input) do
    rows = input
           |> String.split("\n")
           |> Enum.map(&(Enum.with_index(String.graphemes(&1))))
           |> Enum.with_index()
    map = for {row,y} <- rows, reduce: %{} do
            map -> for {el,x} <- row, el != " ", reduce: map do
                     map -> Map.put(map,{x,y},el)
                   end
          end
    crosses = for {pos,"+"} <- map, into: MapSet.new(), do: pos
    minuses = for {pos,"-"} <- map, into: MapSet.new(), do: pos
    bars    = for {pos,"|"} <- map, into: MapSet.new(), do: pos

    hori = MapSet.union(crosses,minuses)
    vert = MapSet.union(crosses,bars)

    for {x0,y0} <- crosses,
        {x1,y1} <- crosses, 
        x0 < x1, 
        y0 < y1, 
        Enum.all?(x0..x1,&({&1,y0} in hori && {&1,y1} in hori)),
        Enum.all?(y0..y1,&({x0,&1} in vert && {x1,&1} in vert)) do
      :rect
    end |> length()
  end
end
