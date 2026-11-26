static double age(String planet, long seconds) {
    def orbitalPeriods = [
        'Earth': 1.0,
        'Mercury': 0.2408467,
        'Venus': 0.61519726,
        'Mars': 1.8808158,
        'Jupiter': 11.862615,
        'Saturn': 29.447498,
        'Uranus': 84.016846,
        'Neptune': 164.79132
    ]
    
    def earthOrbitalPeriod = 31557600 // Earth's orbital period in seconds
    def orbitalPeriod = orbitalPeriods[planet]
    
    return (seconds / (earthOrbitalPeriod / orbitalPeriod)).round(2)
}

def spaceAge = age('Earth', 1000000000)
println spaceAge // Should print 31.69
