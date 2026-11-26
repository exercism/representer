defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct [:nickname, battery_percentage: 100, distance_driven_in_meters: 0]

  def new(nickname \\ "none") do
    %RemoteControlCar{nickname: nickname}
  end

  def display_distance(%RemoteControlCar{nickname: _, battery_percentage: _, distance_driven_in_meters: d}) do
    "#{d} meters"
  end

  def display_battery(%RemoteControlCar{nickname: _, battery_percentage: b, distance_driven_in_meters: _}) do
    case b do
      0 -> "Battery empty"
      _ -> "Battery at #{b}%"
    end
  end

  def drive(%RemoteControlCar{nickname: n, battery_percentage: b, distance_driven_in_meters: d}) do
    if b > 0 do
      %RemoteControlCar{nickname: n, battery_percentage: b - 1, distance_driven_in_meters: d + 20}
    else
      %RemoteControlCar{nickname: n, battery_percentage: b, distance_driven_in_meters: d}
    end
  end
end
