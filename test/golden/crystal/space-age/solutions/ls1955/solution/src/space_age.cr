module Space
  class Age
    ONE_ORBITAL_YEAR_ON_EARTH_IN_SECONDS = 60 * 60 * 24 * 365.25

    def self.from_seconds(seconds)
      new(seconds)
    end

    getter :seconds

    def initialize(@seconds : Int32)
    end

    getter(age_on_earth : Float64) { seconds / ONE_ORBITAL_YEAR_ON_EARTH_IN_SECONDS }
    getter(age_on_jupiter : Float64) { age_on_earth / 11.862615 }
    getter(age_on_mars : Float64) { age_on_earth / 1.8808158 }
    getter(age_on_mercury : Float64) { age_on_earth / 0.2408467 }
    getter(age_on_neptune : Float64) { age_on_earth / 164.79132 }
    getter(age_on_saturn : Float64) { age_on_earth / 29.447498 }
    getter(age_on_uranus : Float64) { age_on_earth / 84.016846 }
    getter(age_on_venus : Float64) { age_on_earth / 0.61519726 }
  end
end