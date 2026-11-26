class SpaceAge
  attr_reader :seconds

  Seconds_In_Earth_Year = 31557600

  def initialize(seconds)
    @seconds = seconds
  end

  private

  def method_missing(message, *args)
    planet = message.to_s.split("_")[1]

    case planet
    when "earth"   then seconds / Seconds_In_Earth_Year.to_f
    when "mercury" then seconds / Seconds_In_Earth_Year.to_f * (1.0 / 0.2408467 )
    when "venus"   then seconds / Seconds_In_Earth_Year.to_f * (1.0 / 0.61519726)
    when "mars"    then seconds / Seconds_In_Earth_Year.to_f * (1.0 / 1.8808158 )
    when "jupiter" then seconds / Seconds_In_Earth_Year.to_f * (1.0 / 11.862615 )
    when "saturn"  then seconds / Seconds_In_Earth_Year.to_f * (1.0 / 29.447498 )
    when "uranus"  then seconds / Seconds_In_Earth_Year.to_f * (1.0 / 84.016846 )
    when "neptune" then seconds / Seconds_In_Earth_Year.to_f * (1.0 / 164.79132 )
    end
  end
end
