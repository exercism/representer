constant planets = {{"Mercury",0.2408467},
                    {"Venus",0.61519726},
                    {"Earth",1.0},
                    {"Mars",1.8808158},
                    {"Jupiter",11.862615},
                    {"Saturn",29.447498},
                    {"Uranus",84.016846},
                    {"Neptune",164.79132}}
constant year_in_seconds = 365.25 * 24 * 60 / 60

public function ageOn(sequence planet, integer seconds) 
  for i=1 to length(planets) do
    if equal(planet,planets[i][1]) then
      return seconds/year_in_seconds/planets[i][2]
    end if
  end for
  return 0
end function
