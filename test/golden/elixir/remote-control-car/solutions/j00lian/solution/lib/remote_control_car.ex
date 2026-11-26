defmodule RemoteControlCar do
  @enforce_keys [
    :battery_percentage,
    :distance_driven_in_meters,
    :nickname
  ]
  
  defstruct [
    :battery_percentage,
    :distance_driven_in_meters,
    :nickname
  ]

  def new(nickname \\ "none") do
   %RemoteControlCar{
      battery_percentage: 100,
      distance_driven_in_meters: 0,
      nickname: nickname
    }
  end

  def display_distance(%RemoteControlCar{distance_driven_in_meters: meters}) do
    "#{meters} meters"
  end

  def display_battery(%RemoteControlCar{battery_percentage: percentage}) do
    case percentage do
      0 -> "Battery empty"
      _ -> "Battery at #{percentage}%"
    end
  end

  def drive(%RemoteControlCar{battery_percentage: 0} = remote_car) do
    remote_car
  end

  def drive(%RemoteControlCar{} = remote_car) do

    {:ok, battery_percentage} = remote_car |> Map.fetch(:battery_percentage)
    battery_percentage = battery_percentage - 1
    remote_car = %{remote_car | battery_percentage: battery_percentage }

    {:ok, distance_driven_in_meters} = remote_car |> Map.fetch(:distance_driven_in_meters)
    distance_driven_in_meters = distance_driven_in_meters + 20
    remote_car = %{remote_car | distance_driven_in_meters: distance_driven_in_meters}
    
    remote_car
  end
end
