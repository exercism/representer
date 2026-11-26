defmodule KitchenCalculator do
  #This is a constant with a map
  @milliliter_convertion %{
    :cup => 240,
    :fluid_ounce => 30,
    :teaspoon => 5,
    :tablespoon => 15,
    :milliliter => 1
  }

  def get_volume({_unit, volume}), do: volume

  def to_milliliter(volume_pair), do: {:milliliter, get_volume(volume_pair) * @milliliter_convertion[elem(volume_pair, 0)] }

  def from_milliliter(volume_pair, unit), do: {unit, get_volume(volume_pair) * @milliliter_convertion[unit] }
  
  def convert(volume_pair, unit) do
    #This is called chaining 
    volume_pair
    |>to_milliliter()
    |>from_milliliter(unit)
  end
end
