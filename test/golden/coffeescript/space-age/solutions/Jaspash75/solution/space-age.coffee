class SpaceAge
  EARTH_YEAR_IN_SECONDS = 31557600

  ORBITAL_PERIODS =
    Earth: 1.0
    Mercury: 0.2408467
    Venus: 0.61519726
    Mars: 1.8808158
    Jupiter: 11.862615
    Saturn: 29.447498
    Uranus: 84.016846
    Neptune: 164.79132

  @ageOnPlanet: (seconds, planet) ->
    earthYears = seconds / EARTH_YEAR_IN_SECONDS
    planetYears = earthYears / ORBITAL_PERIODS[planet]
    Number(planetYears.toFixed(2))

  @onEarth: (seconds) -> @ageOnPlanet(seconds, 'Earth')
  @onMercury: (seconds) -> @ageOnPlanet(seconds, 'Mercury')
  @onVenus: (seconds) -> @ageOnPlanet(seconds, 'Venus')
  @onMars: (seconds) -> @ageOnPlanet(seconds, 'Mars')
  @onJupiter: (seconds) -> @ageOnPlanet(seconds, 'Jupiter')
  @onSaturn: (seconds) -> @ageOnPlanet(seconds, 'Saturn')
  @onUranus: (seconds) -> @ageOnPlanet(seconds, 'Uranus')
  @onNeptune: (seconds) -> @ageOnPlanet(seconds, 'Neptune')

module.exports = SpaceAge