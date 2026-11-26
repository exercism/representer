class Space::Age
  ORBIT_PERIOD_MERCURY      =  0.2408467
  ORBIT_PERIOD_VENUS        = 0.61519726
  ORBIT_PERIOD_EARTH        =        1.0
  ORBIT_PERIOD_MARS         =  1.8808158
  ORBIT_PERIOD_JUPITER      =  11.862615
  ORBIT_PERIOD_SATURN       =  29.447498
  ORBIT_PERIOD_URANUS       =  84.016846
  ORBIT_PERIOD_NEPTUNE      =  164.79132
  SECONDS_IN_ONE_EARTH_YEAR = 31_557_600

  def self.from_seconds(seconds : UInt64)
    instance = Space::Age.allocate
    instance.initialize(seconds)
    instance
  end

  def initialize(seconds : UInt64)
    @seconds = seconds
    @age_on_earth = @seconds / SECONDS_IN_ONE_EARTH_YEAR
  end

  def age_on_earth
    @age_on_earth / ORBIT_PERIOD_EARTH
  end

  def age_on_mercury
    @age_on_earth / ORBIT_PERIOD_MERCURY
  end

  def age_on_venus
    @age_on_earth / ORBIT_PERIOD_VENUS
  end

  def age_on_mars
    @age_on_earth / ORBIT_PERIOD_MARS
  end

  def age_on_jupiter
    @age_on_earth / ORBIT_PERIOD_JUPITER
  end

  def age_on_saturn
    @age_on_earth / ORBIT_PERIOD_SATURN
  end

  def age_on_uranus
    @age_on_earth / ORBIT_PERIOD_URANUS
  end

  def age_on_neptune
    @age_on_earth / ORBIT_PERIOD_NEPTUNE
  end
end
