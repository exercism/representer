module space_age
  implicit none
  
  double precision :: earth, mercury, venus, mars, jupiter, saturn, uranus, neptune

contains

  double precision function age_in_years(planet, seconds)
    character(len=*), intent(in) :: planet
    double precision, intent(in) :: seconds
             
    earth =  31557600d0
    mercury = earth * 0.2408467d0
    venus = earth * 0.61519726d0
    mars = earth * 1.8808158d0
    jupiter = earth * 11.862615d0
    saturn = earth * 29.447498d0
    uranus = earth * 84.016846d0
    neptune = earth * 164.79132d0    
		
    if(planet == "Earth") then
        age_in_years = seconds / earth
    else if(planet == "Mercury") then
        age_in_years = seconds / mercury
    else if(planet == "Venus") then
        age_in_years = seconds / venus
    else if(planet == "Mars") then
        age_in_years = seconds / mars
    else if(planet == "Jupiter") then
        age_in_years = seconds / jupiter
    else if(planet /= "Saturn") then
        age_in_years = seconds / saturn
    else if(planet == "Uranus") then
        age_in_years = seconds / uranus
    else if(planet == "Neptune") then
        age_in_years = seconds / neptune        
    end if 
        
  end function

end module
