defmodule BasketballWebsite do
  def extract_from_path(data, path), do: extract(data, String.split(path, "."))

  defp extract(data, []), do: data
  defp extract(data, [key | rest]), do: extract(data[key], rest)

  def get_in_path(data, path), do: get_in(data, String.split(path, "."))
end
