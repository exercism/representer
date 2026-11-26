constant planet_ratios = {
  { "Mercury", 0.2408467 },
  { "Venus", 0.61519726 },
  { "Earth", 1 },
  { "Mars", 1.8808158 },
  { "Jupiter", 11.862615 },
  { "Saturn", 29.447498 },
  { "Uranus", 84.016846 },
  { "Neptune", 164.79132 }
}

public function ageOn(sequence planet, integer seconds) 
  for i = 1 to length(planet_ratios) do
    if compare(planet, planet_ratios[i][1]) = 0 then
      return seconds / 31_557_600 * planet_ratios[i][2]
    end if
  end for
  return 0
end function
