defmodule Username do
  def sanitize(username) do
    username
    |> _sanitize()
  end

  @spec _sanitize(username :: charlist()) :: charlist()
  def _sanitize([]), do: []

  def _sanitize([head | tail]) do
    case head do
      ?ä ->
        'ae' ++ _sanitize(tail)

      ?ö ->
        'oe' ++ _sanitize(tail)

      ?ü ->
        'ue' ++ _sanitize(tail)

      ?ß ->
        'ss' ++ _sanitize(tail)

      ?_ ->
        [head | _sanitize(tail)]

      head when head not in ?a..?z ->
        _sanitize(tail)

      _ ->
        [head | _sanitize(tail)]
    end
  end
end
