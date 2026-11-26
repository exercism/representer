defmodule Username do
  @a2z Enum.to_list(?a..?z)
  @underscore '_'
  @allowed_chars @a2z ++ @underscore

  @german2latin %{
    ?ä => 'ae',
    ?ö => 'oe',
    ?ü => 'ue',
    ?ß => 'ss'
  }

  def sanitize([hd | tl]) do
    hd
    |> case do
      hd when hd in @allowed_chars -> [hd]
      hd when is_map_key(@german2latin, hd) -> @german2latin[hd]
      _ -> ''
    end
    |> Kernel.++(sanitize(tl))
  end

  def sanitize([]), do: []
end
