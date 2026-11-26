defmodule FlattenArray do
  @spec flatten(list) :: list
  def flatten([h | t]) when h == nil, do: flatten(t)
  def flatten([h | t]), do: flatten(h) ++ flatten(t)
  def flatten([]), do: []
  def flatten(h), do: [h]
end
