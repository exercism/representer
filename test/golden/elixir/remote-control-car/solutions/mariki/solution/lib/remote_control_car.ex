defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct [:nickname, battery_percentage: 100, distance_driven_in_meters: 0]

  def new(nickname \\ "none") do
    %RemoteControlCar{nickname: nickname}
  end

  def display_distance(%RemoteControlCar{} = remote_car) do
    "#{remote_car.distance_driven_in_meters} meters"
  end

  def display_battery(%RemoteControlCar{battery_percentage: battery}) do
      case battery do
        0 -> "Battery empty"
        _ -> "Battery at #{battery}%"
      end
  end

  def drive(car = %RemoteControlCar{
    battery_percentage: battery, 
    distance_driven_in_meters: distance
  }) do
    case battery do
      0 -> car
      _ -> %{car | distance_driven_in_meters: distance + 20,
            battery_percentage: battery - 1}
    end
  end
end
