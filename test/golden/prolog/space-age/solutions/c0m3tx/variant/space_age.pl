space_age_ratio("Mercury", 0.2408467).
space_age_ratio("Venus", 0.61519726).
space_age_ratio("Earth", 1.0).
space_age_ratio("Mars", 1.8808158).
space_age_ratio("Jupiter", 11.862615).
space_age_ratio("Saturn", 29.447498).
space_age_ratio("Uranus", 84.016846).
space_age_ratio("Neptune", 164.79132).

space_age(Planet, AgeSec, Years) :-
    space_age_ratio(Planet, Ratio),
    Years = AgeSec * 31557600 / Ratio.