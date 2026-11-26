# Returns the string `Hello` with the input string name.
#
# + planet - planet name as a string
# + seconds - person's age measured in seconds
# + return - person's age in years of that planet, or error if unknown planet.

function age(string planet, int seconds) returns float|error {
    
    map<decimal> orbital_period = {
        "Mercury": 0.2408467,
        "Venus": 0.61519726,
        "Earth": 1.0,
        "Mars": 1.8808158,
        "Jupiter": 11.862615,
        "Saturn": 29.447498,
        "Uranus": 84.016846,
        "Neptune": 164.79132
    };

    if !orbital_period.hasKey(planet) { return error("not a planet");}
    float earth_sec_per_year = 31557600;
    return (<float>seconds / earth_sec_per_year / <float>orbital_period[planet]).round(2);
}
