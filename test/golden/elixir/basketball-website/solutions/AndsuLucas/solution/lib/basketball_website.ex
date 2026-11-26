defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    data |> get_data(String.split(path, "."))
  end

  defp get_data(data, [head | []]) do 
    if not is_map(data) do
      nil
    else
      data[head]
    end
  end

  defp get_data(data, [head | tail])  do
    info = data[head]
    info |> get_data(tail)
  end

  def get_in_path(data, path) do
     data |> extract_from_path(path)
  end
end

data = %{
  "team_mascot" => %{
    "animal" => "bear",
    "actor" => %{
      "first_name" => "Noel"
    }
  }
}

# String.split("x.t", ".");
#Enum.map(data, fn (k) -> IO.inspect k end)
BasketballWebsite.extract_from_path(data, "team_mascot.actor.first_name.nil")
