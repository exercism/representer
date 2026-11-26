defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct [:nickname, distance_driven_in_meters: 0, battery_percentage: 100]

  def new(nickname \\ "none") do
    %__MODULE__{nickname: nickname}  
  end

  def display_distance( %__MODULE__{distance_driven_in_meters: d}), do: "#{d} meters"

  def display_battery(%__MODULE__{battery_percentage: 0}), do: "Battery empty"
  def display_battery(%__MODULE__{battery_percentage: b}), do: "Battery at #{b}%"
  
  def drive(c = %__MODULE__{battery_percentage: 0}) do
      %{c | battery_percentage: 0, distance_driven_in_meters: 0}
  end
  def drive(c = %__MODULE__{battery_percentage: b, distance_driven_in_meters: d}) do
      %{c | battery_percentage: b - 1, distance_driven_in_meters: d + 20}
  end
end
