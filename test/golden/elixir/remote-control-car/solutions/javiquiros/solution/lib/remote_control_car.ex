defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct [:nickname, battery_percentage: 100, distance_driven_in_meters: 0]

  def new(nickname \\ "none") do
    %RemoteControlCar{nickname: nickname}
  end

  def display_distance(%RemoteControlCar{distance_driven_in_meters: distance}), do: "#{distance} meters"

  def display_battery(%RemoteControlCar{battery_percentage: 0}), do: "Battery empty"
  def display_battery(%RemoteControlCar{battery_percentage: battery}), do: "Battery at #{battery}%"

  def drive(%RemoteControlCar{battery_percentage: 0} = car), do: car
  def drive(%RemoteControlCar{distance_driven_in_meters: distance, battery_percentage: battery} = car) do
    %{car | distance_driven_in_meters: distance + 20, battery_percentage: battery - 1}
  end
end
