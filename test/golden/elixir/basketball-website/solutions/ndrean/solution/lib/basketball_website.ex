defmodule BasketballWebsite do

  defp find([],d), do: d
  defp find([t | h], d ), do: find(h, d[t])

  def extract_from_path(data, path) do
    String.split(path, ".") |> find(data)
  end

  def get_in_path(data, path) do
    get_in(data, String.split(path, "."))

    #String.split(path, ".")
    #|> Enum.reduce(data, fn key,list -> list[key] end)
  end
end
