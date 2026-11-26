module SpaceAge

type Planet =
    | Earth
    | Mercury
    | Venus
    | Mars
    | Jupiter
    | Saturn
    | Uranus
    | Neptune

let age (planet: Planet) (seconds: int64): float =
    let earthOrbitalPeriodsInSeconds = 31557600L

    let orbitalPeriods =
        Map.empty.Add(Earth, 1.0).Add(Mercury, 0.2408467).Add(Venus, 0.61519726).Add(Mars, 1.8808158)
           .Add(Jupiter, 11.862615).Add(Saturn, 29.447498).Add(Uranus, 84.016846).Add(Neptune, 164.79132)

    let multiplier = orbitalPeriods.[planet]
    float seconds / float earthOrbitalPeriodsInSeconds / multiplier
