defmodule Username do
  def sanitize([]), do: []
  def sanitize([head | tail]) do
    letter =
      case head do
        code when code >= ?a or code <= ?z -> [code]
        ?ä -> ~c"ae"
        ?ö -> ~c"oe"
        ?ü -> ~c"ue"
        ?ß -> ~c"ss"
        ?_ -> ~c"_"
        _other -> ~c""
      end

    letter ++ sanitize(tail)
  end
end
